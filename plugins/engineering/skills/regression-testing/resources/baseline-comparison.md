# Baseline comparison

A test result is a number. A comparison is information.

## What a baseline is

```
command      the exact command, including flags and filters
environment  the machine or runner, the database, the seed data
build        the commit under test
result       passed, failed, skipped, duration
failures     the named tests already failing, with their age
```

A baseline from a different command or environment is not a baseline. The most
common false regression is a comparison between a local run with a filter and a
CI run without one.

## The four differences

| Difference | Meaning | Action |
|---|---|---|
| newly failing | a regression, until proven otherwise | diagnose before anything else |
| newly passing | a fix, or a test that stopped asserting | read the test, do not celebrate |
| newly skipped | coverage silently removed | find who skipped it and why |
| duration drift | a performance change, or a new wait | investigate beyond the project tolerance |

## Newly passing deserves suspicion

A test that passes without a related change usually means one of:

```
the assertion was weakened in this diff
a shared fixture now satisfies it accidentally
the test was flaky and this run was lucky
the behaviour changed and the test was too loose to notice
```

Each of these is a defect in the suite, and each of them is reported.

## Report format

```
REGRESSION RUN
  build        4c17ab9        baseline  8f21c04
  command      pnpm test -- --run
  environment  CI, postgres 16, seeded

  baseline     214 passed, 2 failed, 3 skipped, 96s
  current      219 passed, 3 failed, 3 skipped, 104s

  newly failing
    cart/total.test.ts > applies a percentage discount before tax
      diagnosed: real regression, discount applied after tax. Fixed.

  still failing, pre-existing
    mail/provider.test.ts > retries a 502          failing since 2026-06-14
    search/index.test.ts > ranks exact matches     failing since 2026-07-02
    both are named in every report until they are fixed or deleted

  newly passing
    none

  newly skipped
    none

  duration
    +8s, attributed to five new tests. Within tolerance.

  not run
    the browser suite, which needs a running application. Ran separately,
    result attached.
```

## The verdict

```
NO REGRESSION     nothing newly failing, differences diagnosed
REGRESSION FIXED  newly failing, cause found, fixed, re-run green
REGRESSION OPEN   newly failing, named, not fixed, with the reason
INCONCLUSIVE      the baseline is not comparable, and why
```

`INCONCLUSIVE` is a legitimate result and is far better than a green claim
built on a comparison that did not hold.
