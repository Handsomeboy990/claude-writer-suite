# playwright-automation

Browser level verification: critical journeys, visual checks, responsive
widths, keyboard operability, console and network audits, error state proof
and documentation screenshots. Selectors follow role, label, text, then a
deliberate test identifier; never class chains or positional selectors.

Two modes: the project test runner for permanent journeys, and an interactive
browser CLI for exploration, defect reproduction, evidence capture and
debugging a failing test. The command surface of any CLI is verified against
the installed version before use, never from memory.

- Inputs: the implemented feature, the project browser tooling, the testing
  contract when this runs inside a campaign.
- Outputs: journey tests, screenshots, responsive report, visual evidence,
  console audit, network audit.
- Depends on: engineering-core, testing-quality.
- Lateral: accessibility-testing, exploratory-testing, bug-hunting.
- Downstream: code-review-protocol, technical-documentation, test-reporting,
  release-readiness.

Degrades gracefully: when no browser tooling exists and the change does not
justify adding it, the skill is skipped and the plan says so. Waiting on a
duration is banned; waiting on a condition is the only permitted form. After
every interaction the resulting state is asserted, because a command that
returned successfully proves only that the command ran.
