# Example: a dependency outage drill on a document product

Environment: an isolated stack the campaign owns, all dependencies in
containers, seeded data. Contract permits stopping services here and forbids
any injection in staging or production.

## Inventory

```
postgres        every request
redis           sessions and a cache of the document list
object storage  every upload and download
mail provider   invitations and export notifications
search service  the search page only
queue           exports and thumbnail generation
```

## Drill 1, redis stopped

```
inject       stop the redis container
expected     sessions fail, or degrade to the database
observed     every request returns 500. The error page has no styling because
             the asset manifest is also cached in redis.
properties   1 ok  2 FAIL  3 ok  4 ok
finding      REL-01, High. A cache outage is a total outage, and the failure
             page itself depends on the cache.
fix          sessions moved to a store with a database fallback, manifest read
             from disk. Retested: the product runs slower and stays up.
```

The valuable part was not that redis matters. It was that the error page could
not render during the very outage it exists for.

## Drill 2, object storage unavailable during upload

```
inject       block the storage endpoint at the network boundary
expected     upload fails, nothing recorded, the user is told
observed     the document row is created, then the upload fails. The interface
             shows the document in the list. Opening it shows a broken
             preview and a 404 on download.
properties   1 FAIL  2 FAIL  3 FAIL  4 ok
finding      REL-02, Critical. A record exists with no file, permanently, and
             the interface presents it as a normal document.
cause        the row is written before the upload, and no compensation exists.
fix          upload first, record second, plus a cleanup job for orphaned
             uploads. Permanent test added with a stubbed storage failure.
```

## Drill 3, mail provider timeout during invitation

```
inject       stub the provider to never respond, client timeout 5s
expected     the invitation exists, the mail is queued and retried, the user
             is told the invitation was created and the mail is pending
observed     the request hangs for 5 seconds, then returns a 500. The
             invitation was already committed. The user sees "Something went
             wrong", tries again, and creates a duplicate invitation.
properties   1 ok  2 FAIL  3 FAIL  4 FAIL
finding      REL-03, High. Mail is sent inside the request path, and the
             failure of a notification destroys the outcome of the operation.
fix          the invitation is committed, the mail is enqueued, the response
             says what happened. Retry is idempotent on the address.
```

## Drill 4, queue redelivery of an export job

```
inject       acknowledge suppressed, message redelivered
expected     one export file, one notification mail
observed     two files, two mails, and the second file overwrote the first
             while a customer was downloading it
properties   1 ok  2 ok  3 FAIL  4 ok
finding      REL-04, Medium. No idempotency on the job handler.
fix          job keyed by export id, handler checks completion first, file
             written to a new key and swapped atomically.
```

## Drill 5, postgres restarted mid transaction

```
inject       restart the container during a multi step save
expected     the transaction rolls back, the user is told, nothing partial
observed     correct. Rollback clean, error message accurate, retry worked.
properties   1 ok  2 ok  3 ok  4 ok
finding      none. Recorded as verified, because a drill that only records
             failures cannot say what is trustworthy.
```

## Drill 6, search service down

```
inject       stop the search container
expected     the search page degrades, the rest of the product works
observed     the search page shows an error and offers no alternative. Every
             other page works. The global header search box silently returns
             nothing rather than reporting the outage.
properties   1 FAIL on the header  2 FAIL  3 ok  4 ok
finding      REL-05, Low. Degradation exists but is not communicated, and an
             empty result set is indistinguishable from an outage.
```

## Result

```
6 drills, 5 findings, 1 clean

Critical  1  record without a file, presented as valid
High      2  cache outage becomes total outage, notification failure destroys
             the operation
Medium    1  duplicate export on redelivery
Low       1  silent search degradation

Verified  transaction rollback under database restart

All five findings became permanent tests with stubbed failures. Three of them
run in CI in under two seconds each, which is the argument for doing this work
once rather than discovering it during an incident.
```

## Restoration

Every container was restarted, every stub removed, and a normal end to end run
was executed afterwards to confirm the environment behaves as it did before
the drill. That line is in the report, because a reliability session that
leaves an injection in place produces a false failure in someone else's work
tomorrow.
