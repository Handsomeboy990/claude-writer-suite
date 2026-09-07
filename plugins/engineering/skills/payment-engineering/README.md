# payment-engineering

Builds payment flows that survive money moving: server computed amounts,
idempotency on every operation, a guarded state machine, webhook verification
and replay, reconciliation, refunds and disputes, subscriptions and proration,
and an append only audit trail.

- Inputs: the commercial rules, the provider and its documentation, the
  catalogue and tax rules, the requirements.
- Outputs: payment flow, state machine, idempotency strategy, reconciliation
  plan, audit trail.
- Depends on: engineering-core, backend-engineering, input-validation.
- Lateral: background-jobs, database-design, api-design, security-audit.
- Downstream: reliability-testing, security-testing, testing-quality,
  observability.

The server decides the amount, and every operation can be attempted twice. A
timeout after a capture is treated as unknown and resolved by querying the
provider, never recorded as a failure.
