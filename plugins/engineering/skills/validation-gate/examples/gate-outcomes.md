# Example: four gates, four different outcomes

The same skill, four projects, four responses. What matters is what happened
next in each case.

## 1. Approved

```
Reader: "Yes, go ahead. Keep the audit table, good catch."
```

Recorded:

```
Approved:     2026-08-10
By:           the client's operations lead
Version:      docs/architecture/support-lookup.md revision 1
Changes:      none
Assumptions:  A1, A2 approved
Out of scope: as listed
Quote:        "Yes, go ahead. Keep the audit table, good catch."
```

Then implementation started, and did not come back with questions about file
naming, test structure or whether to fix its own mistakes. One report at the
end of the work, as promised in the decision request.

## 2. Approved with changes

```
Reader: "Fine, but we do need CHF as well as EUR, and the retention has to be
ten years, not five, for the accounting rules."
```

This is not a simple yes. Two assumptions were overturned, and one of them,
retention, touches the data lifecycle in the database section.

What happened before any code:

```
1  A1 currency updated: EUR and CHF. Consequence traced through the schema:
   amounts already stored in minor units with a currency column, so no schema
   change. Price display and the payout rounding rule change.
2  A13 retention updated: 10 years. Consequence traced: the purge job schedule
   changes, and the storage cost estimate roughly doubles over the period.
   Cost note updated from 50 to 58 EUR per month at the five year mark.
3  docs/architecture/marketplace.md updated, revision 2.
4  The two changes restated back to the reader in three lines, with the cost
   consequence, and confirmed.
```

Recorded:

```
Changes:  A1 currency EUR plus CHF; A13 retention 5 years to 10 years
Version:  revision 2, which is the approved one
Quote:    "Fine, but we do need CHF as well as EUR, and the retention has to
          be ten years, not five, for the accounting rules."
```

The step that gets skipped is 3. An approval with changes that leaves the
document at revision 1 produces a project whose architecture document
describes something nobody approved.

## 3. Revision requested

```
Reader: "This looks like it assumes each seller handles their own tax. That is
not how we operate. We invoice the buyer, we pay the seller. Rework it."
```

The merchant of record question had been asked at the clarification gate and
answered `seller`. The answer was wrong, or the question was misread. Either
way the proposal is built on it.

What happened:

```
Stopped:   everything. No implementation had started, which is the entire
           value of the gate here.
Reworked:  the payment architecture, the payout model, the seller onboarding
           requirements and the compliance section. Four days.
Not done:  arguing about the earlier answer. It changes nothing.
Re-presented: revision 2, with a one line note at the top saying what changed
           and why, so the reader does not re-read the unchanged sections.
```

The counterfactual is the point. Had implementation started at the
clarification gate, four days of proposal rework would have been six weeks of
rebuilding checkout, payouts, the ledger and the seller onboarding flow, all
of it discovered when someone asked who appears on the invoice.

## 4. Deferred

```
Reader: "I need to check the payout schedule with our accountant. Give me a
few days."
```

The honest response is not to start anyway and not to sit idle.

```
Blocked by:   the payout schedule decision, which determines the ledger model
              and the payout job

Proceeding on, because no plausible answer changes them:
  repository initialisation and tooling
  the authentication module, unaffected by payouts
  the product catalogue module, unaffected
  test infrastructure
  CI pipeline

Not proceeding on:
  the ledger schema
  the payout job
  anything writing to seller balances
  the checkout flow, which references the ledger

Stated to the reader in three lines, so the choice is visible rather than
assumed.
```

Two weeks later the answer arrived, the deferred parts were designed against
it, and none of the completed work had to be revisited. The alternative,
guessing the schedule to avoid idle time, would have produced a ledger built
on a guess with a fortnight of code on top of it.

## What the four cases share

In none of them did implementation begin before an approval covering the part
being implemented. Cases 3 and 4 are where that rule earned its cost: one
avoided six weeks of rework, the other avoided building on a guess.

Cases 1 and 2 are the common ones, and they cost the reader four minutes each.
