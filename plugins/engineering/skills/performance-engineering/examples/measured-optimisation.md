# Example: a dashboard, measured

Report: "the team dashboard is slow, sometimes it takes six seconds".

## Symptom, made precise

```
Who        teams with more than roughly 500 orders
What       the dashboard becomes interactive slowly
Where      all environments, worse on production data volume
Percentile the complaint is about the worst case, not the median
```

The precision matters: an optimisation targeting the median would have
improved the number nobody complained about.

## Baseline

```
Data volume   1,200 orders, 4,800 line items, 300 customers, seeded
Environment   local, production build
Network       throttled, Fast 3G profile
Cache         cold
Runs          5
Revision      7c1a904

LCP           4.8s median, range 3.9 to 6.1
Requests      1 document, 14 assets, 3 API calls
API latency   /api/dashboard 3.9s median
Bundle        480 kB, budget is 400 kB
```

Two candidate problems are visible: a 3.9 second API call and a bundle over
budget. The API call dominates, so it goes first. Fixing the bundle would have
improved a 4.8 second load to 4.5 seconds and produced a report claiming
progress.

## Finding the dominant cost, by counting

```
Query log for one request to /api/dashboard: 142 queries.
```

The count answers the question before any timing analysis. One query for the
orders, then one per order for the customer, then one per order for the line
item count.

```ts
const orders = await db.order.findMany({ where: { teamId }, take: 100 })
for (const order of orders) {
  order.customer = await db.customer.findUnique({ where: { id: order.customerId } })
  order.lineCount = await db.lineItem.count({ where: { orderId: order.id } })
}
```

Two N plus 1 patterns in six lines. The code reads perfectly well, which is
why review missed it and the query log did not.

## Target

```
From the product requirement: the dashboard is interactive in under 2 seconds
on the reference network profile.
```

A target exists, so there is a defined stopping point.

## Change one, of one

```ts
const orders = await db.order.findMany({
  where: { teamId },
  take: 100,
  select: {
    id: true,
    reference: true,
    totalMinor: true,
    currency: true,
    createdAt: true,
    customer: { select: { id: true, name: true } },
    _count: { select: { lineItems: true } },
  },
})
```

One query. The explicit `select` also removes fields the dashboard never
displayed, which halves the payload as a side effect.

## The plan, read before and after

```
before  Seq Scan on orders  (cost=0.00..2847 rows=1200 width=248)
        Filter: (team_id = $1)
        rows removed by filter: 41,203

after   Index Scan using orders_team_created_idx on orders
        (cost=0.42..38 rows=100 width=96)
```

The index was added because the plan showed a sequential scan removing forty
one thousand rows, not because filtering by `team_id` looked like it deserved
one. Reading the plan before and after is what separates an index from a
guess.

```sql
create index orders_team_created_idx on orders (team_id, created_at desc);
```

Composite order chosen deliberately: equality on `team_id`, then the ordering
column. Reversed, the index would not serve this query.

## After, identical conditions

```
Data volume   identical
Environment   identical
Network       identical
Cache         cold
Runs          5
Revision      b2f8e11

LCP           1.4s median, range 1.2 to 1.7
Queries       3 per request
Payload       412 kB to 96 kB
API latency   3.9s to 0.21s median
```

## Delta

```
Queries       142 to 3
API latency   3.9s to 0.21s median
LCP           4.8s to 1.4s median, range 6.1 to 1.7 at the tail
Target        under 2s, met
```

The tail improved more than the median, which is the outcome the complaint
called for.

## What was not done, and why

```
Bundle is 480 kB against a 400 kB budget. Not addressed here.
Reason: the target was met without it, and mixing two optimisations into one
change would have made the delta unattributable.
Recorded as a separate task with its own baseline.
```

## What was resisted

A cache in front of the dashboard endpoint was proposed at the start. It would
have hidden 142 queries behind a hit rate, made the first request after every
invalidation slow, and introduced a staleness bug the day someone forgot an
invalidation. The measurement made the real fix obvious and the cache
unnecessary.
