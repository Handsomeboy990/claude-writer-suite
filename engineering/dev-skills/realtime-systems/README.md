# realtime-systems

Builds live features that survive real networks: transport choice, connection
lifecycle and reconnection, state recovery by cursor, message contract,
authorization on every message, ordering and conflict resolution, fan out,
backpressure and offline behaviour.

- Inputs: the latency requirement, the data being made live, the identity and
  permission model, the deployment topology.
- Outputs: transport decision, connection lifecycle, message contract,
  recovery strategy, scaling plan.
- Depends on: engineering-core, architecture-design.
- Lateral: backend-engineering, frontend-engineering, background-jobs,
  api-design.
- Downstream: reliability-testing, security-testing, observability,
  performance-engineering.

Design the recovery path first. Polling every thirty seconds is a legitimate
design with one failure mode, and it is refused only for a stated reason.
