# api-design

Designs the contract before it is implemented: style, resources, operations,
shapes, one error format, collections, writes and idempotency, authentication
and per operation authorization, limits, versioning and the published
specification.

- Inputs: the consumers and their operations, the existing surface and its
  conventions, the data model, the requirements.
- Outputs: API contract, endpoint specification, error format, versioning
  policy.
- Depends on: engineering-core, architecture-design.
- Lateral: input-validation, backend-engineering, security-audit.
- Downstream: api-testing, technical-documentation, release-engineering.

Additive changes are free, breaking changes cost a version and a deprecation
path, and a change is breaking if any conforming client could stop working.
