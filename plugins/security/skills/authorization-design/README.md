# authorization-design

Designs and audits what an authenticated identity may do: the model (ownership,
roles, attributes, relationships), object-level access so one user cannot reach
another's data, enforcement at a server-side choke point, and the escalation
paths that bypass it.

- Inputs: the resources, roles and ownership rules; the operations that touch them.
- Outputs: authorization model, access findings, enforcement plan, applied fixes.
- Depends on: security-core.
- Downstream: security-audit, backend-engineering, api-design.

Object-level authorization is the single most common serious web defect: a
request supplies an id and the row comes back unscoped. This skill exists to
close it. A single unscoped object access reachable by an authenticated user is
a high or critical finding.
