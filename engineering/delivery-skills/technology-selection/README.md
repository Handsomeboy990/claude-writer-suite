# technology-selection

Chooses a project's stack in dependency order, with a written record per
decision: choice, driving requirement, reason, real alternatives, why each was
rejected, the trade-off accepted, the recurring cost and the reversal cost.

- Inputs: the specification, constraints, surviving assumptions.
- Outputs: technology decisions, rejected alternatives, operational cost note.
- Depends on: engineering-core, requirements-analysis.
- Lateral: dependency-selection, for libraries inside the chosen stack.
- Downstream: architecture-proposal, validation-gate, devops-core.

Carries a defaults table, so complexity has to be argued for rather than
around. A decision justified only by popularity, familiarity or novelty fails
the skill's own review.
