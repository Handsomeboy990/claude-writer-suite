# Technology decision record format

One block per major decision, collected in `docs/architecture/technology-decisions.md`.

````markdown
## D3 Persistence

Decision:     PostgreSQL 16, managed
Requirement:  R7 orders and payouts must be consistent; R12 reporting queries
              across sellers, orders and payouts
Why:          the data is relational and the invariants are financial. Foreign
              keys, transactions and a unique constraint per payout are the
              mechanisms this project relies on for correctness, and they are
              database features rather than application code.

Alternatives considered:

  MySQL       equally capable for this workload. Rejected because the payout
              ledger uses partial indexes and exclusion constraints, which
              PostgreSQL supports and MySQL does not; the workaround is
              application level locking, which is the thing being avoided.

  MongoDB     rejected. The access pattern is cross entity reporting and the
              invariants are multi row. Both are the cases document stores
              handle worst, and modelling them would reimplement joins and
              transactions in application code.

  SQLite      rejected for production, not for tests. Concurrent writers and a
              managed backup story are both required, and neither is a fit.

Trade-off:    a managed PostgreSQL costs money from day one, where SQLite
              would cost nothing. Accepted: 25 EUR per month against a payout
              correctness problem that would cost far more once.

Cost:         25 EUR per month at launch, scales with storage and connections.
Reversal:     very expensive. The schema, the queries and the migration
              history are all engine specific in places. Treat as fixed.
````

## The rejection test

Read the `Alternatives` block and ask: would an engineer who prefers the
rejected option recognise their position in the description?

```
Fails the test:
  MongoDB     rejected, not suitable for relational data.

Passes:
  MongoDB     rejected. The access pattern is cross entity reporting and the
              invariants are multi row. Both are the cases document stores
              handle worst.
```

The first version is a label. The second is an argument the reader can
disagree with, which is the point of writing it down.

## Decisions worth a record

Not every choice needs one. These do, because reversing them is expensive:

runtime and language, database engine, application framework, authentication
approach, hosting and deployment target, payment provider, mail provider, file
storage, anything that stores data, anything with a recurring cost, anything
the client's operations team must run.

These do not, because `dependency-selection` covers them and they are cheap to
change:

a date library, a validation library, a UI component library inside an already
chosen framework, a test runner inside an already chosen ecosystem, a linter,
a formatter.

## Cost note format

````markdown
## Recurring cost at launch

| Item | Monthly | Scales with | Free tier |
|---|---|---|---|
| Hosting | 20 EUR | instances | yes, insufficient for production |
| PostgreSQL managed | 25 EUR | storage, connections | no |
| Object storage | 5 EUR | stored GB, egress | yes, 10 GB |
| Mail provider | 0 EUR | messages sent | yes, 3,000 per month |
| Error tracking | 0 EUR | events | yes, 5,000 events |
| Total | 50 EUR | | |

At 10,000 monthly active users, estimated 180 EUR, driven by storage and mail
volume. The estimate is stated as an estimate; the drivers are named so it can
be recomputed rather than trusted.
````

The value of this table is not precision. It is that the person approving the
architecture learns the recurring cost before the first invoice rather than
after it.

## Inherited decision format

````markdown
## D1 Runtime

Decision:     Node.js 24
Source:       inherited. The client's platform team supports Node and Python
              only, stated in the constraints as C2.
Consequence:  no evaluation performed. Go and Rust were not considered because
              the constraint excludes them.
Risk:         none for this project's workload.
````

Four lines. It prevents the next engineer from reading the stack and assuming
somebody weighed Node against Go on the merits.
