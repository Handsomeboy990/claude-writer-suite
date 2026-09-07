# refactoring

Structural change with no behaviour change, proven rather than asserted.
Contract first, small reversible steps, a green suite between each, and
refactoring commits kept separate from behaviour commits.

- Inputs: the reason the current structure is expensive, the existing tests or
  the characterization tests written for the purpose.
- Outputs: behaviour contract, ordered refactoring steps, equivalence
  evidence.
- Depends on: engineering-core, testing-quality.
- Lateral: architecture-design, legacy-code, technical-debt.
- Downstream: regression-testing, performance-engineering, git-workflow.

If a test had to be modified to keep passing, the refactoring changed
behaviour. That is the single check that keeps the discipline honest.
