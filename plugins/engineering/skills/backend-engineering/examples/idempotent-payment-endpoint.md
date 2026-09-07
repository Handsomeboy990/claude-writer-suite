# Example: an idempotent charge endpoint

Requirement: charge a saved card for an order. The client may retry. The
provider may time out after having succeeded.

## The hard constraint

A network timeout does not tell you whether the charge happened. Any design
that assumes it does will double charge customers, and the incident will be
discovered by the customers.

## Layering

```
app/api/orders/[id]/pay/route.ts   handler
lib/services/payments.ts           business rules and transaction boundary
lib/data/orders.ts                 queries
lib/providers/stripe.ts            provider client with timeout and retry
```

## Handler, in the mandatory order

```ts
export async function POST(req: Request, { params }: Ctx) {
  const session = await requireSession()                      // 1 authenticate

  const p = payParams.safeParse(await params)                 // 2 validate
  if (!p.success) return badRequest(p.error)

  const key = req.headers.get("idempotency-key")
  const body = paySchema.safeParse({ ...(await readJson(req)), key })
  if (!body.success) return badRequest(body.error)

  const order = await getOrderForUser(p.data.id, session.userId)  // 3 authorize
  if (!order) return notFound()                               // hidden, not 403

  try {
    const result = await payOrder(order, body.data)           // 4 service
    return Response.json(toPaymentResponse(result))           // 5 map
  } catch (error) {
    if (error instanceof PaymentDeclined) {                   // 6 map failures
      return unprocessable("card_declined", { message: error.publicMessage })
    }
    if (error instanceof OrderNotPayable) {
      return conflict("order_not_payable")
    }
    logger.error("payment.failed", {                          // 7 log
      orderId: order.id, userId: session.userId, error,
    })
    return internalError()
  }
}
```

`getOrderForUser` scopes by owner in the query itself. There is no version of
this handler that fetches by id and then compares, because the comparison is
the line that gets deleted during a refactor.

## Amount authority

```ts
// lib/services/payments.ts
const amountMinor = order.lines.reduce(
  (sum, line) => sum + line.unitPriceMinor * line.quantity,
  0,
) - order.discountMinor
```

The request body contains no amount and no currency. Both come from the order,
which was built from stored prices. The endpoint accepts an order id and an
idempotency key, nothing else that touches money.

## Idempotency, three layers deep

**1. The database.** A unique index on `payment_attempts (idempotency_key)`.
This is the only mechanism that survives two concurrent requests on two
instances; everything else is an optimisation on top of it.

```sql
create unique index payment_attempts_key_uniq
  on payment_attempts (idempotency_key);
```

**2. The service.** Insert the attempt row first, in its own transaction. A
unique violation means the request is a repeat: return the stored outcome
rather than charging again.

```ts
const attempt = await recordAttempt(order.id, input.key)
if (attempt.status === "duplicate") return attempt.storedResult
```

**3. The provider.** Pass the same key to the provider, so that even if the
attempt row and the provider call disagree, the provider itself refuses the
second charge.

Three layers because each one fails differently: the row can be inserted and
the process can die before the call, the call can succeed and the response can
be lost, and the client can retry with a new key by mistake.

## The timeout case

```ts
// lib/providers/stripe.ts
const charge = await stripe.paymentIntents.create(
  { amount, currency, customer, confirm: true },
  { idempotencyKey: key, timeout: 15_000, maxNetworkRetries: 2 },
)
```

On timeout, the attempt row stays in `pending`. A reconciliation job reads
pending attempts older than two minutes, asks the provider what happened using
the same key, and settles the row. The endpoint never guesses.

Without that job, a timeout leaves a customer whose card was charged and whose
order says unpaid, and the only way anyone finds out is a support message.

## Transaction boundary

```ts
// Outside the transaction: the provider call.
const charge = await chargeCard(order, input.key)

// Inside: everything that must agree with it.
await db.transaction(async (tx) => {
  await markAttemptSucceeded(tx, attempt.id, charge.id)
  await markOrderPaid(tx, order.id, charge.id)
  await writeLedgerEntry(tx, order, charge)
})
```

The provider call is deliberately outside. A fifteen second external call
inside a transaction holds row locks for fifteen seconds, and under load that
is how a database runs out of connections.

## Tests, including the ones that hurt

```
charges the stored amount, ignoring any amount in the body      ok
returns 404 for an order belonging to another user              ok
returns 409 when the order is already paid                      ok
returns 422 on a declined card, with no provider text leaked    ok
two sequential requests with the same key charge once           ok
two concurrent requests with the same key charge once           ok
a provider timeout leaves the attempt pending, order unpaid     ok
reconciliation settles a pending attempt from the provider      ok
no network call happens inside the transaction                  ok
```

The last test is unusual and worth keeping: it asserts on the instrumented
client that no call was made between transaction begin and commit. It is the
only cheap way to stop that regression from returning.

## What is logged

```
payment.attempt.started    orderId, userId, keyHash
payment.attempt.succeeded  orderId, chargeId, amountMinor, currency
payment.attempt.declined   orderId, declineCode
payment.attempt.pending    orderId, keyHash, reason: timeout
payment.failed             orderId, userId, error
```

The idempotency key is hashed rather than logged, since it is client supplied
and can be replayed. The card is never present in any form. Amounts are logged
because reconstructing a money incident without them is impossible.
