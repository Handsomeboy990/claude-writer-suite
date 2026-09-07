---
name: feature-flags
description: Manages flags as code with a lifecycle rather than as permanent branches: flag types and their different lifespans, evaluation and defaults that fail safe, targeting and gradual rollout, kill switches, testing both sides, flag debt and stale flag detection, and the removal that closes the loop. Use before adding a conditional that ships disabled, and when nobody can say what a flag still controls.
license: MIT
metadata:
  category: dev-skills
  version: 1.0.0
  depends_on: [engineering-core, testing-quality]
  outputs: [flag-register, evaluation-rules, rollout-plan, removal-plan]
---

# Feature Flags

A flag is a branch in production that everyone can see and nobody removes.
Used deliberately it decouples deployment from release, allows a kill switch,
and makes a risky change reversible in seconds. Used carelessly it doubles the
state space of the system, permanently.

The discipline is not the toggle. It is the removal.

## 1. Types, because they have different lifespans

| Type | Purpose | Lifespan |
|---|---|---|
| release | ship disabled, enable when ready | days to weeks, then removed |
| kill switch | disable a feature or a dependency under failure | permanent, and exercised |
| experiment | compare variants for a decision | the experiment, then removed |
| permission | entitlement by plan, role or contract | permanent, and it is not a flag: it is authorization |
| operational | degrade behaviour under load | permanent, owned by operations |

The fourth row is the common mistake. An entitlement belongs to the permission
model, where it is authorized and audited, not to a flag system where anyone
can flip it.

## 2. Before adding one

```
what decision does the flag defer, and who takes it
what is the default if the flag system is unreachable
who may change it, and is that change recorded
when is it removed, and who removes it
does it interact with another flag, and has that combination been tested
```

A release flag with no removal date is a permanent conditional acquired for a
temporary reason.

## 3. Evaluation

```
one evaluation point per decision, not scattered conditionals
evaluate as high in the call stack as the decision allows, then pass the
  result down, so the same request cannot see both sides
a default that fails safe: the old behaviour, unless the flag exists to
  disable something dangerous, and then the safe default is off
evaluation must not fail the request: a provider outage falls back to default
consistent per user or per session, so the interface does not flicker
never evaluate inside a loop, or per row
the evaluated value is logged with the request, so a defect can be attributed
```

## 4. Rollout

```
internal users, then a small percentage, then wider, then everyone
each step observed before the next: errors, latency, the metric the change
  was meant to move
the metric and the abort threshold are written before the rollout starts
one flag rolled out at a time on the same surface, so attribution is possible
the rollback is the flag itself, and it is verified once before it is needed
sticky assignment, so a user does not move back and forth between variants
```

## 5. Testing both sides

```
the suite runs with the flag off and with the flag on for the paths it changes
the default path is the one CI runs by default, and the other is explicit
combinations that can occur are tested, not every combination
a flag removed from the code has its tests removed in the same commit
an experiment's variants are both tested, including the losing one
end to end tests set the flag explicitly rather than inheriting a state
```

A flag whose enabled path has never run in CI is a deployment of untested
code with a delay.

## 6. Flag debt

```
a register: flag, type, owner, created, removal date, current state per
  environment, what it controls
stale detection: a release flag past its date, a flag at 100 percent for a
  month, a flag nobody can explain, a flag evaluated nowhere in the code
a flag with no owner is removed, not adopted
the removal is a normal task in the queue, sized and scheduled
```

The register is worth its maintenance the first time someone asks why
production behaves differently from staging.

## 7. Removal

```
1 confirm the decision: the feature stays or it goes
2 remove the conditional and the losing branch
3 remove the flag's tests, and keep the tests of the surviving behaviour
4 delete the flag from the provider, so it cannot be flipped afterwards
5 remove the register entry
6 verify the behaviour in each environment after removal, since a flag at
  different values per environment hides a difference until it is deleted
```

Step 6 catches the case where production was running the other branch all
along and nobody noticed.

## 8. Prohibitions

- Never use a flag for an entitlement; that is authorization.
- Never let a flag evaluation failure fail a request.
- Never evaluate the same flag twice in one request and act on both results.
- Never ship a flag with no owner and no removal date.
- Never let a release flag outlive its purpose because removing it is dull.
- Never test only the default path.
- Never nest flags to the point where the combinations are untestable.
- Never change a production flag without a record of who and why.

## 9. Protocol

1. Decide the type, and refuse the flag if it is really an entitlement.
2. Write the register entry, including the owner and the removal date.
3. Choose the evaluation point and the fail safe default.
4. Implement, with the value logged and passed down rather than re-evaluated.
5. Test both sides, and make the default path the one CI runs.
6. Write the rollout plan with its metric and abort threshold.
7. Roll out in steps, observing each one.
8. Verify the flag as a rollback before relying on it.
9. Remove: conditional, losing branch, tests, provider entry, register entry.
10. Verify behaviour in every environment after removal.

## 10. Auto-critique

Score from 0 to 5: type chosen correctly, entitlements refused, fail safe
defaults, single evaluation point, both sides tested, rollout observed against
a written threshold, register maintained, removal completed including the
provider entry.

Threshold: no axis below 3, average at least 4. A flag controlling an
entitlement, or a flag whose enabled path never ran in CI, fails regardless of
how clean the rollout was.

## 11. Interfaces

- Upstream: `requirements-analysis` for what the flag defers,
  `architecture-design` when the flag hides two implementations.
- Lateral: `backend-engineering` and `frontend-engineering` for evaluation,
  `analytics-instrumentation` for experiment exposure and measurement,
  `technical-debt` for the flags nobody removed.
- Downstream: `testing-quality` for both sides, `regression-testing` after a
  removal, `release-engineering` for the rollout, `incident-response` when a
  kill switch is the mitigation.
