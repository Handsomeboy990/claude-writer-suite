# testing-quality

Selects the lowest layer that can observe a behaviour, then writes tests that
can actually fail. Enforces ten mandatory cases per feature, including
unauthorized access, duplicate submission and external failure, which are the
ones usually skipped.

- Inputs: the change, the project test setup, the behaviours introduced.
- Outputs: test plan, tests, coverage gaps, execution log.
- Depends on: engineering-core, project-exploration.
- Lateral: playwright-automation, input-validation.
- Downstream: code-review-protocol, release-readiness, project-continuity.

Never weakens a test to make a suite green. When a test fails, the first
question is which of the test or the code is wrong, and the answer is stated.
