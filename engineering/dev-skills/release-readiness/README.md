# release-readiness

Final gate before shipping. Nine gates: scope, tests, security, performance,
migrations, configuration, documentation, rollback, observability. Produces
deployment notes, a rollback plan that acknowledges what cannot be rolled
back, and a go or no go verdict with named blockers.

- Inputs: the revision, the diff since the last release, the results of the
  upstream skills.
- Outputs: readiness report, go or no go verdict, rollback plan, deployment
  notes.
- Depends on: engineering-core, testing-quality, security-audit,
  project-continuity.
- Downstream: the deployment, and the continuity record of what shipped.

There is no `probably fine`. A gate that could not be checked is reported as
unchecked with its missing input, and the verdict accounts for it.
