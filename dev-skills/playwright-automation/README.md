# playwright-automation

Browser level verification: critical journeys, visual checks, responsive
widths, keyboard operability, error state proof and documentation
screenshots. Selectors follow role, label, text, then a deliberate test
identifier; never class chains or positional selectors.

- Inputs: the implemented feature, the project browser tooling.
- Outputs: journey tests, screenshots, responsive report, visual evidence.
- Depends on: engineering-core, testing-quality.
- Downstream: code-review-protocol, technical-documentation,
  release-readiness.

Degrades gracefully: when no browser tooling exists and the change does not
justify adding it, the skill is skipped and the plan says so. Waiting on a
duration is banned; waiting on a condition is the only permitted form.
