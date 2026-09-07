# Blast radius grid

Classify before acting. The class determines what is required, not how the
operation feels.

## Classes

```
none          reversible, no user visible effect
low           one deployment affected, a revert restores everything
medium        users affected during a window, fully recoverable
high          data changes, only partial recovery
irreversible  deleted data, sent mail, moved money, dropped column
```

## Classified operations

| Operation | Class | Required |
|---|---|---|
| deploy a code change to staging | low | proceed, report |
| deploy a code change to production | medium | announce, verify after |
| additive migration, new nullable column | low | proceed |
| additive migration, new NOT NULL with default on a large table | medium | check lock behaviour first |
| backfill a column in batches | medium | resumable, bounded |
| drop a column | irreversible | approval, backup verified |
| drop a table | irreversible | approval, backup verified |
| rename a column in one migration | irreversible in effect | refuse, use expand and contract |
| truncate a table | irreversible | approval, backup verified |
| bulk update without a WHERE clause | irreversible | never; write the WHERE and count first |
| delete rows matching a filter | high to irreversible | count first, approval, backup |
| restore a backup over a live database | irreversible | approval, and a backup of the current state first |
| rotate a credential in use | medium | know what restarts, do it in order |
| revoke a credential | high | confirm nothing still uses it |
| change DNS | medium to high | know the TTL, know the rollback |
| scale to zero | medium | know what wakes it |
| delete a storage bucket | irreversible | approval, and there is rarely a reason |
| clear a cache | low | proceed, expect a latency spike |
| flush a queue | high | the messages are gone; count and inspect first |
| replay a webhook batch | high | idempotency must be proven first |
| send a batch email | irreversible | approval, and send to yourself first |
| disable a feature flag | low | proceed |
| change a rate limit | medium | know what it protects |
| resize a database instance | medium | know the downtime, announce it |
| enable a new index concurrently | low | proceed |
| enable a new index with a lock | high | announce, off peak, know the duration |

## The two lines that matter most

**`bulk update without a WHERE clause`.** Never executed. The procedure is:
write the `SELECT COUNT(*)` with the intended `WHERE`, read the number, decide
whether it is the number you expected, then convert it to the `UPDATE`.

An update that reports `1,482,203 rows affected` when you expected forty is a
restore, and restores lose everything since the backup.

**`rename a column in one migration`.** Classified irreversible in effect
because the running application breaks during the deploy window. Replaced by
expand and contract: add, backfill, switch reads, switch writes, drop, across
separate deploys.

## Target verification

Required at `high` and above. Read the target back; never trust the shell.

```
Wrong
  psql $DATABASE_URL -c "truncate sessions"

Right
  psql $DATABASE_URL -c "select current_database(), inet_server_addr()"
  -> confirm it is the database you intend
  psql $DATABASE_URL -c "select count(*) from sessions"
  -> confirm the count is what you expect
  then, and only then, the destructive statement
```

The most common serious operational incident is the correct command against
the wrong environment. Two read only queries prevent it.

## Recording

Every operation at `medium` and above leaves a record:

```
What:        the operation, in one sentence
Environment: named, and how it was verified
Class:       from this grid
Backup:      taken at <time>, verified by <how>
Approved by: <who>, quoting the approval
Executed:    <time>, output captured
Verified:    the intended effect, and the check for the unintended one
```

Seven lines. During an incident review, this is the difference between
reconstructing what happened and guessing.
