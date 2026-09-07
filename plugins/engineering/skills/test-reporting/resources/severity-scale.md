# Severity scale

Severity is decided by consequence. The fix effort, the discoverer's surprise
and the release date are not inputs.

## The five questions

```
1 What does it cost?      data, money, access, time, trust
2 How often?              every time, sometimes, once under rare conditions
3 Who does it reach?      every user, one role, one tenant, an internal user
4 Is there a workaround?  none, awkward, obvious
5 Can the user tell?      a visible failure is less dangerous than a silent one
```

## The scale

| Severity | Applies when |
|---|---|
| Critical | data lost or corrupted, data crossing a user or tenant boundary, money moved or held wrongly, a critical flow with no workaround, or a silent failure that leaves the system inconsistent |
| High | a critical flow broken with an awkward workaround, a role entirely blocked, a silent failure the user cannot detect, a security weakness with a precondition |
| Medium | a secondary feature broken, a defect with a reasonable workaround, a barrier that makes a task hostile but completable, a contract deviation clients do not yet depend on |
| Low | cosmetic, rare, avoidable, with no effect on data, money or access |
| Info | an observation, a risk, a question, a note for the next campaign |

## Rules that override the table

```
any cross boundary data access                        Critical
any operation that reports success after failing      at least High
any defect that corrupts data already stored          Critical
any accessibility barrier that blocks task completion Critical for that user
any defect on a payment, invoice or refund path       at least High
a purely cosmetic defect on the primary call to action  Medium, not Low
```

## Calibration examples

```
Critical  a member of tenant B can read tenant A documents by identifier
Critical  the export overwrites the previous file while it is downloading
Critical  a payment is captured and no order exists
High      the invitation mail is never sent and the interface says it was
High      a screen reader user cannot complete the signup form
High      the session expires and the form silently discards the input
Medium    the table overflows horizontally at 360 px on the orders page
Medium    the 500 error page loses the navigation
Low       the empty state text has a typo
Low       the tooltip is 2 px misaligned in one browser
Info      identifiers are sequential, which raises the impact of any future
          authorization defect
```

## Anti-inflation

Before assigning Critical or High, write one sentence describing the
consequence in the words a non technical person would use. If that sentence
sounds overstated, the severity is.

Before assigning Low, check the five questions again. A defect that is
cosmetic on a secondary page is Low; the same defect on the primary action of
the main flow is not.

## Grouping

Several findings with one cause are reported as one finding with the list of
affected locations, at the severity of the worst location. Splitting one cause
into nine tickets inflates the count and hides the fix.

Conversely, one symptom with several causes is several findings. The clue is
the fix: one change or several.

## Severity is not priority

Priority also weighs cost, timing and dependencies, and it belongs to whoever
owns the release. The report states severity and impact; it recommends, it does
not decide.
