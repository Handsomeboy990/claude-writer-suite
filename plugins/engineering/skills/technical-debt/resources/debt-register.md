# Debt register

One file in the repository, short enough that people read it. Items are
removed when paid, with the payment recorded in the history rather than in the
register.

## Entry format

```
DEBT-07  Authorization duplicated across 23 handlers
  Kind         accidental, prudent
  Location     app/api/**, each handler repeats the ownership check
  Interest     every new endpoint costs 20 minutes of copying and reviewing
               the check. Two of the last five security findings were a
               handler where it was omitted. Measured: 2 defects in 12 months,
               both High.
  Blast radius every authenticated endpoint. A shared change touches 23 files.
  Trigger      the partner API, planned for Q4, adds 15 more handlers
  Payment      move the check into the shared loader, delete it from the
               handlers, add a test that a handler without it fails. 2 days.
  Risk of not  the 24th handler forgets it, and that is a data exposure
  Owner        backend
```

## Register, ordered by interest times probability

```
ID       Item                                    Interest   Touched   Rank
DEBT-07  authorization duplicated                high       often     1
DEBT-03  no test seam in the invoice module      high       often     2
DEBT-11  framework two majors behind, support
         ends 2027-03                            medium     n/a       3
DEBT-05  build takes 14 minutes                   medium     daily     4
DEBT-09  two date formats in the database         medium     rarely    5
DEBT-14  legacy admin templates, no tests         low        rarely    6
```

Six items. A register with sixty is a document that exists rather than a
document that is used.

## Deliberate debt record

Written before the shortcut is taken, not after:

```
DEBT-16  Seat limit checked in application code, not in the database
  Kind         deliberate, prudent
  Decision     taken 2026-08-12 by the team, to ship the plan change for the
               launch date
  Interest     a concurrent acceptance can exceed the limit. Estimated
               frequency: rare, since teams rarely accept two invitations in
               the same second. Consequence: an over-seated team, correctable
               by support.
  Trigger      the first occurrence, or the billing rework, whichever first
  Payment      a partial unique constraint plus a conditional insert, half a day
  Marker       lib/teams/membership.ts, comment referencing DEBT-16
  Owner        backend
```

The code carries a marker pointing at the identifier. Searching the register
from the code, and the code from the register, both work.

## Sources for candidates

```
version history   files changed most often, and files changed together
defect record     where defects originate, over a year
review comments   the same objection raised repeatedly
onboarding        what a new engineer had to be told twice
incidents         the postmortem action items nobody scheduled
build and CI      the slowest steps, measured
dependencies      unsupported versions, with their end of support dates
```

## Payment record

When an item is paid, the register loses the entry and the commit carries the
evidence:

```
refactor: move ownership check into the shared loader

Removes the duplicated authorization check from 23 handlers. Adds a test that
a handler bypassing the loader fails.

Interest before: 20 minutes per new endpoint, 2 High findings in 12 months.
Interest after: none. A new handler cannot omit the check.
Closes DEBT-07.
```

That message is what makes the next debt argument short.
