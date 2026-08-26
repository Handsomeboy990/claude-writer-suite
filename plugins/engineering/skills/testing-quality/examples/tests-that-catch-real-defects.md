# Example: tests that would have caught the incident

Feature under test: applying a discount coupon at checkout.

## The suite that existed

```ts
it("applies a coupon", async () => {
  const result = await applyCoupon(order, "SAVE10")
  expect(result).toBeTruthy()
})

it("calls the repository", async () => {
  await applyCoupon(order, "SAVE10")
  expect(couponRepo.findByCode).toHaveBeenCalled()
})
```

Two tests, both green, both worthless.

The first asserts truthiness: it passes for any non empty object, including
one with a wrong total. The second asserts that an internal method was called,
which tests the implementation rather than the behaviour and breaks the moment
the code is refactored without any behaviour changing.

Neither can fail when the discount is computed wrongly. That is the definition
of a test that does not exist.

## What actually happened in production

A single use coupon was redeemed fifty one times in ninety seconds during a
launch. Revenue impact was four figures. Both tests stayed green throughout.

## The suite that ships now

```ts
describe("applyCoupon", () => {
  // 1 happy path, asserting the outcome, not the truthiness
  it("subtracts the percentage from the order total", async () => {
    const order = await orderFactory({ totalMinor: 4900 })
    const result = await applyCoupon(order.id, "SAVE10")
    expect(result.totalMinor).toBe(4410)
    expect(result.discountMinor).toBe(490)
  })

  // 2 invalid input
  it("rejects an unknown code", async () => {
    await expect(applyCoupon(order.id, "NOPE")).rejects.toThrow(CouponNotFound)
  })

  // 8 boundaries, the rounding case that floats get wrong
  it("rounds a percentage discount down to the minor unit", async () => {
    const order = await orderFactory({ totalMinor: 999 })   // 10% of 999
    const result = await applyCoupon(order.id, "SAVE10")
    expect(result.discountMinor).toBe(99)                   // not 99.9
    expect(result.totalMinor).toBe(900)
  })

  // 10 business rule, the one the feature exists for
  it("never discounts below zero", async () => {
    const order = await orderFactory({ totalMinor: 500 })
    const result = await applyCoupon(order.id, "FLAT10EUR")
    expect(result.totalMinor).toBe(0)
    expect(result.discountMinor).toBe(500)
  })

  // 10 business rule
  it("refuses a second coupon on the same order", async () => {
    await applyCoupon(order.id, "SAVE10")
    await expect(applyCoupon(order.id, "SAVE20")).rejects.toThrow(CouponAlreadyApplied)
  })

  // 8 boundaries on time
  it("refuses a coupon that expired one second ago", async () => {
    vi.setSystemTime(new Date("2026-03-01T00:00:01Z"))
    await expect(applyCoupon(order.id, "EXPIRED")).rejects.toThrow(CouponExpired)
  })

  // 7 duplicates, sequential
  it("refuses a second redemption of a single use coupon", async () => {
    await applyCoupon(orderA.id, "ONCE")
    await expect(applyCoupon(orderB.id, "ONCE")).rejects.toThrow(CouponExhausted)
  })

  // 7 duplicates, concurrent, the test that would have caught the incident
  it("allows exactly one redemption under concurrency", async () => {
    const orders = await Promise.all(
      Array.from({ length: 50 }, () => orderFactory({ totalMinor: 4900 })),
    )
    const results = await Promise.allSettled(
      orders.map((o) => applyCoupon(o.id, "ONCE")),
    )
    expect(results.filter((r) => r.status === "fulfilled")).toHaveLength(1)
    expect(results.filter((r) => r.status === "rejected")).toHaveLength(49)
  })

  // 4 error path
  it("does not consume the coupon when the order update fails", async () => {
    db.order.update.mockRejectedValueOnce(new Error("connection lost"))
    await expect(applyCoupon(order.id, "ONCE")).rejects.toThrow()
    const coupon = await getCoupon("ONCE")
    expect(coupon.usedCount).toBe(0)
  })
})
```

## Why the concurrency test is the important one

It runs against a real database, not a mock. A mocked repository cannot
express a unique constraint, so the test would pass with the broken read then
write implementation and prove nothing.

It also fails for the right reason before the fix:

```
before: expected length 1, received 50
after:  1 fulfilled, 49 rejected
```

That red run is what makes the green run meaningful.

## Why the rounding test is the second most important

`4900 * 0.1` is exact in binary floating point; `999 * 0.1` is not. A test
written only with round numbers passes forever and hides the class of bug that
appears on the customer's odd cart total. Boundary cases are chosen to be
awkward on purpose.

## What was deliberately not tested

```
n/a: no authorization surface, applyCoupon is called from a handler that
     already scopes the order to the session user, covered by
     app/api/orders/[id]/coupon/route.test.ts
n/a: no external service in this path
```

Written down, so the next reader knows the absence was a decision.
