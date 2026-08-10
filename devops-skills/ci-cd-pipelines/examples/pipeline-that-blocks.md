# Example: the pipeline that let everything through

Inherited project. The pipeline was green on every commit for four months.

## What it contained

```yaml
name: CI
on: [push]
jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - run: npm install
      - run: npm run lint || true
      - run: npm test || true
      - run: npm run build
      - run: echo "Deploying..."
```

Four defects, in order of severity.

**`|| true` on lint and tests.** Both stages report failures and neither
blocks. The pipeline is green while tests fail. This is the pattern that turns
a gate into a badge.

**`npm install`, not `npm ci`.** The lockfile is advisory. A dependency can
resolve differently in CI than locally, and the pipeline will not say so.

**No caching.** Six minutes of installation on every push, which is why people
had started skipping CI locally.

**A deployment step that echoes.** Nothing was deployed. Someone had written
it as a placeholder and it had never been completed, so the project had four
months of CI runs reporting deployments that never happened.

## What the check found

```
$ npm test
  Tests:  14 passed, 6 failed, 20 total

$ npm run lint
  32 problems (11 errors, 21 warnings)
```

Six failing tests and eleven lint errors, on a pipeline that had reported
success on every commit for four months.

Two of the six failing tests were real defects: an authorization test and a
duplicate submission test. Both had been failing since May. Both cover
behaviour that a user could reach.

## The replacement

```yaml
name: CI
on:
  push:
    branches: [main]
  pull_request:

concurrency:
  group: ${{ github.workflow }}-${{ github.ref }}
  cancel-in-progress: true

jobs:
  static:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-node@v4
        with:
          node-version: '24'
          cache: npm
      - run: npm ci
      - run: npm run format:check
      - run: npm run lint
      - run: npm run typecheck

  unit:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-node@v4
        with:
          node-version: '24'
          cache: npm
      - run: npm ci
      - run: npm test -- --run

  integration:
    runs-on: ubuntu-latest
    needs: [static, unit]
    services:
      postgres:
        image: postgres:16.3
        env:
          POSTGRES_PASSWORD: ci
        options: >-
          --health-cmd pg_isready --health-interval 5s --health-retries 10
        ports: ['5432:5432']
    env:
      DATABASE_URL: postgres://postgres:ci@localhost:5432/postgres
      SESSION_SECRET: ci-only-not-a-real-secret
    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-node@v4
        with:
          node-version: '24'
          cache: npm
      - run: npm ci
      - run: npm run db:migrate
      - run: npm run test:integration

  security:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
        with:
          fetch-depth: 0
      - run: npm audit --audit-level=high
      - run: ./scripts/scan-secrets.sh

  e2e:
    runs-on: ubuntu-latest
    needs: [integration]
    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-node@v4
        with:
          node-version: '24'
          cache: npm
      - run: npm ci
      - run: npx playwright install --with-deps chromium
      - run: npm run build
      - run: npm run test:e2e
      - uses: actions/upload-artifact@v4
        if: failure()
        with:
          name: playwright-trace
          path: test-results/
```

Changes tied to the defects: no `|| true` anywhere, `npm ci` throughout,
dependency caching, static and unit running in parallel, integration against a
real PostgreSQL with migrations applied from scratch, and the deployment
placeholder removed rather than left pretending.

## Proving it blocks

Seven deliberate breakages, on a branch, each reverted after:

```
type error in a service          static failed in 51s          correct
assertion inverted in a test     unit failed in 1m12s          correct
query against a missing column   integration failed in 2m40s   correct
fake key committed               security failed in 34s        correct
selector changed in a page       e2e failed in 4m20s           correct
lockfile edited by hand          static failed on npm ci       correct
required variable removed        integration failed at migrate correct
```

Seven for seven. The exercise took an hour and is the only evidence that any
of this works.

## The six failing tests

Not deleted, and not marked skipped.

```
2 real defects
  authorization test: the endpoint did not scope by owner. Fixed.
  duplicate submission: no idempotency. Fixed with a unique constraint.

3 outdated tests
  asserted a response shape changed deliberately in June. Updated, after
  confirming the new shape is the intended one.

1 flaky test
  a timing assumption on an animation. Rewritten to wait on a condition.
  Ran 20 times consecutively before being trusted.
```

Each of the six was classified before being touched: is the test wrong, or is
the code wrong. Three each way.

## Cost and result

Pipeline duration: 6 minutes cold, 3 minutes 40 warm, first signal at 51
seconds.

The previous pipeline took 6 minutes and its signal meant nothing.
