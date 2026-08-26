# Example: pressure-testing four ideas, killing two, ranking two

The four landlord ideas from ideation-engine, evaluated for the actor: a solo
developer, part-time, no budget, some backend skill. Two die on the premise test;
two survive to a validation plan.

## Premise pressure-test

```
idea 1  automated spreadsheet template
  premise: landlords want tracking without adopting new software
  reality: plausible; landlords already live in spreadsheets. Survives.

idea 2  mobile app with reminders
  premise: late-rent chasing is the real pain, worth paying to reduce
  reality: supported by observed forum complaints (from ideation-engine). Survives.

idea 3  bank-connected auto-detection
  premise: landlords will connect their bank account to a solo developer's tool
  reality: fails. Bank connection demands trust and compliance a solo part-timer
  cannot credibly provide, and landlords are cautious with financial access.
  KILLED on premise: the trust barrier is fatal for this actor.

idea 4  tenant-operated ledger
  premise: tenants will self-report payments to avoid being chased
  reality: fails. Tenants have little incentive to self-report, and a late-paying
  tenant least of all. The premise assumes goodwill from the party the product
  polices. KILLED on premise.
```

Two ideas dead before a line of code, which is the point. Idea 3's trust barrier
and idea 4's incentive flaw would each have taken months to discover by building.

## Scoring the two survivors, for this actor

```
                    feasibility  value  fit   cost  risk   (binding: solo/no-budget)
1 spreadsheet       5 (trivial)  3      4     5     2      passes binding easily
2 mobile app        3 (real work) 4     4     3     3      passes; more effort

reasoning
  1  feasible in a weekend, low value ceiling, cheap, low risk; a fast small earner
  2  more work and more value; the reminders are the real draw; moderate risk that
     landlords will not pay monthly for it
```

## Riskiest assumption and cheap test, per survivor

```
1 spreadsheet
  riskiest assumption: landlords will pay even a small one-time fee rather than
  build their own sheet
  cheap test: list it on a template marketplace for two weeks and watch; days of
  effort, real signal

2 mobile app
  riskiest assumption: the pain of chasing late rent is worth a monthly fee
  cheap test: a landing page describing the reminders feature with a "notify me"
  button, shared in two landlord forums; measures willingness before building
```

## Recommendation

```
rank
  1  the spreadsheet template first: cheapest to ship and to test; if it earns,
     it funds and de-risks idea 2
  2  the mobile app second, gated on the landing-page test; build only if the
     willingness-to-pay signal is there

killed, with reasons shown: idea 3 (trust barrier for a solo dev), idea 4
  (tenant incentive flaw)

next step: run idea 1's marketplace test; in parallel, stand up idea 2's landing
  page. No building beyond the template until the signals return.
```

## The lesson

Evaluation's most valuable act here was killing ideas 3 and 4 on their premises,
and refusing to recommend building idea 2 before a two-day landing-page test.
The output is not "build the app"; it is "ship the cheap thing, test the
expensive thing's riskiest assumption first."
