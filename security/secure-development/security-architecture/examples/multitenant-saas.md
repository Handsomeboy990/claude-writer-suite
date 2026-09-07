# Example: security architecture for a multi-tenant SaaS

A B2B application where each customer organisation is a tenant. The threat model
ranked cross-tenant data exposure as the crown-jewel threat. These are the
structural decisions that answer it, made before implementation.

## Fail closed

```
tenant unknown on a request   -> reject, never fall back to a default tenant
permission not found          -> deny, never treat absence as allow
tenant context missing in a job -> the job refuses to run, it does not run globally
```

## Boundary enforcement, one choke point

```
decision   every data access carries a tenant id, enforced in one data-access
           layer that every query passes through
constraint downstream: no handler builds a raw query; all reads go through the
           scoped repository. A raw query in a handler fails code review.
enforced by: authorization-design (the rule), security-audit (the check)
```

## Identity propagation

```
establish  tenant and user resolved once, at the API edge, into a signed context
propagate  the background job queue carries the tenant context in the payload;
           the worker verifies it, it does not infer the tenant from the data
never      a worker that processes "all pending items" with no tenant scope
```

## Secret topology

```
per-tenant encryption keys for data at rest, so one leaked key exposes one tenant
keys in the secret store, referenced by id; never in the database beside the data
rotation designed: re-encryption job exists from day one, not retrofitted
blast radius: one key = one tenant, not the whole customer base
```

## Isolation

```
data       row-level tenant scope enforced below the application, in the query,
           not only in the route guard
network    the database is reachable only from the application subnet
privilege  the application's database role cannot drop tables or read the audit log
process    tenant-supplied file rendering runs in a separate sandboxed worker
```

## What the architecture produced

Five structural decisions, each with a downstream constraint that a specific
skill enforces and `security-audit` later verifies. The crown-jewel threat,
cross-tenant exposure, now has to survive four independent layers, so a single
implementation bug is a finding, not a breach.
