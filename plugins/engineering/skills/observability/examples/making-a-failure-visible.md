# Example: the outage nobody saw

Three weeks after launch, a client asked why several customers had not
received their order confirmation emails.

## What the logs contained

```
2026-07-14T09:12:44.001Z info  Processing order
2026-07-14T09:12:44.310Z info  Order processed
2026-07-14T09:12:51.882Z info  Processing order
2026-07-14T09:12:52.140Z info  Order processed
```

Prose, no fields, no identifiers, no correlation. Given a customer's
complaint, there was no way to find their order in the log, and no way to tell
whether an email had been attempted.

The mail failure produced no line at all, because the send was wrapped in a
catch that did nothing.

## What the health endpoint contained

```ts
app.get("/health", (_, res) => res.send("ok"))
```

It returned 200 whether or not the database was reachable, which meant the
platform had never once removed a broken instance from rotation.

## What existed for alerts

Nothing. The first signal of any failure was a client email.

## The instrumentation, after

### Correlation at the edge

```ts
app.use((req, res, next) => {
  const requestId = req.header("x-request-id") ?? ulid()
  res.setHeader("x-request-id", requestId)
  req.log = logger.child({ requestId })
  next()
})
```

The identifier is returned in the response, so a customer support ticket that
quotes it maps directly to a trace.

### The order path, instrumented

```ts
req.log.info({ event: "order.created", orderId, userId, totalMinor, currency })

try {
  await sendConfirmation(order)
  req.log.info({ event: "order.confirmation.sent", orderId, provider: "mail" })
} catch (error) {
  req.log.error({ event: "order.confirmation.failed", orderId, error })
  await markDeliveryFailed(order.id)
}
```

Three changes. The failure is logged at error level, the delivery state is
recorded on the row so the application knows, and the order identifier makes
the line findable.

### Readiness that can fail

```ts
app.get("/health/live", (_, res) => res.status(200).end())

app.get("/health/ready", async (_, res) => {
  try {
    await db.raw("select 1")
    res.status(200).json({ status: "ready" })
  } catch {
    res.status(503).json({ status: "unavailable" })
  }
})

app.get("/version", (_, res) =>
  res.json({ commit: process.env.GIT_COMMIT, startedAt })
)
```

Readiness checks the database, which the service cannot work without. It does
not check the mail provider: a mail outage should degrade confirmations, not
remove every instance from rotation and take the whole site down.

That distinction is the one that turns a provider incident into a full outage
when it is decided wrongly.

### The metric that would have caught it

```
mail.delivery.failed, counter, by provider
```

Consumer: an alert.

```
Alert: order confirmation delivery failure rate above 5 percent over 15
       minutes
Response: docs/runbook.md, "Invitation and confirmation emails are not
       arriving"
Severity: notify during working hours; the orders still exist
```

### The alert rules, in full

```
| Alert | Condition | Response | Wakes someone |
|---|---|---|---|
| service unavailable | readiness failing on all instances for 2 min | runbook: service down | yes |
| error rate | 5xx above 2 percent over 5 min | runbook: elevated errors | yes |
| mail delivery | failure rate above 5 percent over 15 min | runbook: mail failing | no |
| job did not run | nightly job absent by 03:30 | runbook: job missed | no |
| certificate expiry | under 14 days | runbook: renew | no |
| disk | above 85 percent | runbook: disk | no |
```

Six alerts. Two wake someone. Four are working hours items. Nothing alerts on
CPU, because there was no answer to the question of what the response would
be.

## The verification, which is the part that gets skipped

```
Stopped the database in staging
  readiness returned 503 within 1s
  the platform removed the instance from rotation
  the alert fired after 2 minutes as configured
  the log line named the connection failure

Forced a handler exception
  it reached the error reporter with the requestId and the orderId
  grouped as one entry across 12 occurrences, not 12 notifications

Sent a request with a known identifier
  the identifier appeared in the edge log, the service log, the data layer
  log, and the response header

Broke the mail provider credential
  order.confirmation.failed appeared at error level
  the delivery state on the row was set to failed
  the alert fired at the 15 minute mark
  the runbook entry was followed and was correct

Grepped a day of staging logs for secrets
  no match on any redaction pattern
```

Five exercises. Before them, the setup was a configuration file that had never
been shown to work.

## What changed operationally

The next mail provider incident, six weeks later, was detected by the alert
seventeen minutes in. The runbook entry said what to check and what to do. The
affected orders were listed by one query against the delivery state, and the
confirmations were resent.

No customer reported it, because the response was faster than the complaint.
