# incident-response

Runs a production incident from detection to prevention: declaration and
severity, named roles, communication on a rhythm, mitigation before diagnosis,
safe change discipline under pressure, verified recovery, a blameless
postmortem with a real timeline, and action items that enter the normal queue.

- Inputs: the alert or report, the system's signals, the deployment and
  rollback mechanisms, the on call arrangement.
- Outputs: incident record, timeline, mitigation log, postmortem, action
  items.
- Depends on: devops-core, observability, production-verification.
- Lateral: debugging, database-operations, backup-recovery,
  secrets-management.
- Downstream: technical-debt, delivery-planning, technical-documentation.

Restore service first, understand afterwards. The incident lead does not
debug, only one change is made at a time, and the postmortem never names a
person as a cause.
