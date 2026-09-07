# Example: renaming a column without breaking the window

Requirement: `orders.customer_name` becomes `orders.buyer_name`, and the
application reads the new name.

340,000 rows. Four instances. Rolling deployment, so both versions serve
traffic for roughly ninety seconds.

## The one step version, which breaks

```sql
alter table orders rename column customer_name to buyer_name;
```

Deployed with the code change, in one release.

```
t+0s   migration runs, the column is renamed
t+0s   old instances, still running, query customer_name
       -> error: column "customer_name" does not exist
t+0s   every request touching orders fails
t+90s  the last old instance is replaced, errors stop
```

Ninety seconds of total failure on the orders path, on a change nobody would
call risky. Rolling back makes it worse: reverting the code returns instances
that query a column that no longer exists.

## Expand and contract, across three releases

### Release 1, expand

```sql
alter table orders add column buyer_name text;
create index concurrently orders_buyer_name_idx on orders (buyer_name);
```

Additive. Both versions work: the old one ignores the new column, the new one
does not exist yet.

Deployed with no code change. Nothing observable happens.

### Release 1b, backfill

```sql
-- bounded, resumable, run repeatedly until it reports zero
update orders
set buyer_name = customer_name
where buyer_name is null
  and id in (
    select id from orders where buyer_name is null limit 5000
  );
```

Run in a loop with a pause between batches. Resumable because the predicate is
the state, not a cursor: interrupting it and restarting loses nothing.

```
68 batches, 340,000 rows, 4 minutes, no lock contention observed
```

A single unbounded `update orders set buyer_name = customer_name` would have
held a lock on every row of a 340,000 row table for the duration, which is the
version that gets written when the batching feels like ceremony.

### Release 2, switch

Code writes both columns, reads the new one.

```ts
await db.order.update({
  where: { id },
  data: { buyerName: name, customerName: name },   // both, deliberately
})
```

Deployed. Both versions still work: old instances read and write
`customer_name`, new instances read `buyer_name` and keep `customer_name`
current for them.

The double write is the part that makes a rollback safe during this release.
If release 2 is reverted, the old code finds `customer_name` accurate.

### Release 3, stop writing the old column

Code writes only `buyer_name`.

Deployed after release 2 has been stable for a day. From here, a rollback to
release 1 would leave `customer_name` stale for rows written since, which is
recorded in the rollback plan for this release.

### Release 4, contract

```sql
alter table orders drop column customer_name;
```

Run after release 3 has been stable and nothing reads the old column.
Confirmed by searching the codebase and by checking that no query in the slow
query log references it.

Irreversible. Approved explicitly, with a verified backup taken beforehand.

## The rollback plans, which differ per release

```
Release 1   revert: drop the column. No data loss, nothing used it.
Release 1b  nothing to revert; the backfill is idempotent.
Release 2   revert the code. customer_name is accurate because of the double
            write. Safe.
Release 3   revert the code. customer_name is stale for rows written since
            this release. Recovery: re-run the backfill. Stated in the plan.
Release 4   no rollback. The column and its data are gone. This is why the
            backup is verified before, and why this release is separate and
            deliberately boring.
```

Writing five rollback plans instead of one is what surfaces that release 3 is
the point where reverting stops being free.

## What it cost

Four deployments instead of one, over five days. Roughly two hours of extra
work.

Against ninety seconds of total failure on the orders path, an impossible
rollback, and an incident review.

## The general rule

Any migration that removes or renames something the running code uses is a
minimum of two deployments, and usually four. The single migration version
works on a project with one instance and no traffic, which is where the habit
is formed and where the cost is invisible.
