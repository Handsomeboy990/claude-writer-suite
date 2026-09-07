# migration-engineering

Moves a running system from one framework, library, database, provider or
architecture to another in shipped reversible steps. Inventory, compatibility
analysis, parallel change, dual running, data migration with verification, cut
over, rehearsed rollback, and the cleanup that usually gets cancelled.

- Inputs: the reason for the migration, the current system, the target and its
  migration documentation, the data.
- Outputs: migration inventory, compatibility matrix, migration plan, cutover
  plan, rollback plan.
- Depends on: engineering-core, project-exploration.
- Lateral: refactoring, legacy-code, database-design, database-operations,
  testing-quality.
- Downstream: regression-testing, deployment-engineering,
  production-verification, decision-records.

The transitional state carries the risk, so it is designed rather than
endured. A rollback that has never been executed is a hypothesis.
