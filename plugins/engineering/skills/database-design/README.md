# database-design

Designs the schema before any migration exists: entities and relationships,
identifiers, constraints the database enforces, types, indexes derived from
real access patterns, concurrency, lifecycle, tenancy and the cost of future
change.

- Inputs: the requirements, the access patterns, the existing schema and its
  conventions.
- Outputs: schema design, constraint list, index plan, access patterns,
  migration implications.
- Depends on: engineering-core, architecture-design.
- Lateral: backend-engineering, performance-engineering, data-privacy,
  security-testing.
- Downstream: database-operations, testing-quality, technical-documentation.

Indexes are justified by an access pattern and verified with a plan on
realistic data. Invariants live in the database, because application code is
only one of the writers.
