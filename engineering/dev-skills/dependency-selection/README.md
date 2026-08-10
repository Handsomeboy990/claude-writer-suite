# dependency-selection

Decides whether a library is added, replaced, upgraded or refused. Starts with
three questions that end most discussions, then applies a twelve point
evaluation with evidence, measures the real cost from the lockfile and the
build, and records the decision with its escape cost.

- Inputs: the need, the project's installed tree, candidate libraries.
- Outputs: dependency decision, evaluation record, migration plan.
- Depends on: engineering-core, project-exploration.
- Downstream: security-audit, performance-engineering, testing-quality,
  git-workflow, technical-documentation.

One dependency change per commit, so a regression can be bisected. Never a
major upgrade inside a feature commit.
