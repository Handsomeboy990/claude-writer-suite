# Example: hunting a checkout that passes its happy path

Feature: single item checkout, test mode payments, staging.
Entry condition met: the happy path passes, order created, mail sent, stock
decremented.

## Repetition

```
Move     click Pay twice within 200 ms
Result   HIT. Two payment intents created. One order. Stock decremented once.
         The second intent stays open and expires 30 minutes later.
Freq     3 of 3
Minimal  add item, go to checkout, double click Pay
Evidence network log shows two POST /api/checkout, both 200, different ids
Impact   the customer sees one order and one authorisation hold they cannot
         explain. Support cost, not data loss.
Severity High
```

## Concurrency

```
Move     the same cart in two tabs, Pay in both within one second
Result   HIT, worse. Two orders, stock decremented twice, one payment
         captured, one authorised. Inventory now wrong by one unit.
Freq     2 of 3
Minimal  same cart, two tabs, pay in both
Impact   inventory drift and a customer charged for an order that exists twice
Severity Critical
Note     same root cause as the repetition hit: no idempotency key on the
         checkout endpoint. One fix closes both.
```

## Interruption

```
Move     reload during the payment redirect
Result   ok. Returns to a pending order page that polls and resolves.
Move     browser back after the confirmation page
Result   HIT. Back returns to the checkout form with the cart still populated.
         Paying again creates a second order for an already paid cart.
Freq     3 of 3
Severity High
```

## Session

```
Move     let the session expire on the checkout page, then pay
Result   ok. Redirects to login, returns to the checkout, cart preserved.
```

One family behaving correctly is recorded, because a report that only lists
failures tells the reader nothing about what was actually exercised.

## Network

```
Move     throttle to slow 3G, complete a payment
Result   HIT. The Pay button re-enables after 5 seconds while the request is
         still in flight, which is how the repetition defect reaches users who
         never double click deliberately.
Freq     3 of 3
Severity High
Note     this is the user visible cause of the first two hits. Fixing the
         client alone would hide the server defect rather than fix it.

Move     force the payment call to time out
Result   HIT. Interface shows "Payment failed". The payment was captured.
         The order exists in the provider and not in the application.
Freq     2 of 2
Severity Critical
Note     handed to reliability-testing for the recovery path and to
         backend-engineering for the reconciliation gap.
```

## Response

```
Move     return an empty items array for a cart the user filled
Result   ok. Empty state renders with a link back to the catalogue.
```

## Input

```
Move     quantity 0, then -1, then 99999
Result   HIT on 99999. Accepted by the client, rejected by the server with a
         500 and a message naming the stock table.
Freq     3 of 3
Severity Medium, but the leaked column name is reported to security-testing
```

## Sequence

```
Move     bookmark the confirmation URL, revisit after the order ships
Result   ok. Shows the current state, not the historical one.
```

## Environment

```
Move     360 px width
Result   HIT. The order summary table scrolls horizontally and the total is
         off screen at the moment the user is asked to pay.
Freq     3 of 3
Severity Medium
```

## Result sheet

```
family        result   note
repetition    hit      duplicate payment intent, High
concurrency   hit      duplicate order, inventory drift, Critical
interruption  hit      back allows paying a paid cart, High
session       ok       expiry handled, cart preserved
network       hit      button re-enables early, High. Captured payment
                       reported as failed, Critical
response      ok       empty cart renders correctly
input         hit      500 with a column name on quantity overflow, Medium
sequence      ok       stale confirmation link resolves to current state
environment   hit      total off screen at 360 px, Medium
```

## The conclusion that matters

Seven hits, but two root causes: no idempotency on the checkout endpoint, and
no reconciliation between the payment provider and the order table. The
severity list is what the report shows; the two causes are what gets fixed.
Both became permanent tests before the fix: an integration test for the
concurrent double checkout, and a stubbed timeout test proving the order is
recorded when the provider captures and the response never arrives.
