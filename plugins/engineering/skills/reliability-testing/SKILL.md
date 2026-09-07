---
name: reliability-testing
description: Verifies what the system does when its dependencies fail: unavailable, slow, timing out, returning partial or malformed data, duplicating or reordering messages. Checks the four properties that matter, failing honestly, telling the truth to the user, leaving state consistent and allowing recovery. Use when anything the product depends on can fail, which is always.
license: MIT
metadata:
  category: dev-skills
  version: 1.0.0
  depends_on: [engineering-core, quality-engineering]
  outputs: [dependency-inventory, failure-matrix-results, recovery-findings, consistency-findings]
---

# Reliability Testing

Every product works when everything works. This skill finds out what happens
the rest of the time, before a customer does.

The most expensive defects in this discipline are not crashes. They are the
operations that report success after failing, and the failures that leave
money, records or files in a state nobody designed.

## 1. Dependency inventory

List everything the product needs and cannot control:

```
database, and each replica
cache
queue, broker, scheduler
object storage
mail provider
payment provider
identity provider
search service
any other external API
webhooks received, and their sender
the network between any two of these
the browser: offline, slow, interrupted
```

For each one, record what the product does with it, and whether that call is
on a user facing path or in a background job. Both matter, differently: one
produces a bad experience, the other produces bad data silently.

## 2. Failure modes

Nine modes per dependency. The expanded catalogue is in
`resources/failure-modes.md`.

| Mode | Question |
|---|---|
| unavailable | connection refused, resolution failure |
| slow | responds, far past the expected time |
| timeout | never responds within the client's limit |
| error | returns a declared error status |
| malformed | returns a body the client cannot parse |
| partial | returns fewer fields, or a truncated list |
| wrong | returns a valid shape with impossible content |
| duplicate | delivers the same message or callback twice |
| out of order | delivers messages in an order the code did not expect |

Not every mode applies to every dependency. The ones that do not are marked
not applicable with a reason, which is how the sheet stays honest.

## 3. The four properties

For every injected failure, the system must satisfy all four:

```
1  fails honestly      the operation reports failure when it failed
2  communicates        the user is told what happened and what to do next
3  stays consistent    no half written record, no charge without an order,
                       no file without a row, no row without a file
4  recovers            retrying works, and retrying twice does not duplicate
```

Property 1 is the one that fails most often, and property 3 is the one that
costs most when it does.

## 4. Injection methods

Choose the least invasive method that produces the mode. Detail in
`resources/injection-methods.md`.

```
network stubs      intercept at the network boundary, the default choice
proxy              delay, drop or corrupt responses without touching code
client limits      shorten a timeout to make it fire deterministically
browser conditions offline, slow profile, request blocking
service control    stop a dependency container in an isolated environment
data conditions    an empty table, a missing row, a stale record
```

Never inject by editing production code paths with a test flag that ships.
Never inject anything into a shared or production environment without explicit
authorisation from the testing contract.

## 5. Recovery protocol

For each critical operation:

```
1  start the operation from a known state
2  inject one failure, at one point, deliberately chosen
3  observe: what the user sees, what the logs say, what the data holds
4  remove the failure
5  retry the operation the way a user would
6  verify the final state: exactly one effect, correct content
7  repeat the whole sequence with the failure injected at a different point
```

One failure per run, always. Step 7 reruns the operation with the injection
moved, and that is what separates this from a smoke test: failing before the
write, during the write and after the write produces three different defects.
Injecting them together produces one result nobody can attribute.

## 6. The consistency questions

Ask these wherever two things must change together:

```
the provider charged and the order was not created
the row was written and the file was not stored
the file was stored and the row was not written
the mail was sent and the state says it was not
the job ran twice because the first run's acknowledgement was lost
the webhook arrived before the record it refers to
the queue redelivered a message whose effect had already been applied
a background job read a record that a transaction later rolled back
```

Each one is either impossible by design, and that design is shown, or it is a
finding.

## 7. Timeouts, retries and backoff

```
every outbound call has a timeout, and it is shorter than the caller's
a retry only happens on an operation that is safe to repeat
retried writes carry an idempotency key, or are proven naturally idempotent
retries have a limit and a backoff, and the limit is reached in a test
a failed retry chain surfaces as a real failure, not as silence
a slow dependency does not exhaust the connection pool for everything else
```

## 8. Startup, shutdown, degradation

```
the application starts with a dependency already down: refuses clearly, or
  starts degraded and says which features are unavailable
a dependency dies while the application runs, and comes back
in flight work during shutdown: completed, or safely abandoned
health checks report unhealthy when the product cannot serve, not merely when
  the process is alive
degraded mode, if it exists, is tested rather than assumed
```

## 9. Boundaries

This is not load testing, and it is not chaos engineering in production. Both
are legitimate and both are scheduled work with their own authorisation.
`performance-engineering` owns behaviour under volume; this skill owns
behaviour under failure, in an environment the campaign is allowed to break.

## 10. Prohibitions

- Never inject a failure in production or a shared environment without written
  authorisation.
- Never leave an injection in place after the session.
- Never report `handled` because no exception appeared; check the data.
- Never accept a retry that produces two effects.
- Never treat a silent failure as acceptable because the user could refresh.
- Never leave a test double in the shipped code path.

## 11. Protocol

1. Build the dependency inventory and mark the user facing paths.
2. Choose the critical operations, from the testing contract.
3. Select the applicable failure modes per dependency.
4. Choose the least invasive injection method for each.
5. Run the recovery protocol once per injection point, one failure per run.
6. Check the four properties every time, especially consistency.
7. Ask the consistency questions of section 6 wherever two writes coexist.
8. Verify timeouts, retry limits and backoff by reaching them.
9. Remove every injection and confirm the system is back to normal.
10. Turn the reproducible findings into permanent tests with stubbed failures.

## 12. Auto-critique

Score from 0 to 5: inventory completeness, mode coverage per dependency,
injection points varied across runs, the four properties checked
including data consistency, retry and idempotency verified, environment
restored, findings reproducible as automated tests.

Threshold: no axis below 3, average at least 4. A session where every run
injected at the same point in the operation covers one third of what the
discipline exists for and is rerun.

## 13. Interfaces

- Upstream: `quality-engineering` for the contract and the critical
  operations, `architecture-design` for what was supposed to be resilient.
- Lateral: `bug-hunting` for the interface side of the same failures,
  `observability` for what the system reports about itself, `devops-core` for
  environment level failure.
- Downstream: `backend-engineering` for fixes, `testing-quality` for the
  permanent stubbed failure tests, `test-reporting` for the findings,
  `production-verification` for what must be checked after deployment.
