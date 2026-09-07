---
name: regression-testing
description: Decides what to re-run after a change and proves nothing else broke: impact analysis from the diff, the always-run critical set, targeted selection by dependency and shared code, comparison against a known baseline, and the rules that force a full suite. Use after any fix, any refactor, any dependency change and before any release.
license: MIT
metadata:
  category: dev-skills
  version: 1.0.0
  depends_on: [engineering-core, testing-quality]
  outputs: [impact-set, regression-selection, baseline-comparison, regression-verdict]
---

# Regression Testing

Running everything is expensive and running nothing is negligent. This skill
decides what to run from what changed, and states what it did not run.

Regression is not a test suite. It is a selection decision with a written
justification.

## 1. Impact analysis

Start from the diff, never from a feeling. For each changed file:

```
direct        the behaviour the change was made for
callers       everything that calls the changed function, handler or component
shared code   anything else using the same module, helper, hook or query
data          tables, columns, indexes and migrations touched
contract      request or response shapes, event payloads, queue messages
configuration environment variables, feature flags, build settings
cross cutting authentication, authorization, validation, logging, caching
```

The expansion rules are in `resources/impact-analysis.md`. The output is an
impact set: a list of features, not a list of files.

Three changes are always wider than they look: a shared utility, a database
migration, and anything in the authentication or authorization path.

## 2. Selection tiers

| Tier | Contents | Runs when |
|---|---|---|
| 0, defect proof | the test that failed for the defect just fixed | always, first |
| 1, critical set | the flows whose breakage is an incident | always |
| 2, impact set | the features from section 1 | always |
| 3, neighbourhood | everything sharing the changed module or table | when the change is shared or structural |
| 4, full suite | everything | by the rules of section 4 |

Tiers run in order and stop at the first tier that fails, because a broken
tier 1 makes tier 3 results meaningless.

## 3. The critical set

Defined once per project, in the testing contract, and kept small: the three
to seven journeys whose failure is an incident. Signing in, paying, creating
the central object, the export that a customer relies on.

It runs on every change, including changes that `obviously` cannot affect it.
The word `obviously` is the reason it exists.

## 4. When the full suite is mandatory

```
a dependency was added, removed or upgraded
the runtime, framework or build tool changed
a migration ran, or a schema changed
a shared utility, base component or middleware changed
authentication, authorization or session handling changed
configuration that differs between environments changed
before a release
after a merge that included work from more than one person
when the last full run is older than the project's stated interval
```

Outside these, a full run is optional and a targeted run is the professional
choice.

## 5. Baseline

A result means nothing without the previous one.

```
before   the last known result: counts, duration, the tests already failing
after    the new result, same command, same environment
compare  newly failing, newly passing, newly skipped, duration drift
```

A test that was already failing before the change is not a regression, and it
is not ignored either: it is named in the report with its age.

Newly passing tests are examined too. A test that starts passing without a
reason is usually a test that stopped asserting.

## 6. After a fix

```
1  the test that reproduces the defect, written first, observed red
2  the fix
3  the same test, observed green
4  tier 1, then the impact set of the fix
5  the neighbourhood, if the fix touched shared code
6  a second consecutive run of anything that touched concurrency or timing
```

A fix without step 1 is a fix that will be made again next quarter.

## 7. Suite health is part of the result

A regression run reports the suite as well as the code:

```
newly flaky tests, with the run in which they diverged
tests skipped, by whom, since when
duration drift beyond the project's tolerance
tests that failed and passed on retry, which is the same as failing
```

Flakiness is diagnosed with the guide in `testing-quality`, never suppressed
with a retry.

## 8. Prohibitions

- Never claim a regression pass while naming no selection. `I ran the tests`
  is not a result.
- Never select by intuition when the diff is available.
- Never skip tier 1 because the change looked unrelated.
- Never compare against a baseline from a different environment or command.
- Never accept a retry as a pass.
- Never delete or skip a failing test to make the comparison clean.
- Never report a suite as green when tests were skipped, without saying how
  many and which.

## 9. Protocol

1. Get the diff, or the list of what the campaign changed.
2. Build the impact set with the expansion rules.
3. Load the critical set from the testing contract.
4. Decide the tier, and write the reason for stopping where you stop.
5. Establish the baseline from the last known run.
6. Run tier 0 and tier 1, then the selected tiers in order.
7. Compare against the baseline: newly failing, newly passing, newly skipped.
8. Diagnose every difference before concluding, including the improvements.
9. Report the selection, the results, the comparison and what was not run.

## 10. Auto-critique

Score from 0 to 5: impact analysis derived from the diff, critical set always
run, tier justification, baseline comparison performed, differences diagnosed,
suite health reported, honesty about what was excluded.

Threshold: no axis below 3, average at least 4. A regression report that does
not name what it excluded is not a regression report.

## 11. Interfaces

- Upstream: `debugging` for the defect proof, `quality-engineering` for the
  critical set, `code-review-protocol` for the diff.
- Lateral: `testing-quality` for the suite itself, `playwright-automation`
  for browser level critical flows, `api-testing` for contract level ones.
- Downstream: `release-readiness`, `test-reporting`, `project-continuity`.
