# Record template

```markdown
# ADR-0014: Orders own their line item prices

Status:    accepted
Date:      2026-08-12
Deciders:  backend, product
Supersedes: none
Superseded by: none

## Context

Prices change. Products are edited by the catalogue team several times a week,
including retroactive corrections. Invoices are generated from orders up to
three years after purchase, and are legally required to show the price that
was charged.

Today the order stores a product identifier, and the invoice reads the current
price through a join.

## Forces

- an invoice must show what was charged, permanently
- the catalogue team must be free to change prices without side effects
- a join is simpler than a copy, and one source of truth is a real value
- storage cost is negligible at our volume

## Options

1. Join to the catalogue at read time. Simplest, one source of truth, and
   wrong: an invoice reprinted after a price change shows a false amount.
   This is the current behaviour and the reason for this record.

2. Price history table with validity ranges. Correct, and the query becomes
   temporal. Every read of an order needs the order date and a range lookup.
   Cost: complexity in every read path, and a class of off by one errors at
   the range boundaries. Nearly chosen.

3. Copy the price onto the order line at creation. The order becomes the
   record of what was agreed. Denormalised by design.

## Decision

Order lines store the unit price, the currency and the tax rate applied at the
moment the order is placed. The catalogue remains the source of truth for
current prices only.

## Consequences

- an invoice is reproducible from the order alone, for as long as it is kept
- catalogue edits have no retroactive effect, which is the point
- a price correction that must apply retroactively becomes an explicit
  operation on orders, not a catalogue edit. This is more work and it is
  deliberate.
- reporting on current prices and on charged prices are two different queries,
  and someone will confuse them at least once
- order lines now carry data that can drift from the catalogue in ways that
  look like defects to anyone who assumes normalisation

## Reversal

Reversing this means reintroducing a temporal lookup, which requires a price
history we do not keep today. If we ever need per-product price history for
analytics, option 2 becomes attractive again and this record is superseded
rather than edited. Cost of reversal, from today: a history table, a backfill
from order lines, and a change to every read path. Roughly two weeks.
```

## Index format

```markdown
# Decision records

| ID | Title | Status | Date |
|---|---|---|---|
| 0014 | Orders own their line item prices | accepted | 2026-08-12 |
| 0013 | One database per service, no shared tables | accepted | 2026-06-04 |
| 0012 | Sessions in the database, not in the cache | superseded by 0018 | 2026-05-11 |
```

## Superseding

```markdown
# ADR-0018: Sessions move to the cache with a database fallback

Status: accepted
Supersedes: ADR-0012

## Context

ADR-0012 chose database sessions when the service ran on one node and login
volume was under 200 per minute. Both facts changed: three nodes, 4000 logins
per minute at peak, and the session table is now the hottest write in the
system.

The earlier decision was correct for the system as it was.
```

That last sentence is not politeness. It tells the reader that the change came
from the world, not from a disagreement, which is what makes the record
trustworthy.

## Length

One page. If a record needs five pages, it is a design document with a
decision at the end; write the design document, and let the record point at
it.
