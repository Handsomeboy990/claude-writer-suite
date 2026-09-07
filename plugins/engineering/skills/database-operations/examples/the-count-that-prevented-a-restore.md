# Example: three operations, one near miss

Support request: "archive the orders from the test import last March, they are
cluttering the dashboard".

## Operation 1, the statement as first written

```sql
update orders set status = 'archived' where source = 'import';
```

Reads correctly. Matches the request. It was not run.

## The count first

```sql
select count(*) from orders where source = 'import';
-- 41,208
```

The March test import was around 300 orders. 41,208 is two years of a
legitimate integration that also writes `source = 'import'`, discovered
because the number did not match the expectation.

Running the update would have archived every order from a live integration.
Recovery would have been a restore, losing everything written since the last
backup, to fix a cosmetic complaint about a dashboard.

## The corrected statement

```sql
select count(*) from orders
where source = 'import'
  and created_at >= '2025-03-01' and created_at < '2025-04-01'
  and customer_email like '%@test.example';
-- 312
```

312, which matches the expectation. Three predicates instead of one, and the
third is what distinguishes the test import from the real one.

## Operation 2, executed with the wrapper

```sql
begin;

update orders set status = 'archived'
where source = 'import'
  and created_at >= '2025-03-01' and created_at < '2025-04-01'
  and customer_email like '%@test.example';
-- UPDATE 312

select status, count(*) from orders group by status;
--  archived | 312
--  paid     | 338,204
--  pending  | 1,491

commit;
```

The count inside the transaction matched the count from before. The
distribution was inspected. Only then, commit.

Had the number come back as 41,208, `rollback` would have cost nothing.

## Operation 3, the same week, a genuine batch

Requirement: backfill `orders.buyer_name` from `customer_name`, 340,000 rows.

The statement that was not written:

```sql
update orders set buyer_name = customer_name where buyer_name is null;
```

One statement, 340,000 row locks held for its duration, replication lag, and
an application that appears to hang.

What was written:

```sql
-- run repeatedly until it reports 0
update orders
set buyer_name = customer_name
where buyer_name is null
  and id in (
    select id from orders where buyer_name is null limit 5000
  );
```

```bash
while true; do
  affected=$(psql "$DATABASE_URL" -qtA -c "$BACKFILL")
  echo "$(date +%T) batch: $affected"
  [ "$affected" = "UPDATE 0" ] && break
  sleep 1
done
```

```
14:02:11 batch: UPDATE 5000
14:02:14 batch: UPDATE 5000
...
14:06:03 batch: UPDATE 4208
14:06:06 batch: UPDATE 0
```

Four minutes, 68 batches, one second of pause between each. No lock
contention, no replication lag, and it could have been interrupted at any
point without leaving anything inconsistent.

## The operation record

```
What:        archive 312 test import orders from March 2025
Environment: production, verified: select current_database() -> app_prod
Class:       high, data change, partial recovery only
Backup:      nightly, taken 03:00, verified present in the backup listing
Approved by: the operations lead, in writing, quoting the row count
Executed:    2026-08-11 14:22, inside a transaction, count confirmed before
             commit
Verified:    312 archived, no other status changed, the dashboard reflects it
Recorded:    here
```

## What the discipline cost

The count query: four seconds. The transaction wrapper: one extra line and one
inspection query.

Against archiving 41,208 live orders and a restore that would have lost a
day's writes to fix a dashboard complaint.

The predicate was not obviously wrong. `source = 'import'` is exactly what
somebody would write, and it reads as correct. The count is what made the
error visible, and the count is the only step that would have.
