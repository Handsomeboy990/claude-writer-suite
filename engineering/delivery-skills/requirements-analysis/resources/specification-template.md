# Engineering specification template

````markdown
# Specification: <project>

Source: <what this was derived from, with a date>
Analyst pass: <date>

## 1. Product

Objective:
Users:
| Role | Description | May do |
|---|---|---|

Primary workflows:
1.
2.

Business value:
Success criteria:

## 2. Functional requirements

### F1 <feature name>

Trigger:
Actor:
Preconditions:
Behaviour:
Business rules:
- R1
- R2
States and transitions:
Effects: writes / sends / notifies / invalidates
Failure behaviour:
Permissions: who may act, who may see

### F2 ...

## 3. Non functional requirements

| Area | Requirement | Source |
|---|---|---|
| Security | | |
| Performance | | |
| Availability | | |
| Scalability | | |
| Accessibility | | |
| Localisation | | |
| Observability | | |
| Maintainability | | |
| Compliance | | |

Lines with no real requirement read `not a concern for this project`, not an
invented target.

## 4. Constraints

| Constraint | Detail | Consequence |
|---|---|---|
| Existing systems | | |
| Imposed technology | | |
| Existing data | | |
| Hosting | | |
| Budget | | |
| Timeline | | |
| Maintaining team | | |

## 5. Scope

In scope:
-

Out of scope:
- <including what a reader would reasonably expect and will not get>

## 6. Assumptions

| # | Assumption | Why needed | If wrong |
|---|---|---|---|
| A1 | | | |

## 7. Unknowns

| # | Missing | Blocks | Blocking |
|---|---|---|---|
| U1 | | | yes / no |
````

## Worked fragment

````markdown
### F3 Seller payout

Trigger:        weekly schedule, Monday 02:00 UTC
Actor:          system
Preconditions:  seller has completed onboarding checks; balance above the
                minimum payout amount
Behaviour:      the platform transfers the seller balance minus commission to
                the seller's registered account, and records a payout row
Business rules:
- R1 commission is 8 percent of the item total, excluding shipping
- R2 orders inside the 14 day dispute window are excluded from the balance
- R3 a payout below 20 EUR is deferred to the following week
- R4 a failed transfer is retried twice, then the balance stays and an
     operator is notified
States:         pending -> sent -> settled, or pending -> failed -> pending
Effects:        writes payouts and ledger_entries; sends a payout email;
                invalidates the seller balance view
Failure:        provider unavailable leaves the balance untouched and the run
                resumes next cycle; a partial batch never double pays
Permissions:    sellers read their own payouts; operators read all; nobody
                triggers a payout manually through the API

Assumptions used:
A4 commission excludes shipping. Source says "8 percent commission" without
   naming the base. If wrong, R1 changes and the ledger needs a migration.
A5 payouts are per seller, not per order. If wrong, the payout schema changes.

Unknowns raised:
U2 which country's onboarding checks apply. Blocks the onboarding module, not
   the payout module. Blocking: yes, for F2.
````

The value of the fragment is in R2, R4 and the failure line. None of the three
appeared in the source brief, all three are required to build the feature, and
each one is either an answered question or a recorded assumption rather than a
silent decision.
