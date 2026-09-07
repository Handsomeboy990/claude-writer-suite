# client-handover

Produces the package a client or another team can take over: overview,
features as built, architecture, stack, verified installation, configuration,
development, testing, deployment, an operations runbook, administration,
limitations with triggers, follow ups and support boundaries.

- Inputs: the delivered system, the documentation, the continuity notes, the
  stub and follow up registers.
- Outputs: handover package, operations guide, limitations register, follow up
  list.
- Depends on: engineering-core, technical-documentation, project-continuity.
- Downstream: release-readiness.

Serves two readers in separate sections. The feature table describes what was
built, not what was specified, and every installation step was executed on a
clean state before it was written. No secret value ever enters the package.
