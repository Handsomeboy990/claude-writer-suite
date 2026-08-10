# clarification-gate

Separates unknowns that must be asked from unknowns that can be defaulted.
Applies a five part blocking test, converts everything else into assumption
records carrying their cost of reversal, and asks the survivors once, grouped,
in a single batch.

- Inputs: the unknown register from requirements-analysis.
- Outputs: question batch, assumption decisions, gate verdict.
- Depends on: engineering-core, requirements-analysis.
- Downstream: technology-selection, architecture-proposal, validation-gate.

Asking about everything and guessing about everything are the same failure
seen from two sides. A question the system could answer from the source or the
repository is a defect.
