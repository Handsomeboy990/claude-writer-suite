# engineering-orchestrator

Central routing layer. Classifies the request into one of twenty categories,
locates the affected surface, composes the smallest complete plan from the
canonical plans, enforces the mandatory gates, prevents loops and issues the
completion verdict.

- Inputs: the user request, the repository.
- Outputs: task classification, execution plan, verification gates,
  completion verdict.
- Depends on: engineering-core, project-exploration.
- Downstream: every skill in `dev-skills`.

Reference data: `resources/execution-plans.md` holds one machine checkable
plan per category, `resources/routing-table.md` maps phrasing and diff facts
to categories and forced gates.

Validated by `tests/validate-orchestration.sh`, which checks that every
category has a plan, that every plan step names a real skill, and that the
mandatory gates appear in the plans that require them.
