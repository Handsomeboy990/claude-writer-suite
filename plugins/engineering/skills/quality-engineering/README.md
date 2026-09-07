# quality-engineering

Coordinates a whole quality campaign rather than a single test. Inspects the
project to build a testing map, asks the decision-critical questions once,
fixes a testing contract, selects the disciplines the product actually needs,
sequences them, and issues the final verdict.

- Inputs: the repository, the running application, the target environment, the
  answers to the testing brief.
- Outputs: testing map, testing brief, testing contract, test strategy,
  campaign plan, quality verdict.
- Depends on: engineering-core, project-exploration, testing-quality.
- Coordinates: api-testing, playwright-automation, exploratory-testing,
  bug-hunting, accessibility-testing, security-testing, reliability-testing,
  regression-testing, performance-engineering, security-audit.
- Downstream: test-reporting, release-readiness, project-continuity.

The verdict is one of PASS, PASS WITH WARNINGS, BLOCKED or FAIL, and it names
what was not covered. There is no fifth value, and no campaign concludes with
`everything looks good`.
