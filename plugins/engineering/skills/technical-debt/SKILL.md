---
name: technical-debt
description: Makes technical debt visible, comparable and payable: distinguishes deliberate debt from mess, records each item with its interest rate and its blast radius, ranks by the change it makes expensive rather than by how ugly it is, and schedules payment against real work instead of a cleanup sprint nobody funds. Use when inheriting a codebase, planning a quarter, or arguing about a rewrite.
license: MIT
metadata:
  category: dev-skills
  version: 1.0.0
  depends_on: [engineering-core, project-exploration]
  outputs: [debt-register, interest-estimates, payment-plan, deliberate-debt-records]
---

# Technical Debt

Debt is a decision to move faster now and pay more later. Mess is not debt; it
is mess, and it has no upside to have been taken on.

Both cost the same to live with, and telling them apart changes who has to fix
the process.

## 1. Four kinds

| Kind | Origin | Response |
|---|---|---|
| deliberate and prudent | a documented trade for a real deadline | record it, schedule it, pay it |
| deliberate and reckless | speed chosen with no plan to repay | record it, pay it, change the decision process |
| accidental and prudent | the design was right for what was known then | pay it when the code is next opened |
| accidental and reckless | nobody knew, and nobody checked | training and review, not a ticket |

Naming the kind is not a moral exercise. It tells you whether to fix the code
or the process that produced it.

## 2. What is not debt

```
code you would have written differently
an old but working library with support
a pattern the team no longer prefers
a file that is long but coherent
a technology you dislike
a lack of tests around code that never changes and has no defects
```

Debt has interest. If nothing costs more because of it, it is a preference,
and preferences are not tracked in a register.

## 3. Recording an item

```
ID           DEBT-12
Location     files, modules, or the boundary concerned
Kind         from section 1
What         the shortcut, in one sentence
Why          the decision that produced it, and by whom, when known
Interest     what it costs, per occurrence and per period. Measured where
             possible: hours per change, defects produced, incidents caused
Blast radius what breaks when it is touched, and who else depends on it
Trigger      the change that will force payment, if one is foreseeable
Payment      the smallest work that removes the interest, with an estimate
Risk of not  what happens if it is never paid
```

The `Interest` line is the one that makes debt discussable with people who do
not read code. Without it, every item is one engineer's opinion against
another's.

## 4. Measuring interest

```
hours lost per change in that area, from real change history
defects originating there, counted over the last year
incidents traced to it
onboarding time spent explaining it
work that was refused or delayed because of it
build, test or deploy time it adds, in minutes per day
```

Two sources are always available: the version history and the defect tracker.
Both are more persuasive than an adjective.

## 5. Ranking

Rank by the product of interest and probability of being touched, not by size.

```
high    high interest, changed often, small blast radius     pay now
high    high interest, changed often, large blast radius     plan properly
medium  high interest, rarely touched                        pay when opened
medium  low interest, changed often                          pay opportunistically
low     low interest, rarely touched                         record, do not pay
```

The last row matters: a register that lists everything gets ignored. Debt in
code that nobody touches and nothing depends on is a note, not a task.

## 6. Payment

```
inside the work        the default: pay the debt in the area you are already
                       changing, in a separate commit
a scheduled item       for debt with a trigger date, such as an unsupported
                       dependency
a dedicated project    only for debt that blocks a roadmap item, and then it
                       is that roadmap item's cost, not a separate budget line
never                  a cleanup sprint with no target, which produces churn
                       and no measurable change
```

Every payment states what the interest was and what it is now. Debt paid
without a before and after is indistinguishable from rearranging.

## 7. Taking on debt deliberately

Permitted, and often correct. The conditions:

```
the shortcut is written down before it is taken
the interest is estimated
the trigger for repayment is named
someone owns it
the code carries a marker that points at the record
```

A deliberate debt record is a professional act. An undocumented shortcut with
a comment saying `temporary` is how a system acquires eleven year old
temporary code.

## 8. Prohibitions

- Never record an opinion as debt.
- Never estimate interest with an adjective.
- Never let the register grow beyond what the team reads.
- Never pay debt inside a feature commit; separate them.
- Never use a rewrite as a way to avoid measuring debt.
- Never take deliberate debt without a written record and an owner.
- Never mark debt paid without showing what changed in the interest.

## 9. Protocol

1. Collect candidates from the code, the history, the defects and the team.
2. Discard preferences: keep only items with demonstrable interest.
3. Classify each by kind.
4. Measure interest with the history and the defect record.
5. Estimate blast radius and name the likely trigger.
6. Rank by interest times probability of being touched.
7. Decide the payment route for the top items, and record the rest.
8. Pay inside the work, in separate commits, with a before and after.
9. Review the register when the roadmap changes, not on a schedule nobody
   keeps.

## 10. Auto-critique

Score from 0 to 5: preferences excluded, kinds correctly assigned, interest
measured rather than asserted, ranking by consequence, payment routed inside
real work, deliberate debt properly recorded, register kept short enough to be
read.

Threshold: no axis below 3, average at least 4. A register where no item has a
measured interest is a wish list and is rebuilt.

## 11. Interfaces

- Upstream: `project-exploration`, `legacy-code` for what was left behind,
  `code-review-protocol` for what reviewers keep finding.
- Lateral: `refactoring` for the payment technique, `architecture-design` when
  the debt is a boundary, `dependency-selection` for unsupported libraries.
- Downstream: `delivery-planning` for scheduling, `decision-records` for
  deliberate debt, `project-continuity` for the register itself.
