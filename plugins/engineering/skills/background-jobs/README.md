# background-jobs

Designs and operates asynchronous work: what belongs out of the request,
message design, idempotency, retries with backoff and classification, dead
letter handling, ordering and concurrency, scheduled work, and the signals
that make a queue operable.

- Inputs: the work to move out of the request, the broker or scheduler
  available, the consistency requirements.
- Outputs: job design, retry policy, idempotency strategy, failure handling,
  queue observability.
- Depends on: engineering-core, backend-engineering.
- Lateral: reliability-testing, observability, database-design.
- Downstream: testing-quality, deployment-engineering, incident-response.

Assume every message is delivered more than once, arrives late, and one day
fails halfway. A handler that is not idempotent must not be retried, and a
dead letter queue without an owner is silent data loss.
