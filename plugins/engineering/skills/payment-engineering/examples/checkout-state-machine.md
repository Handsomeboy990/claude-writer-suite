# Example: a checkout that stays correct when the provider goes quiet

## The state machine, written before any handler

```
order
  draft            cart, no payment attempted
  pending          payment intent created, awaiting outcome
  paid             captured, confirmed by the provider
  failed           declined or abandoned, cart preserved
  refunded         fully refunded
  partly_refunded  one or more partial refunds
  disputed         chargeback opened

transitions
  draft   -> pending          on intent creation
  pending -> paid             on captured confirmation
  pending -> failed           on decline, or on expiry after 24 hours
  pending -> pending          on any unknown outcome, until resolved
  paid    -> refunded         on full refund
  paid    -> partly_refunded  on partial refund
  paid    -> disputed         on dispute webhook
  everything else             refused
```

The third line is the one that saves the system: an unknown outcome does not
move the order. It stays pending and a job resolves it.

## The write that guards the transition

```sql
update orders
   set status = 'paid', paid_at = now(), captured_amount = $2
 where id = $1
   and status = 'pending'
   and (paid_at is null);
```

Zero rows means the order was not pending. That is not an error: it means
another path already handled it, which happens every time a webhook and a
redirect race. The handler logs it with both identifiers and returns success.

## The amount, in one place

```
computeOrderTotal(orderId) reads the cart lines, the catalogue prices, the
  discount rules and the tax rules with their effective dates, and returns
  { amount: 4990, currency: "EUR", breakdown: [...] }

it is called
  when the cart is displayed
  when the intent is created
  when the capture is confirmed, to verify the provider's amount matches

the client never sends an amount. The request body is { orderId }.
```

The third call caught a real defect during testing: a discount expiring
between intent creation and capture produced a mismatch. The resolution was a
decision, not a patch: the quoted amount holds for 30 minutes, recorded on the
intent, and the comparison is against that.

## Idempotency key derivation

```
key = "order:" + orderId + ":attempt:" + attemptNumber

attemptNumber increments only when the customer deliberately retries after a
failure. A network retry, a double click and a redeployed worker all reuse the
same key, and the provider returns the original result.
```

Generating a fresh key per HTTP request, which is the obvious implementation,
would defeat the entire mechanism. That line is worth a comment in the code.

## The timeout after capture

The drill, run in the reliability pass:

```
inject     the provider captures, and the response never arrives
observe    the client times out after 10 seconds
           the order stays pending, not failed
           the interface says "we are confirming your payment" and polls
resolve    a job queries the provider for the intent status every 15 seconds
           for 5 minutes, then hands to reconciliation
result     the order becomes paid within 20 seconds, the customer sees a
           confirmation, and no second charge is possible because the retry
           carries the same key
```

Before this design, the same scenario produced: order failed, customer charged,
customer retries, customer charged twice, support ticket, refund, apology.

## Reconciliation, running from day one

```
nightly, comparing the provider's charge list with the orders table

reports
  charges with no order            0
  orders paid with no charge       0
  amount mismatches                0
  refunds on one side only         0
  orders pending over 24 hours     2   -> both abandoned checkouts, expected,
                                          transitioned to failed by the job
```

Empty reports are produced and kept. The day the report stops arriving, that
is itself the signal, which is why it is generated even when there is nothing
to say.

## What is never stored

```
no card number, no security code, no full bank details
the provider's customer and payment method references only
the last four digits and the brand, because the interface shows them
no payment payload in any log, verified by a test that asserts the logger
  redacts the provider's response object
```
