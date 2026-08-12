# Example: implementing erasure, and discovering the copies

The request: implement account deletion, described in the ticket as `delete
the user row and their documents`.

## The inventory found fourteen places

```
1  users, memberships, sessions, api_tokens              primary database
2  documents and their attachments                        object storage
3  generated exports, kept 90 days                        object storage
4  the search index, holding document titles and the
   author's name                                          search service
5  the cache, holding the user object for 15 minutes      shared cache
6  queued jobs referencing the user                       queue
7  invitation records in other organisations              primary database
8  audit log entries naming the actor                     primary database
9  the mail provider's contact list                       third party
10 error tracking, with the user id attached to events    third party
11 product analytics, keyed by user id                    third party
12 the support tool, holding conversation history         third party
13 the data warehouse, refreshed nightly                  internal
14 backups                                                internal
```

The ticket described two of the fourteen. The gap is normal and it is exactly
what the inventory exists to find.

## The decisions, each one deliberate

```
1  deleted immediately
2  deleted immediately, objects and rows
3  deleted immediately, since they contain personal data by definition
4  index entries removed synchronously, verified by a query afterwards
5  cache keys invalidated, and the key scheme reviewed so that no stale copy
   can outlive the deletion
6  queued jobs referencing the user are made tolerant of a missing user
   rather than deleted from the queue, because deleting messages from a queue
   selectively is fragile. Each handler now exits cleanly when the user is
   gone, and that behaviour is tested.
7  invitations to other organisations are deleted. Invitations the user sent
   keep the organisation but lose the personal reference.
8  audit entries are retained, with the actor replaced by a stable
   pseudonymous identifier. Reason: security and fraud investigation. This is
   a retention decision and it is stated in the privacy notice.
9  contact deleted through the provider API, with the failure surfaced rather
   than swallowed
10 user context removed; events themselves expire at 90 days
11 deletion requested through the provider's API, which is asynchronous. The
   request identifier is recorded so completion can be verified.
12 conversations retained 3 years for dispute resolution, then deleted. Stated
   in the notice.
13 nightly job removes the user's rows and rebuilds the affected aggregates
14 backups expire at 90 days. Not modified. Stated in the notice, with the
   date by which the data is gone from every backup.
```

## What the implementation looks like

```
deletion is a job, not a request handler: it touches fourteen systems and
  some of them are slow or asynchronous

the job is idempotent and resumable: each step records its completion, so a
  failure at step 9 does not repeat steps 1 to 8

failures are visible: a provider deletion that fails produces an alert, not a
  log line, because an unfinished erasure is an obligation not met

the account is marked deleted and made inaccessible immediately, before the
  job completes, so the user experience matches their expectation
```

## The test that proves it

```
1  create an account, exercise the product: documents, uploads, an export,
   an invitation, a support conversation, several analytics events
2  wait for the nightly warehouse refresh
3  request deletion
4  wait for the job to complete
5  run the subject access export procedure on the same identifier

expected result: the export returns only the deliberately retained items,
  namely the pseudonymised audit entries and the support conversations, with
  their retention dates
6  verify directly in each of the fourteen stores
7  verify the search index returns nothing for the email
8  verify no cache entry survives
```

This test runs monthly in a staging environment with a seeded account,
because the failure mode is silent: a new feature adds a fifteenth copy and
nothing complains.

## What was fixed along the way

```
the search index held the author's full name and was rebuilt weekly, so a
  deleted user remained searchable for up to seven days
analytics used the email address as the identifier, which meant deletion in
  the primary database left the email in the analytics provider forever
error tracking attached the whole user object, including the address
two exports had been generated with a filename containing the user's email
```

None of the four were in the ticket. All four were found by writing the
inventory before writing the code, which took an afternoon and changed the
scope of the work from two hours to three days. Three days that were the
actual size of the obligation.
