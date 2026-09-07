# requirements-analysis

Turns a specification, brief, PRD, feature list, mockup, conversation or
existing repository into an implementable engineering specification. Keeps four
registers strictly separate: requirements, assumptions, constraints, unknowns.

- Inputs: any project input, plus the repository when one exists.
- Outputs: engineering specification, assumption register, unknown register,
  scope boundary.
- Depends on: engineering-core.
- Downstream: clarification-gate, technology-selection,
  architecture-proposal.

Never invents a requirement. Every assumption records what changes if it turns
out to be wrong, and requirements are rewritten until each one is testable.
