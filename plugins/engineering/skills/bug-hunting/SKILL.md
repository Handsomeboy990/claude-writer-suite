---
name: bug-hunting
description: Systematic adversarial testing of a working feature: repeated and concurrent actions, double submission, interruption and reload mid operation, back and forward navigation, multiple tabs, expired sessions, degraded networks, failed and malformed responses, boundary and oversized input. Turns each hit into a minimal reproduction. Use after a feature passes its happy path, and before anyone calls it done.
license: MIT
metadata:
  category: dev-skills
  version: 1.0.0
  depends_on: [engineering-core, quality-engineering]
  outputs: [hunt-matrix-results, minimal-reproductions, defect-list, regression-candidates]
---

# Bug Hunting

Exploratory testing uses the product as a person would. This skill abuses it
on purpose, in a fixed order, so that the defects everyone knows exist are
found deliberately rather than by luck in production.

A feature that only survives being used correctly is not finished.

## 1. Entry condition

The happy path passes. Hunting a broken feature wastes the pass: everything
fails and nothing is learned. Fix the happy path first, then hunt.

## 2. The matrix

Nine families. Each is run against the feature under test, and each result is
recorded, including the ones that behave correctly. The expanded version, with
the exact moves per family, is in `resources/hunt-matrix.md`.

| Family | The abuse | The defect it exposes |
|---|---|---|
| repetition | the same action twice, three times, fast | missing idempotency, duplicate records, duplicate mail or charge |
| concurrency | two tabs, two requests, the same instant | lost update, race, unique constraint surfacing as a crash |
| interruption | reload, back, forward, close, escape, mid operation | orphaned state, lost work, half completed writes |
| session | expired, revoked, logged out elsewhere, changed role | silent failure, action accepted after revocation, stale permission |
| network | slow, offline, timeout, failed, retried | spinners that never end, false success, retries that duplicate |
| response | empty, partial, unexpected shape, error body, wrong type | crashes on render, silent blank screens, undefined in the interface |
| input | empty, boundary, one beyond, oversized, unusual characters | truncation, client-only validation, layout breakage, 500 responses |
| sequence | steps out of order, skipped step, resumed old link | state machines that accept impossible transitions |
| environment | viewport change, zoom, language, timezone, back-dated clock | layout collapse, off by one day, wrong currency or format |

## 3. Order

Run the families in the order above. Repetition and concurrency are first
because they are the cheapest to run and the most likely to produce a defect
that matters. Environment is last because its findings are usually cosmetic
and would otherwise consume the session.

## 4. Boundaries and input

Input abuse is a controlled test of validation, not an attack. Use the safe
catalogue in `resources/boundary-inputs.md`: empty, minimum, maximum, maximum
plus one, whitespace only, very long, unusual scripts, control characters,
numeric extremes, malformed dates.

Payload shapes designed to exploit rather than to probe belong to
`security-testing`, under the authorisation of the testing contract. The line
is intent: here the question is whether invalid input is rejected safely, not
whether a boundary can be crossed.

## 5. What is a defect

Not every surprise is one. Before recording, decide:

```
requirement    does a stated requirement or an obvious convention say otherwise
consequence    what does it cost the user, the data, or the business
reproducible   from a clean state, how many times out of how many
scope          only here, or everywhere the same pattern is used
```

A behaviour that is deliberate, documented and harmless is recorded as
`by design` with the reference, so the next hunt does not rediscover it.

## 6. Minimal reproduction

A finding is not finished until it is small. Strip the session down to the
shortest sequence that still produces it:

```
starting state   the fewest preconditions that still work
steps            the fewest actions that still reproduce
frequency        3 of 3, or 2 of 5, stated as observed
evidence         screenshot, console line, network entry, request identifier
scope            which other features share the same code path
```

A five step reproduction gets fixed. A twenty step story gets closed as
unreproducible.

## 7. Prohibitions

- Never run a destructive scenario without explicit authorisation in the
  testing contract.
- Never generate load against a shared or production environment. Volume
  testing is `performance-engineering`, and it is scheduled, not improvised.
- Never test authorization boundaries beyond the accounts and hosts the
  contract names; that is `security-testing`.
- Never report a hit without a minimal reproduction and a frequency.
- Never keep hunting a feature whose happy path is broken.
- Never fix while hunting. Record, finish the matrix, then fix.
- Never leave the environment holding junk that will confuse the next tester.

## 8. Protocol

1. Confirm the happy path passes and the contract permits the families.
2. Identify the feature's write operations, since they carry the risk.
3. Establish a clean, known starting state.
4. Run the nine families in order, recording every result.
5. For each hit, produce the minimal reproduction from a clean state.
6. Rank by consequence, not by how surprising the finding felt.
7. Name the regression candidates: the hits that must become permanent tests.
8. Clean up the data the session created.
9. Hand the list to `test-reporting`, the regression candidates to
   `testing-quality`, and the root cause work to `debugging`.

## 9. Auto-critique

Score from 0 to 5: matrix completeness, order respected, quality of the
minimal reproductions, honesty about frequency, correct separation of defect
from `by design`, regression candidates identified, environment left clean.

Threshold: no axis below 3, average at least 4. A hunt that skipped repetition
or concurrency on a feature with write operations is not a hunt and is rerun.

## 10. Interfaces

- Upstream: `quality-engineering` for the contract,
  `exploratory-testing` for the areas worth hunting.
- Lateral: `security-testing` for anything past a permission boundary,
  `reliability-testing` for injected dependency failure,
  `input-validation` for the adversarial input matrix on the server side.
- Downstream: `debugging` for root cause, `testing-quality` for the permanent
  tests, `test-reporting` for the defect list.
