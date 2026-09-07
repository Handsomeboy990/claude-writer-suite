# Quality discovery checklist

Run after `project-exploration`. Every line is answered from the repository or
from the running system, never from habit. A line that cannot be answered
becomes a question in the brief, and nothing else does.

## Repository

```
package manifest and lockfile, so the package manager is known, not guessed
scripts: how the project is built, run, tested, linted, migrated
framework and runtime versions, from the manifest, not from the readme
monorepo or single package, and which workspace holds what
environment example file, and every variable the code actually reads
CI configuration: which jobs run, which are required, which are allowed to fail
```

## Surfaces

```
frontend routes, including the ones behind a role
API endpoints, with method, auth requirement and payload shape
background jobs, schedules, queues, consumers
webhooks received and webhooks sent
file uploads and downloads
exports, imports, report generation
administrative interfaces, which are usually the least tested
public versus authenticated versus internal surface
```

## Identity and data

```
authentication mechanism, session or token, expiry, refresh, revocation
role model, and where authorization is actually enforced
tenancy model, if any, and the column or claim that carries it
data stores, migrations, seed data, fixtures
which identifiers are guessable, and which are opaque
personal data present, and whether it may appear in evidence
```

## Existing quality

```
test frameworks configured, and whether they run today
suites present, their layer, their duration, their stability
tests skipped, and since when
coverage configuration, and what it excludes
last CI results, and the failures nobody looks at any more
existing reports, screenshots, traces, baselines
known bugs recorded in the repository
```

## Environments

```
which environments exist: local, test, staging, production
which are reachable, and with which credentials
which are safe to write to
whether staging shares a database with anything real
the version or commit currently deployed to the target
```

## Client expectations already written down

```
browser and device support stated anywhere in the repository
accessibility target stated in a policy, a contract or a component library
performance budgets in the build configuration or the CI
service level statements in the documentation
localisation: which languages, and where the strings live
```

## What discovery may never assume

```
that the readme matches the code
that a configured framework is actually used
that a passing CI job asserts anything
that a route without a visible link is unreachable
that the frontend restriction is enforced on the server
that seed data resembles production data
that a staging environment is disposable
```

Each of these is checked, not believed.
