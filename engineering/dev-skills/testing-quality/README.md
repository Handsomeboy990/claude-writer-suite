# testing-quality

States the requirement, selects the lowest layer that can observe a behaviour,
then writes tests that can actually fail. Enforces ten mandatory cases per
feature, including unauthorized access, duplicate submission and external
failure, which are the ones usually skipped. Reviews the suite itself, since
nothing else does.

- Inputs: the change, the requirement or acceptance criterion, the project
  test setup, the behaviours introduced.
- Outputs: test plan, tests, coverage gaps, execution log, suite review.
- Depends on: engineering-core, project-exploration.
- Lateral: playwright-automation, api-testing, input-validation,
  reliability-testing.
- Downstream: regression-testing, code-review-protocol, release-readiness,
  project-continuity, test-reporting.

Never weakens a test to make a suite green. When a test fails, the first
question is which of the test or the code is wrong, and the answer is stated.
