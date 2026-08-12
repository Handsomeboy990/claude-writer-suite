# Job design sheet

```
JOB
  name           <verb the work, not the technology>
  triggered by   <request, event, schedule, webhook>
  why async      <the reason it is not in the request>
  user visible   <what the user is told, and when the outcome appears>

MESSAGE
  payload        <identifiers, plus values that must not change>
  version        <shape version>
  size           <expected, and the maximum>
  contains       <no secret, no personal data: confirmed>
  compatibility  <readable by the previous release: yes, how>

IDEMPOTENCY
  mechanism      <natural key | processed table | guarded transition |
                  external idempotency key | naturally idempotent>
  enforced by    <database constraint, preferably>
  proven by      <the test that delivers the same message twice>

RETRY
  retryable      <which errors>
  permanent      <which errors, failed immediately without retry>
  backoff        <base, factor, jitter, maximum delay>
  max attempts   <n>, reached in test <yes>
  after max      <dead letter queue, and who owns it>

ORDERING
  needed         <yes | no>
  scope          <per key: which key>
  guarantee      <what the broker actually provides, verified>

CONCURRENCY
  workers        <limit>
  per dependency <limit, so one provider cannot consume the pool>
  mutual exclusion <where two jobs must not touch one entity, and how>

SCHEDULE, if scheduled
  expression     <schedule>, timezone <zone>
  daylight       <behaviour at the change>
  overlap        <skip | queue | concurrent>
  missed run     <detected how, caught up or abandoned>
  horizon        <where the last successful run is recorded durably>

FAILURE
  partial work   <resumable, or safely repeated from the start>
  side effects   <which are already sent when a later step fails>
  compensation   <what undoes them, or why nothing can>

OBSERVABILITY
  metrics        depth, oldest message age, duration distribution, failure
                 rate, retry rate, dead letter count
  alerts         <condition, owner>
  correlation    <identifier flowing from the request into the job logs>

TESTS
  duplicate delivery
  out of order delivery, if ordering is claimed
  failure at each step of the handler
  poison message
  deployment during processing
  the maximum retry chain, reached
```

## The transactional enqueue problem

Enqueueing inside a database transaction that may roll back produces a message
for work that never happened. Enqueueing after the commit can lose the message
if the process dies in between.

```
outbox        write the message to a table in the same transaction, and a
              relay publishes it. Correct, and the usual answer.
transactional the broker participates in the transaction. Rare, and heavy.
  queue
accept loss   only when the work is genuinely optional, stated in writing
```

The symptom of getting this wrong is a mail about an order that does not
exist, and it appears months later under load.

## Deployment interaction

```
a worker may start before or after the producer: both message versions exist
a long job may be interrupted by a restart: it must resume or repeat safely
a schema change must be readable by the running workers, or workers stop first
draining: does the platform wait for in flight jobs, and for how long
```
