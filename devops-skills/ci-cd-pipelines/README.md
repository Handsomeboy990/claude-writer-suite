# ci-cd-pipelines

Builds a pipeline that fails for the right reasons: ten stages ordered by
cost, every stage blocking or removed, dependency caching, one artefact built
and promoted rather than rebuilt per environment, secrets scoped per
environment, explicit deployment triggers and branch protection.

- Inputs: the platform's pipeline mechanism, the repository, the test suite.
- Outputs: pipeline definition, quality gates, artefact strategy, pipeline
  report.
- Depends on: engineering-core, devops-core, testing-quality.
- Downstream: deployment-engineering, release-readiness.

Never weakens a check to obtain green. The pipeline is verified by breaking
something deliberately and confirming the right stage catches it; one that has
never been proven to fail is not a gate.
