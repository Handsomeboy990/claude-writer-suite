# regression-testing

Decides what to re-run after a change, and proves the rest still works.
Impact analysis from the diff, an always-run critical set, tiered selection,
and a comparison against a known baseline.

- Inputs: the diff or the campaign's list of changes, the last known test
  result, the critical set from the testing contract.
- Outputs: impact set, regression selection with its justification, baseline
  comparison, regression verdict.
- Depends on: engineering-core, testing-quality.
- Lateral: playwright-automation, api-testing, debugging.
- Downstream: release-readiness, test-reporting, project-continuity.

Selection is written down, including what was excluded and why. A dependency
change, a migration, a shared utility or anything in the authorization path
forces the full suite.
