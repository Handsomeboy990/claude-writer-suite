# Schema review checklist

Run against a proposed schema, and against an inherited one. Each line is
`ok`, `finding`, or `n/a` with a reason.

## Structure

```
every table has a primary key
every foreign key has an explicit delete rule
every required field is NOT NULL
every real world uniqueness has a unique constraint
every enumeration is constrained, not free text
every cross field rule the engine can express is a check constraint
no column stores two different meanings depending on another column
no table has a column named data, info, meta or extra holding real fields
```

## Types

```
money is not a binary float
timestamps carry a timezone and one storage convention
dates are dates, not timestamps at midnight in an unstated zone
identifiers use one type across the schema
text fields have a limit where the business has one
booleans are not nullable
JSON columns hold genuinely unstructured data, and are documented
```

## Indexes

```
every index maps to a named access pattern
composite index column order matches the query shape
no duplicate or prefix-redundant indexes
foreign keys used in joins are indexed
large tables use partial indexes for their common filter
unused indexes identified from engine statistics
write heavy tables reviewed for index count
plans verified on realistic data volume, not on an empty table
```

## Integrity under concurrency

```
uniqueness enforced by a constraint, never by a read then write
counters updated atomically, or derived
state transitions guarded by a condition in the update, not by a prior read
transaction boundaries match the invariant
isolation level stated, and its anomalies accepted in writing
```

## Tenancy

```
every tenant owned table carries the tenant column
uniqueness constraints are scoped per tenant
indexes lead with the tenant column
one shared place applies the predicate
a pipeline check lists tables missing the column
```

## Lifecycle and privacy

```
soft deleted rows are filtered everywhere, or behind a view
retention rules exist for personal data, and a job enforces them
archival exists for tables that grow without bound
audit trail exists where who changed what will be asked
personal data is inventoried, and its columns are known
```

## Operability

```
every migration is reversible, or documented irreversible with the reason
the previous release still works against the new schema
the new release works against the old schema, for the deployment window
backfills are batched and resumable
index creation on a large table uses the concurrent form the engine offers
locks taken by each migration are known before it runs
```

## Findings format

```
DB-03  uniqueness enforced in application code only
Table  memberships (organisation_id, user_id)
Risk   two concurrent invitations create two memberships. Observed once in
       production logs on 2026-06-02.
Fix    unique constraint, plus the handler translating the violation into a
       409 rather than a 500
Cost   one migration, requires deduplicating 4 existing rows first
```
