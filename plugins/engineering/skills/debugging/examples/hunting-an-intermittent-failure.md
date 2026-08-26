# Example: an intermittent defect, found by bisection

Report received: "sometimes the order confirmation email has the wrong total".

## Step 1, definition

```
Observed    the email shows a total lower than the amount charged
Expected    the email total equals the charged amount
Trigger     unknown at this point
Frequency   intermittent, about one order in forty per the support log
Scope       all environments, all users
Since       unknown, the first report is three weeks old
```

Frequency and scope already eliminate several families. One in forty, across
all users, is not a per user data problem and not an environment problem. It
is either a data dependent branch or a timing dependent one.

## Step 2, reproduction

The happy path test passes. Rather than replay orders blindly, the support log
gave nine order ids. Query:

```sql
select id, total_minor, discount_minor, created_at, updated_at
from orders where id in (...);
```

All nine have `discount_minor > 0` and `updated_at` within two seconds of
`created_at`. That is the trigger: a discount applied, and a second write
immediately after creation.

```
Trigger updated: an order with a coupon applied
Frequency explained: about one order in forty uses a coupon, confirmed by
select count(*) filter (where discount_minor > 0) / count(*)
```

Now the defect is reproducible on demand, which turns an intermittent bug into
a deterministic one. That conversion is most of the work.

## Step 3, evidence

```
git log --oneline -- lib/orders/confirm.ts
  8c1e2f4  send confirmation email from the order service
  2a9d7b1  apply coupon after order creation
```

`2a9d7b1` is nine days before the first report, which is consistent with a
three week old report and a slow support pipeline. Not proof, but it points
the bisection.

## Step 4, bisection

Cut at the service entry, then at the query result.

```
Cut 1  createOrder returns totalMinor 4900, correct
Cut 2  applyCoupon writes totalMinor 4410, correct in the database
Cut 3  the email payload carries totalMinor 4900, incorrect
```

The defect is between cut 2 and cut 3, three lines apart.

## Step 5, the code

```ts
// lib/orders/confirm.ts:18
const order = await createOrder(input)          // in memory object
await applyCoupon(order.id, input.couponCode)   // writes to the database
await sendConfirmation(order)                   // sends the stale object
```

## Step 6, root cause

```
Mechanism  the order object captured before applyCoupon is passed to the
           email, so the email renders the pre discount total while the
           charge uses the persisted post discount total
File       lib/orders/confirm.ts:18-20
Why now    2a9d7b1 moved coupon application after order creation without
           refreshing the object handed to the email
Impact     every order with a coupon, all users, since 2026-07-18
Related    lib/orders/confirm.ts:34 passes the same stale object to the
           analytics event, which under reports revenue discounts
```

The mechanism explains the frequency, one in forty, and the scope, everyone.
Both boxes from step 1 are now accounted for, which is the test that the cause
is the real one.

## Step 7, the test, written first

```ts
it("emails the discounted total when a coupon is applied", async () => {
  const order = await confirmOrder({ ...input, couponCode: "SAVE10" })
  expect(mailer.lastPayload.totalMinor).toBe(4410)
  expect(mailer.lastPayload.totalMinor).toBe(order.totalMinor)
})
```

```
Before fix: 1 failing
  expected 4410, received 4900
```

## Step 8, the fix

`applyCoupon` returns the updated order, and the caller uses it. The
alternative, re-reading the order, was rejected: an extra query to fix a
staleness that the return value already carries.

```ts
const order = await createOrder(input)
const finalOrder = await applyCoupon(order.id, input.couponCode)
await sendConfirmation(finalOrder)
await trackOrderCompleted(finalOrder)
```

The second line of the related finding is fixed in the same commit, because it
is the same mechanism and leaving it would mean shipping a known wrong number
to the analytics pipeline.

```
After fix:  npm test -- orders, 31 passing
Regression: npm test, 214 passing
Trigger:    an order with SAVE10 now emails 4410
```

## What was not done

No logging was added. Three reads and one query answered it. The instinct to
instrument first would have cost a deploy and a wait, and would have produced
the same three lines.
