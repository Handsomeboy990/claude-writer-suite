# database-operations

Runs database work safely in live environments: migration authoring, a lock
profile table for every common statement, batched and resumable backfills,
honest seeding per environment, connection pool arithmetic, production query
safety and the destructive statement protocol.

- Inputs: the schema, the migrations, the live environment, the table sizes.
- Outputs: migration plan, lock assessment, seed strategy, operation record.
- Depends on: engineering-core, devops-core, backend-engineering.
- Lateral: deployment-engineering, performance-engineering.
- Downstream: backup-recovery, production-verification, release-readiness.

The rule that prevents the worst incident: before any destructive statement,
run its SELECT COUNT(*) form with the same WHERE clause and confirm the number
is the one you expected.
