# Pipeline stages

Ten stages, ordered by cost. Adapt the tool, keep the order and the blocking
behaviour.

## The order and its budget

| # | Stage | Typical cost | Blocks | Catches |
|---|---|---|---|---|
| 1 | install | 10 to 60s cached | yes | lockfile disagreeing with the manifest |
| 2 | static | 15 to 60s | yes | formatting, lint, type errors |
| 3 | unit | 30s to 3min | yes | logic defects |
| 4 | build | 30s to 3min | yes | compile and bundling failures |
| 5 | integration | 1 to 5min | yes | migration, query and contract defects |
| 6 | security | 20 to 90s | yes | reachable advisories, committed secrets |
| 7 | end to end | 2 to 10min | yes | broken user journeys |
| 8 | package | 30s to 2min | yes | image build failures |
| 9 | deploy | varies | yes | configuration and platform failures |
| 10 | verify | 10 to 60s | yes | a deployment that started but does not work |

First meaningful signal: stages 1 to 3, target under three minutes.

## Why the order matters

A change with a type error costs 45 seconds to reject at stage 2. The same
change, in a pipeline that builds and runs end to end tests first, costs
fifteen minutes and a runner slot to reject for the same reason.

Over a hundred pushes, that is the difference between a pipeline the team
waits for and one they work around.

## Stage contents

### 1 Install

```
Restore the dependency cache, keyed on the lockfile hash
Install from the lockfile, in the mode that fails on drift
Never update the lockfile in CI
```

### 2 Static

Runs in parallel with stage 3 where the runner allows it.

```
Format check, not format write
Lint, with warnings as errors, since a warning that never blocks is permanent
Type check, on the whole project
```

### 3 Unit

```
No network, no database, no filesystem beyond temporary directories
Deterministic: fixed clock, seeded randomness
Fails on an unhandled rejection, not only on an assertion
```

### 4 Build

```
Production configuration
Fails on any warning that indicates a real problem
Records the output size, so a regression is visible
```

### 5 Integration

```
A real database, started as a service, migrated from scratch
Migrations applied by the same command production uses
No external network; third parties are stubbed at the network boundary
Includes the negative cases: unauthorized, conflict, boundary
```

Migrating from scratch on every run is what makes this stage catch a broken
migration before it reaches an environment where data exists.

### 6 Security

```
Dependency audit; reachable advisories block, unreachable ones are recorded
Secret scan over the diff and, periodically, the history
Image scan when stage 8 produces one
```

### 7 End to end

```
Against the artefact from stage 4, not a development server
Fixed viewport, locale and timezone; animations disabled
Retries: zero. A flaky test is a defect, not a retry setting.
Artefacts on failure: trace, screenshot, video where available
```

### 8 Package

```
Build once, tag with the commit hash
Push to the registry only from the protected branch
Never rebuild for a different environment
```

### 9 Deploy

```
Verify required variables exist in the target before starting
Apply migrations before the code, or after, per the migration strategy
Health gated: traffic shifts only when the health check passes
```

### 10 Verify

```
The deployed system answers a real request
The version endpoint reports the expected commit
One critical path is exercised
Failure triggers the rollback
```

## Proving the pipeline is a gate

Run once, deliberately, and record the result:

```
Introduce a type error            -> stage 2 fails, pipeline stops
Break a unit test                 -> stage 3 fails
Add a query with a missing table  -> stage 5 fails
Commit a fake credential          -> stage 6 fails
Break a journey selector          -> stage 7 fails
Remove a required variable        -> stage 9 fails before deploying
Break the health endpoint         -> stage 10 fails, rollback triggers
```

Seven deliberate breakages, seven confirmations. Without this exercise, the
pipeline is a set of commands that have only ever been observed succeeding.

## Caching

```
Key on          the lockfile hash, plus the runner platform
Restore keys    a prefix, so a partial cache still helps
Never cache     build output that must reflect the current commit
Never cache     anything whose staleness could hide a failure
```

## What is not a stage

```
Coverage threshold  reported, not gating
Performance budget  reported on a pull request, gating only when the project
                    has stable measurement infrastructure
Documentation build gating only when the docs are a deliverable
Manual approval     a gate, not a stage; it belongs at the production trigger
```
