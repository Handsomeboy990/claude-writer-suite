# backend-engineering

Server side implementation to production standard: three way layering, a
mandatory handler order ending in object level authorization, the never trust
the client list, query and index rules, transaction and concurrency
discipline, migration strategy, a two kind error contract, external service
failure policy, job design, observability and API contract rules.

- Inputs: architecture decisions, project conventions, the validated input
  contract.
- Outputs: handlers, services, migrations, error contract, observability
  notes.
- Depends on: engineering-core, project-exploration, architecture-design.
- Downstream: security-audit, testing-quality, performance-engineering,
  code-review-protocol, technical-documentation.

Authentication says who. Authorization says whether. Passing the first is not
passing the second.
