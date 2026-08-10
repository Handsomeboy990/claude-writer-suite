# deployment-engineering

Gets a verified artefact running in a target environment, on any platform.
Covers target selection from constraints, achievable deployment properties,
expand and contract migration ordering, health gated rollout, a rollback plan
that states what it cannot restore, deployment records and executable
documentation.

- Inputs: the artefact, the target platform, the environment configuration.
- Outputs: deployment procedure, rollback plan, deployment record, platform
  decision.
- Depends on: engineering-core, devops-core, environment-management,
  ci-cd-pipelines.
- Downstream: production-verification, observability, release-engineering.

Platform agnostic: the project's constraints and the client's operations
capability choose the target, not habit. The rollback plan is written before
the deployment, including for small changes.
