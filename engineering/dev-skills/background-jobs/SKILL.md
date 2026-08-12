---
name: background-jobs
description: Designs and operates asynchronous work: what belongs out of the request, queue and scheduler selection, job payloads and idempotency, retries with backoff, dead letter handling, ordering and concurrency limits, scheduled work that must not overlap or silently skip, and the visibility that makes a queue operable. Use for any queue, worker, cron, webhook consumer or long running operation.
license: MIT
metadata:
  category: dev-skills
  version: 1.0.0
  depends_on: [engineering-core, backend-engineering]
  outputs: [job-design, retry-policy, idempotency-strategy, failure-handling, queue-observability]
---

# Background Jobs

Moving work out of the request is easy. Making it correct when it runs twice,
runs late, runs out of order or does not run at all is the actual engineering.

Assume every job will be delivered more than once, will be delayed, and will
one day fail halfway. Design for that, and the normal case takes care of
itself.

## 1. What belongs in the background

```
yes   work whose result the user does not need in this response
yes   work that calls a system we do not control
yes   work whose duration is unbounded or data dependent
yes   work that must survive a client disconnect
no    work whose result the user is about to be shown
no    work that must be part of the same transaction as the request
no    work whose failure must fail the user's operation
```

The last line is the common design error: moving a mandatory step into a
background job so that the endpoint returns quickly, then reporting success
for an operation that has not happened yet.

## 2. Payloads

```
send identifiers, not entities: the worker reads the current state
send the values that must not change: an amount agreed at that moment
never send secrets or personal data through a queue that is retained or logged
version the payload shape, because a queue holds messages across deployments
keep messages small: large payloads belong in storage, referenced by key
a message must be interpretable by the previous release and the next one
```

That last rule is why deployments break queues: a worker restarts before the
producer, or after, and both orders happen.

## 3. Idempotency

Every handler is written so that running it twice on the same message produces
one effect.

```
a natural key on the effect: one row per (order, kind), enforced by the
  database rather than by a check
a processed-message table when there is no natural key
an idempotency key passed to any external call that supports one
a state transition guarded by a condition, so the second run changes nothing
an operation that is naturally idempotent: set a value, not increment it
```

Deduplication offered by a broker is a best effort optimisation, never the
correctness mechanism.

## 4. Retries

```
retry only what can be retried safely, which means idempotent
exponential backoff with jitter, never a fixed interval across many workers
a maximum attempt count, reached and observed in a test
distinguish transient from permanent: a validation failure must not be
  retried twenty times
a retry budget per dependency, so one failing provider does not consume the
  workers
the final failure is visible, not silent
```

## 5. Failure

```
dead letter queue, with the message, the error and the attempt history
an owner, and an alert when it is not empty
a replay path that is safe to run after the cause is fixed
poison message protection: one bad message must not block a partition forever
partial failure inside a job: either resumable, or the whole job is idempotent
  and re-runs from the start
```

A dead letter queue nobody watches is a silent data loss mechanism with good
intentions.

## 6. Ordering and concurrency

```
state whether the work needs ordering at all: most does not
where it does, order per key, not globally, and say what the key is
concurrency limits per queue and per external dependency
a lock or a unique constraint where two jobs must not act on one entity
long jobs chunked, so a deploy or a restart does not lose an hour of work
```

## 7. Scheduled work

```
a schedule with a stated timezone, and behaviour across daylight changes
overlap policy: skip, queue, or run concurrently, decided rather than default
a missed run is detected, because a scheduler that stops silently is common
a catch up policy: does a missed run execute late, or is it abandoned
the job is idempotent across the same period, since a manual re-run will
  happen
horizon: a job that processes since the last run needs the last run recorded
  durably, not in memory
```

## 8. Visibility

```
queue depth, per queue, over time
age of the oldest message, which matters more than the depth
processing duration distribution, not the average
failure rate and retry rate, per job type
dead letter count, with an alert at one
throughput against arrival rate, so saturation is visible before it is total
a correlation identifier flowing from the request into the job and its logs
```

## 9. Prohibitions

- Never report success to a user for work a background job has not done.
- Never enqueue inside a transaction that may roll back, unless the queue is
  transactional or an outbox is used.
- Never retry a non idempotent handler.
- Never let a job read a record it assumes exists without handling absence.
- Never put a secret or personal data in a message that is retained.
- Never leave a dead letter queue without an owner and an alert.
- Never rely on message ordering that the broker does not guarantee.

## 10. Protocol

1. Decide whether the work truly belongs out of the request.
2. Design the message: identifiers, frozen values, version, size.
3. Make the handler idempotent, by a key the database enforces where possible.
4. Decide the retry policy, the classification of errors and the maximum.
5. Decide the failure destination, its owner, its alert and its replay path.
6. Decide ordering and concurrency, per key rather than globally.
7. For scheduled work, decide timezone, overlap, catch up and missed run
   detection.
8. Handle the enqueue and commit ordering, with an outbox where correctness
   demands it.
9. Instrument depth, age, duration, failures and the correlation identifier.
10. Test: duplicate delivery, out of order, failure mid job, poison message,
    and a deployment during processing.

## 11. Auto-critique

Score from 0 to 5: correct placement of the work, message design, idempotency
enforced rather than assumed, retry policy with classification, dead letter
ownership, ordering and concurrency decided, scheduled work fully specified,
observability, tests for duplicate and mid-job failure.

Threshold: no axis below 3, average at least 4. A handler that is not
idempotent and is retried scores 0, whatever else is right.

## 12. Interfaces

- Upstream: `architecture-design` for the boundary, `backend-engineering` for
  the handlers, `database-design` for the outbox and the idempotency keys.
- Lateral: `reliability-testing` for redelivery and mid-job failure,
  `observability` for the signals, `caching-strategy` when a job warms a cache.
- Downstream: `testing-quality` for the duplicate delivery tests,
  `devops-core` and `deployment-engineering` for worker rollout,
  `incident-response` when a queue backs up.
