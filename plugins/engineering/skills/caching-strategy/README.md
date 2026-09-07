# caching-strategy

Decides whether to cache, then where, for how long, keyed by what, and how the
entry is invalidated. Covers browser and HTTP caching, CDN, application and
shared caches, computed values, stampede protection and the correctness rules.

- Inputs: a measurement showing the read is expensive, the staleness budget
  from whoever owns the data, the access patterns.
- Outputs: cache decision, key design, invalidation plan, staleness budget.
- Depends on: engineering-core, performance-engineering.
- Lateral: backend-engineering, frontend-engineering, api-design,
  security-audit.
- Downstream: reliability-testing, observability, testing-quality.

The key contains everything the response varies by: caller, role, tenant,
locale, currency, flags. A cache outage must degrade to the source, never to
an error.
