# code-review-protocol

Senior review in five passes: correctness, security, performance,
architecture, robustness. Ranks findings by consequence, fixes every blocker
and major, verifies each fix by running something, then re-reads the diff.

- Inputs: a diff, the surrounding code, the callers, the tests.
- Outputs: review findings, applied fixes, verification log.
- Depends on: engineering-core, project-exploration.
- Lateral: security-audit, performance-engineering, testing-quality.
- Downstream: technical-documentation, project-continuity, git-workflow.

Rubber stamping is a defect. Zero findings on a substantial diff must be
justified in one sentence or the review is redone.
