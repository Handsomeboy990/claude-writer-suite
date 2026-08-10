---
name: observability
description: Makes a running system explain itself: structured correlated logs, health endpoints, the few metrics that matter, error reporting, alerts that fire on user impact, and a redaction policy that keeps secrets and personal data out. Required before the first production deployment.
license: MIT
metadata:
  category: devops-skills
  version: 1.0.0
  depends_on: [engineering-core, devops-core, backend-engineering]
  outputs: [logging-policy, health-endpoints, metric-set, alert-rules, redaction-rules]
---

# Observability

A system without observability does not have fewer failures. It has failures
reported by users, diagnosed by guessing.

This is a precondition of the first production deployment, not a follow up.

## 1. The three questions

Everything here serves one of three questions. Anything serving none is
removed.

```
1  Is it working right now
2  What is it doing
3  Why did that request fail
```

Health endpoints answer 1. Metrics answer 2. Logs and traces answer 3.

## 2. Logs

```
Structured    fields, not interpolated prose; one event per line
Correlated    a request identifier crossing every layer and every service
Levelled      error, warn, info, debug, used consistently
Contextual    the identifiers needed to find the affected record
Redacted      by the logger, not by the call site
Bounded       no full request bodies, no unbounded payload dumps
```

### Levels, used consistently

| Level | Meaning | Example |
|---|---|---|
| error | unexpected, someone should look | database unreachable, unhandled failure |
| warn | expected failure worth seeing | payment declined, rate limit hit, retry exhausted |
| info | a state change worth reconstructing | order created, user signed in, job completed |
| debug | detail for investigation | off in production |

The common defect is logging expected business failures at error level. It
trains the team to ignore errors, which is the state in which a real one is
missed.

### The test for a log line

During an incident, does this line change what the operator does next? If not,
it is noise, and noise is what makes the useful lines unfindable.

### Correlation

One identifier, generated at the edge, attached to every log line, propagated
to every downstream call, and returned in the response so a user report can be
tied to a trace.

Without it, a failure in a four layer request is four unrelated log lines in
four places.

## 3. Health endpoints

Two, with different purposes.

```
liveness   is the process alive and not deadlocked
           cheap, no dependencies, used to decide whether to restart

readiness  can this instance serve traffic right now
           checks the dependencies it cannot serve without, used to decide
           whether to route
```

Rules:

- Readiness checks what the instance genuinely needs: usually the database.
- Readiness does not check optional dependencies. A payment provider outage
  should degrade checkout, not remove every instance from rotation.
- Both have timeouts shorter than the platform's check interval.
- Neither is authenticated in a way that stops the platform from calling it,
  and neither reveals internal detail to the public.
- A version endpoint reports the deployed commit, which is what makes
  `production-verification` able to confirm what is actually running.

## 4. Metrics

Few, and each with a named consumer. A dashboard nobody reads is not
observability.

```
Golden signals   request rate, error rate, latency distribution, saturation
Domain           the one or two numbers that say the product works:
                 orders per hour, sign ups today, jobs pending
Dependencies     external call latency and failure rate
Resources        connections in use against the limit, queue depth, disk
```

Latency is reported as a distribution, not a mean. A mean of 200ms with a 99th
percentile of 8 seconds describes a system where one user in a hundred is
having a bad time, and the mean hides it.

## 5. Errors

Unexpected failures reach a place a person looks, with enough context to
reproduce: the correlation identifier, the affected record, the version, the
environment, and the stack.

Never in an error report: secrets, tokens, full request bodies, personal data
beyond the identifier needed to find the record.

Grouping matters. A thousand instances of one defect should be one entry with
a count, not a thousand notifications, because the second is indistinguishable
from noise.

## 6. Alerts

An alert fires when a human must act. Everything else is a dashboard.

```
Alert on      user visible impact: error rate above the threshold, the health
              check failing, a queue that stops draining, a scheduled job that
              did not run, certificate expiry, disk approaching full
Do not alert  on CPU alone, on a single failed request, on anything that
              resolves itself, on a metric nobody has a response for
```

Every alert has a written response. An alert whose runbook entry does not
exist will be silenced the third time it fires at night.

## 7. Redaction

Applied at the logger, once, not at each call site. Call site redaction is
forgotten exactly where it matters.

```
Never logged  passwords, tokens, keys, session identifiers, card numbers,
              full request bodies, full response bodies, authorization headers
Redacted      email addresses and names, unless the log's purpose requires
              them and the retention is stated
Logged        opaque identifiers, which allow finding the record without
              carrying the data
```

Log retention is a decision with a privacy consequence, and it is stated in
the architecture rather than inherited from a platform default.

## 8. Protocol

1. Implement the correlation identifier at the edge and propagate it.
2. Configure structured logging with redaction at the logger.
3. Add liveness, readiness and version endpoints.
4. Define the metric set, section 4, each with a consumer.
5. Wire error reporting with grouping.
6. Define alerts, section 6, each with a written response.
7. Set retention deliberately.
8. Verify: break something on purpose and confirm it is visible.

## 9. Verification

Observability is tested like everything else.

```
Stop the database        readiness fails, the platform stops routing, an
                         alert fires, the log says why
Force a handler error    it reaches the error reporter with the correlation
                         identifier
Send a request           its identifier appears in every layer's logs and in
                         the response
Grep for a secret        the logs contain none
Trigger an alert         the runbook entry for it exists and is correct
```

An observability setup that has never been exercised is a set of
configuration files.

## 10. Auto-critique

Score from 0 to 5: logs structured and correlated, levels used consistently,
readiness checking only what is required, metrics few with named consumers,
latency as a distribution, errors grouped with context, alerts tied to user
impact and to a runbook, redaction at the logger, the whole thing verified by
breaking something.

Threshold: no axis below 3, average at least 4. A secret in the logs, or an
alert with no written response, is an automatic failure.

## 11. Interfaces

- Upstream: `devops-core`, `backend-engineering`,
  `architecture-proposal` section 9.
- Lateral: `deployment-engineering` for health gating,
  `security-audit` point 18 for logging privacy.
- Downstream: `production-verification`, `backup-recovery`,
  `client-handover` for the runbook.
