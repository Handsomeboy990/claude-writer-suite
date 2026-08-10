# observability

Makes a running system explain itself: structured correlated logs with
consistent levels, liveness readiness and version endpoints, a small metric
set with named consumers, grouped error reporting, alerts tied to user impact
and to a written response, and redaction applied at the logger.

- Inputs: the application, the platform, the architecture section 9.
- Outputs: logging policy, health endpoints, metric set, alert rules,
  redaction rules.
- Depends on: engineering-core, devops-core, backend-engineering.
- Downstream: production-verification, backup-recovery, client-handover.

Required before the first production deployment, not after the first
incident. Verified by breaking something deliberately and confirming it
becomes visible.
