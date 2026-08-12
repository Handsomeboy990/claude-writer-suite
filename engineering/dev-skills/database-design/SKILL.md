---
name: database-design
description: Designs the schema before it is migrated: entities and relationships, keys and identifiers, constraints that the database enforces, normalisation and the deliberate exceptions, indexes derived from real access patterns, transactions and isolation, soft deletion, tenancy, time and money representation, and the cost of every future change. Use before creating a table, adding a column or changing a relationship.
license: MIT
metadata:
  category: dev-skills
  version: 1.0.0
  depends_on: [engineering-core, architecture-design]
  outputs: [schema-design, constraint-list, index-plan, access-patterns, migration-implications]
---

# Database Design

The schema outlives the framework, the language and usually the team. Every
other layer can be rewritten in a weekend; the data cannot.

Design from the questions the application must answer, not from the screens it
happens to have today.

## 1. Start from access patterns

```
list the reads: what is fetched, by what, how often, how much
list the writes: what changes, together, and how often two of them collide
list the reports: what is aggregated, over what range, by whom
list the lifecycle: what is created, archived, deleted, and when
```

An index, a denormalisation or a partition is justified by a line in that
list. Without the list, both are guesses.

## 2. Entities and relationships

```
one entity per real thing, named as the business names it, in the singular
one to many by a foreign key on the many side, always
many to many through an explicit join table with its own constraints
optional relationships as nullable keys, never as a sentinel value
inheritance flattened deliberately: one table with a type, or one per type,
  decided by how the rows are queried, not by how the classes look
```

The join table is a real entity as soon as it carries a field of its own, and
naming it properly at that moment prevents years of confusion.

## 3. Keys and identifiers

| Choice | Fits | Costs |
|---|---|---|
| sequential integer | small internal systems, natural ordering | enumerable, leaks volume, painful to merge datasets |
| random UUID | distributed generation, no enumeration | index locality, storage, unreadable in logs |
| sortable identifier | distributed generation with ordering | slightly more complex generation |
| natural key | genuinely immutable business values | business values change, and then it is very expensive |

Whatever the internal key, the identifier exposed publicly is opaque and not
enumerable. Never expose a sequence to a client without deciding that
enumeration is acceptable.

## 4. Constraints belong in the database

Application code is one of several writers: migrations, jobs, consoles and the
next service also write. What the database enforces cannot be bypassed.

```
NOT NULL on everything that is genuinely required
foreign keys with a deliberate delete rule: restrict, cascade or set null
unique constraints on every real world uniqueness, including partial ones
check constraints for ranges, enumerations and cross field rules the engine
  can express
defaults for values that must exist from the first insert
```

A uniqueness rule enforced only in the application is a duplicate waiting for
a concurrent request.

## 5. Normalisation, then the exceptions

Normalise by default. Denormalise only with a written reason:

```
acceptable   a counter or an aggregate that would otherwise cost a scan per
             read, with a defined way to recompute it
acceptable   a snapshot of values that must not change with their source, such
             as a line item price on an order
not          copying a field because a join felt inconvenient
not          storing a formatted string instead of its components
```

Every denormalised value states who maintains it and how it is repaired.

## 6. Types

```
money         integer minor units plus a currency, or a decimal type, never a
              binary float
time          timestamp with timezone, stored in UTC, one convention
dates         a date type when there is genuinely no time
enumerations  a database enumeration or a check constraint, not free text
text          a length limit where the business has one, unbounded otherwise
booleans      real booleans, never a nullable one carrying three meanings
JSON          for genuinely unstructured or client defined data, never as a
              way to avoid designing columns
identifiers   one type across the schema, never mixed
```

A nullable boolean has three states and nobody agrees which is which.

## 7. Indexes

```
one index per real access pattern, on the columns in the order they are filtered
composite indexes ordered: equality columns first, then range, then sort
a covering index only where the read is hot and the cost is measured
unique indexes for uniqueness, which also serve as lookups
partial indexes for the common filter on a large table
no index on a column with two distinct values, unless it is partial
every index costs write throughput and storage, and is justified in writing
```

Verify with the engine's plan, on data of a realistic size. An index chosen on
an empty table is a guess with a syntax.

## 8. Concurrency

```
what two users can change at the same time, and what should happen
optimistic locking with a version column where conflicts are rare
explicit locking where they are not, with the smallest possible scope
transaction boundaries drawn around the invariant, not around the request
isolation level chosen deliberately, and the anomalies it permits accepted
in writing
uniqueness enforced by a constraint, since a check then insert always races
```

## 9. Lifecycle

```
soft delete only where the business needs the row back, and then every query
  filters it, or the filter is enforced by a view
hard delete where privacy or volume demands it, with the cascade decided
archival strategy for tables that grow forever
retention rules, from the privacy requirements, expressed as a job
audit trail for the tables where who changed what will be asked
```

## 10. Tenancy

```
tenant column on every tenant owned table, without exception
the predicate applied in one shared place, not in each query
uniqueness constraints scoped per tenant
indexes leading with the tenant column
a check that no table is missing the column, run in the pipeline
```

The last line is the one that catches the table added at midnight two years
from now.

## 11. Change cost

Before finalising, state what each future change would cost:

```
adding a nullable column          cheap
adding a required column          needs a default or a backfill
adding a unique constraint        needs the data to already comply
changing a type                   usually a rewrite of the table
splitting a table                 dual write, backfill, cut over, cleanup
renaming                          two releases, never one
```

Design so that the likely changes are the cheap ones.

## 12. Prohibitions

- Never let application code be the only enforcer of an invariant.
- Never store money in a binary floating point type.
- Never use a naked timestamp with no timezone convention.
- Never model a state machine as free text.
- Never add an index without an access pattern, or remove one without a plan.
- Never introduce a nullable foreign key when the relationship is required.
- Never let a schema change reach a migration file before this design exists.

## 13. Protocol

1. Read the existing schema, its conventions and its migration history.
2. Collect the access patterns: reads, writes, reports, lifecycle.
3. Model entities, relationships and identifiers.
4. Declare every constraint the database can enforce.
5. Choose types deliberately, especially money, time and enumerations.
6. Derive indexes from the access patterns and verify them with plans.
7. Decide transactions, isolation and conflict handling.
8. Decide deletion, retention, archival and audit.
9. Apply the tenancy rules if the product is multi-tenant.
10. State the cost of the likely future changes.
11. Hand the design to `database-operations` for migration and rollout.

## 14. Auto-critique

Score from 0 to 5: access patterns collected first, relationship modelling,
constraints in the database, type discipline, index justification, concurrency
decided, lifecycle and retention, tenancy coverage, honesty about change cost.

Threshold: no axis below 3, average at least 4. A design where an invariant
exists only in application code scores 0 on constraints and is redone.

## 15. Interfaces

- Upstream: `requirements-analysis`, `architecture-design`,
  `technology-selection`.
- Lateral: `backend-engineering` for the queries, `performance-engineering`
  for measured plans, `data-privacy` for retention and personal data,
  `security-testing` for tenancy verification.
- Downstream: `database-operations` for migrations, backfills and rollout,
  `testing-quality` for constraint and concurrency tests,
  `technical-documentation` for the schema reference.
