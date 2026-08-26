# technical-debt

Makes debt visible, comparable and payable. Separates deliberate debt from
mess, measures the interest each item charges, ranks by the change it makes
expensive, and pays inside real work rather than in a cleanup sprint.

- Inputs: the codebase, the change history, the defect record, the roadmap.
- Outputs: debt register, interest estimates, payment plan, deliberate debt
  records.
- Depends on: engineering-core, project-exploration.
- Lateral: refactoring, architecture-design, dependency-selection.
- Downstream: delivery-planning, decision-records, project-continuity.

If nothing costs more because of it, it is a preference, not debt. The
interest line is what makes the register discussable with people who do not
read the code.
