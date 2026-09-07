---
name: migration-engineering
description: Moves a running system from one framework, library, language, database, provider or architecture to another without a big bang: inventory and compatibility analysis, the parallel change pattern, dual running and comparison, data migration with reversibility, cut over, rollback and the cleanup nobody schedules. Use for any framework upgrade, provider change, database move or architectural migration.
license: MIT
metadata:
  category: dev-skills
  version: 1.0.0
  depends_on: [engineering-core, project-exploration]
  outputs: [migration-inventory, compatibility-matrix, migration-plan, cutover-plan, rollback-plan]
---

# Migration Engineering

A migration is a change of foundation under a system that must keep working.
The technical difficulty is rarely the new thing; it is the period during
which both exist.

Plan for the transitional state, because that is where the whole risk lives.

## 1. Establish why

```
what problem does the migration solve, in one sentence
what happens if it is not done, in twelve months
what will be worse afterwards, because something always is
who pays for the transitional period
```

`we are two major versions behind` is a fact, not a reason. The reason is
security support, a capability needed, a cost, or a defect that cannot be
fixed otherwise.

## 2. Inventory before planning

```
every place the old thing is used, counted, not estimated
every behaviour that depends on its quirks rather than its contract
every integration that observes the current shape: clients, reports, exports
the data: volume, shape, quality, and what is invalid today
the tests that protect the surface, and the parts with no protection
the deployment and rollback mechanism as it exists now
```

The count matters. A migration with 40 call sites and one with 4000 are
different projects with different techniques.

## 3. Compatibility analysis

```
what is identical
what is renamed
what changed behaviour silently: the dangerous category
what was removed, and what replaces it
what is new and optional, to be ignored during the migration
what the migration guide of the target says, read in full, not skimmed
```

Silent behaviour changes are found by testing, not by reading changelogs.
Default values, error semantics, ordering, timezone handling and rounding are
the usual suspects.

## 4. Strategies

| Strategy | Fits | Cost |
|---|---|---|
| in place upgrade | small surface, strong test coverage, reversible deploy | short freeze, one risky moment |
| parallel change | any code level migration with many call sites | two implementations for a while |
| strangler | replacing a subsystem or an application | routing layer, long transition |
| dual write and backfill | data store migration | consistency work, verification |
| shadow traffic | replacing a service where output must match | duplicated load, comparison work |
| rewrite behind a flag | small, well understood component | flag lifecycle, cleanup |

Never a big bang, unless the system can be stopped and restored, and the
restore has been rehearsed.

## 5. The parallel change pattern

The default technique for code level migration:

```
1 introduce the new implementation beside the old, unused
2 route one call site to it, ship, observe
3 route the rest in batches, each shipped and observed
4 remove the old implementation
5 remove the abstraction that allowed both, if it earns nothing now
```

Every step ships. Every step is reversible by a revert rather than by a
recovery procedure.

## 6. Data migration

```
reversibility     write the down path, or state in writing that there is none
                  and why that is acceptable
batching          never one statement across a large table
resumability      a checkpoint, so a failed run continues rather than restarts
verification      counts, checksums, and a sample compared field by field
invalid data      decided in advance: reject, repair, or quarantine
dual read         read new, fall back to old, during the transition
dual write        write both, with the failure semantics decided
cut over          when the verification passes, not when the clock says so
retention         how long the old data stays, and who deletes it
```

The migration script is production code: reviewed, tested against a copy of
production data, and run with the same care as a deployment.

## 7. Running both

```
compare outputs on real traffic, in shadow, before switching
log the differences with enough context to diagnose, without personal data
decide the acceptable difference rate in advance, and what to do above it
keep the old path warm until the new one has survived a full business cycle:
  a month end, a billing run, a peak day
```

## 8. Cut over and rollback

```
cut over
  a written sequence, with the person, the command and the check at each step
  a freeze window if one is genuinely required, announced
  the observable signals that say it worked
rollback
  the exact procedure, rehearsed at least once
  what it cannot restore: data written by the new path, side effects sent
  the point of no return, named, and what replaces rollback after it
```

A rollback plan that has never been executed is a hypothesis.

## 9. Cleanup

The step that gets cancelled and should not be:

```
delete the old implementation
delete the compatibility layer
delete the feature flag
delete the dual write
drop the old columns and tables, after the retention period
remove the old dependency from the manifest
update the documentation, including the diagrams
```

Schedule it in the same plan, with a date. A migration left at ninety percent
costs more than either end state, permanently.

## 10. Prohibitions

- Never migrate without an inventory, because the count changes the strategy.
- Never mix a migration with a feature change in the same commit or release.
- Never migrate data without a verification step and a written reverse path.
- Never rely on a rollback that has not been rehearsed.
- Never leave dual write, dual read or a flag in place with no removal date.
- Never upgrade to the newest version because it is newest; migrate to the
  version that solves the stated problem and is supported.
- Never declare a migration finished while the old path still receives traffic.

## 11. Protocol

1. State the reason and what breaks if nothing is done.
2. Build the inventory: call sites, behaviours, integrations, data, tests.
3. Produce the compatibility matrix from the target's own documentation.
4. Choose the strategy and write why the alternatives were rejected.
5. Strengthen the tests around the surface before touching it.
6. Execute in shipped, reversible steps.
7. For data: batch, checkpoint, verify, and keep the reverse path.
8. Run both and compare on real traffic where the risk justifies it.
9. Cut over with a written sequence and observable signals.
10. Run the cleanup, on the date in the plan.
11. Record the decision and its consequences through `decision-records`.

## 12. Auto-critique

Score from 0 to 5: reason stated, inventory counted, compatibility analysed
including silent changes, strategy justified, steps shipped and reversible,
data verification, rollback rehearsed, cleanup scheduled and executed.

Threshold: no axis below 3, average at least 4. A migration with no rehearsed
rollback and no cleanup date is not planned, it is started.

## 13. Interfaces

- Upstream: `project-exploration` for the inventory, `legacy-code` when the
  source system is untested, `technology-selection` for the target,
  `dependency-selection` for a library change.
- Lateral: `refactoring` for the parallel change steps, `database-design` and
  `database-operations` for data migration, `testing-quality` for the
  protection, `reliability-testing` for the transitional failure modes.
- Downstream: `regression-testing`, `deployment-engineering`,
  `production-verification`, `decision-records`, `technical-documentation`.
