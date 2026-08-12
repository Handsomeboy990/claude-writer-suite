# Example: a one line fix, and the regression it required

The fix: a rounding defect in `lib/pricing/total.ts`, one line, replacing a
floating point multiplication with an integer computation in minor units.

The temptation: run the pricing tests, see green, ship.

## Impact analysis

```
diff        1 file, 1 line
imports     lib/pricing/total.ts is imported in 9 places
```

Nine imports turned a one line fix into this impact set:

```
cart total, with and without discount
checkout, the amount sent to the payment provider
invoice PDF, which formats the same value
the monthly report export, which sums stored totals
the admin refund screen, which compares a stored total to a recomputed one
the subscription proration job, which calls total() nightly
Not impacted
  catalogue and search: no price computation
  authentication: no shared code
```

The refund screen is the interesting one. It compares a stored total, computed
by the old code, against a recomputed one. Changing the computation makes old
orders appear inconsistent.

## Selection

```
Tier 0   the failing test written for the defect: 0.1 + 0.2 style rounding on
         three known orders. Red before the fix, green after.
Tier 1   critical set: sign in, add to cart, pay, invoice. Always.
Tier 2   the impact set above.
Tier 3   the neighbourhood: everything importing lib/pricing. Included,
         because the change is in shared code.
Tier 4   full suite. Not required by section 4 of the skill: no dependency,
         no migration, no auth change. Ran anyway before the release, which is
         a rule, not a preference.
```

## Results

```
baseline  8f21c04   312 passed, 1 failed, 2 skipped, 141s
current   4c17ab9   313 passed, 2 failed, 2 skipped, 143s

newly failing
  admin/refund.test.ts > shows no discrepancy for a historical order
    diagnosed: not a defect in the fix. The test asserted that stored and
    recomputed totals are equal, which was only true while both were wrong.
    Decision: the screen must tolerate a legacy rounding difference of one
    minor unit and label it, rather than the test being weakened.
    Handed to backend-engineering. Test kept red until the screen changes.

still failing, pre-existing
  mail/provider.test.ts > retries a 502    failing since 2026-06-14

newly passing
  none

duration
  +2s, one new test. Normal.
```

## What would have gone wrong with the intuitive selection

Running only the pricing tests would have shipped a fix that makes the admin
refund screen display a discrepancy on every order created before the release.
Nothing would have failed in CI, because the only test that could have caught
it lives in a directory nobody would have thought to select.

The nine imports were visible in ten seconds with a search. The selection cost
almost nothing; the omission would have cost a support queue.

## Verdict

```
REGRESSION OPEN

One newly failing test, diagnosed, correct in its assertion, and left red
until the screen handles legacy rounding. The pricing fix itself is verified
by tier 0 and the critical set. Not run: the browser suite for the invoice
PDF layout, which has no fixture for historical orders. Named as a gap.
```
