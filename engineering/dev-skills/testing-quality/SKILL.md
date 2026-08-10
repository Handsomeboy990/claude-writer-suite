---
name: testing-quality
description: Chooses the right test layer and writes tests that catch real defects: happy path, invalid input, empty data, errors, unauthorized access, duplicates, boundaries, external failures and business rules. Forbids weakening a test to make it pass. Use whenever behaviour changes.
license: MIT
metadata:
  category: dev-skills
  version: 1.0.0
  depends_on: [engineering-core, project-exploration]
  outputs: [test-plan, tests, coverage-gaps, execution-log]
---

# Testing and Quality

A test exists to fail when the behaviour is wrong. A test that cannot fail is
a comment with a runtime cost.

## 1. Choosing the layer

Test at the lowest layer that can observe the behaviour, and only there.

| Layer | Use for | Do not use for |
|---|---|---|
| unit | pure logic, calculations, rules, transforms | anything needing a database or a browser |
| integration | handler with a real database, service with real queries | rendering |
| component | rendered states, interaction, accessibility | business rules |
| contract | request and response shape, status codes | UI |
| end to end | critical user journeys across pages | every permutation of a form |

The pyramid is a budget, not a dogma. Most defects that reach production are
integration defects, so a project with a thousand unit tests and no
integration test is not well tested; it is well decorated.

## 2. Mandatory cases

For every meaningful feature, these exist or their absence is justified in
writing.

```
1  happy path, the case the feature was written for
2  invalid input, at least one per validated field
3  empty data: no rows, empty collection, first use
4  error path: the dependency fails, the query throws
5  unauthenticated access
6  authenticated but unauthorized access
7  duplicate submission, sequential and concurrent
8  boundary values: minimum, maximum, one beyond each
9  external service failure and timeout
10 the business rules the feature exists to enforce
```

Cases 5, 6 and 7 are the ones most often skipped and the ones that catch the
defects that matter. A feature with only case 1 is untested.

## 3. Writing a test that can fail

```
Arrange   the smallest state that makes the behaviour reachable
Act       one action
Assert    the observable outcome, not the implementation
```

Rules:

- one behaviour per test, named after the behaviour, not after the function;
- assert on results and effects, not on the number of times an internal method
  was called;
- no assertion that passes for the wrong reason, such as expecting a truthy
  value where any object satisfies it;
- verify the test fails before the fix or the feature exists. A test that has
  never been red has never been checked;
- deterministic: fixed clock, seeded randomness, no dependency on ordering or
  on wall clock time;
- independent: any test can run alone, in any order, twice in a row.

## 4. Test data

- Build data with a factory or a helper, so that adding a required field does
  not break fifty tests.
- Each test names only the fields it cares about; the rest are defaults.
- No shared mutable fixture across tests.
- No production data, ever. No real personal data, no real keys, no real card
  numbers.
- Clean up, or use a transaction rollback per test, decided once for the
  project.

## 5. Doubles

| Double | Use when |
|---|---|
| none, use the real thing | it is fast and deterministic, which includes most databases in a container |
| fake | an in memory implementation of a real interface is available |
| stub | a canned response is enough |
| mock with assertions | the interaction itself is the behaviour under test, which is rare |

Never mock the unit under test. Never mock a type the project owns just to
avoid understanding it. Mocking a database in an integration test removes the
exact thing that test exists to check.

External providers are stubbed at the network boundary, with the real client
code exercised. Stubbing the client library instead means the request the
client actually builds is never tested.

## 6. Flaky tests

A flaky test is a defect with two possible locations: the test, or the code.
Deleting or retrying it hides which.

Ranked causes: a real race condition in the code, a timing assumption in the
test, shared state between tests, dependence on ordering, a real clock, an
unseeded random source, a network call, an animation not awaited.

The fix is the cause. `retries: 3` is a way to keep a race condition in
production and stop hearing about it.

## 7. Prohibitions

- Never modify a test to make it pass without deciding which of the test or
  the code is wrong, and saying which.
- Never delete a failing test to unblock a task.
- Never weaken an assertion to accommodate a change in behaviour that nobody
  asked for.
- Never add a test that asserts current behaviour without knowing whether that
  behaviour is correct.
- Never chase a coverage percentage. Coverage says which lines ran, not which
  behaviours are protected.
- Never leave a test skipped without a reason and an owner.
- Never test a framework's behaviour instead of the project's.

## 8. Protocol

1. Read the project test setup: framework, layout, naming, run commands.
2. List the behaviours the change introduces or modifies.
3. Map each behaviour to the lowest layer that can observe it.
4. Write the mandatory cases from section 2 that apply.
5. Run the new tests and watch them fail for the right reason.
6. Implement or fix.
7. Run them again and watch them pass.
8. Run the full suite and confirm nothing else broke.
9. Report the gaps that remain, with reasons.

## 9. Report format

```
Added 14 tests across 3 files.

lib/services/invitations.test.ts   9 cases
  happy path, invalid email, invalid role, duplicate pending,
  existing member, seat limit, expired token, wrong team, concurrent duplicate

app/api/.../route.test.ts          4 cases
  unauthenticated 401, non admin 403, unknown team 404, valid 201

e2e/invitations.spec.ts            1 journey
  invite, accept, member appears in the list

Execution
  npm test          228 passing, 0 failing, 12.4s
  npm run test:e2e  6 passing, 0 failing, 41s

Gaps
  mail provider failure is covered with a stub, not end to end: the test
  environment has no mail sandbox. Recorded in continuity notes.
```

## 10. Auto-critique

Score from 0 to 5: layer choice, mandatory case coverage, tests observed
failing first, determinism, independence, quality of assertions, honesty about
gaps, no test weakened.

Threshold: no axis below 3, average at least 4. A suite with no unauthorized
access case on a feature that has authorization is an automatic failure.

## 11. Interfaces

- Upstream: every implementation skill, `debugging` for regression tests.
- Lateral: `playwright-automation` for the browser layer,
  `input-validation` for the adversarial matrix.
- Downstream: `code-review-protocol`, `release-readiness`,
  `project-continuity`.
