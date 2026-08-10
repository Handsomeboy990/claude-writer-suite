# Logging policy

## Event shape

One event per line, structured, with a stable event name.

```json
{
  "time": "2026-08-11T14:22:03.412Z",
  "level": "warn",
  "event": "payment.declined",
  "requestId": "01J8XKQ2F3",
  "userId": "usr_01H8XK",
  "orderId": "ord_01H8YM",
  "declineCode": "insufficient_funds",
  "provider": "stripe",
  "durationMs": 812
}
```

Rules:

- `event` is a stable dotted name. It is what alerts and dashboards key on, so
  it never changes casually.
- `requestId` is present on every line of a request, including in downstream
  services.
- Identifiers are opaque. They allow finding the record without carrying its
  contents.
- No message prose where a field will do. `"Payment for order ord_01H8YM was
  declined"` cannot be aggregated; the object above can.

## Level assignment

| Situation | Level | Why |
|---|---|---|
| database unreachable | error | someone must act |
| unhandled exception | error | a defect |
| external provider timeout after retries | error | user impact, needs a look |
| payment declined by the issuer | warn | expected, worth seeing in aggregate |
| rate limit triggered | warn | expected, and a spike means something |
| validation rejected a request | info or nothing | ordinary, high volume |
| order created | info | reconstructable state change |
| user signed in | info | |
| job started and finished, with counts | info | |
| query parameters during investigation | debug | off in production |

The error level is reserved for things a person should look at. Once expected
failures are logged as errors, the error count stops meaning anything.

## Correlation

```
Generated  at the edge, per request, if the client did not supply one
Attached   to the logger for the request's lifetime, not passed by hand
Propagated as a header on every outbound call
Returned   in the response header, so a user report maps to a trace
Stored     on rows created by the request, where an audit trail exists
```

The last line is cheap and disproportionately useful: given a suspicious
record, its `requestId` recovers the full story of how it came to exist.

## Redaction

Applied once, in the logger configuration.

```
Removed entirely
  password, token, accessToken, refreshToken, secret, apiKey, authorization,
  cookie, set-cookie, cardNumber, cvv, iban, ssn, privateKey

Truncated
  any string field beyond a length limit
  any array beyond a length limit

Never logged whole
  request bodies
  response bodies
  headers
```

Call site redaction is forbidden as the primary mechanism. It is forgotten in
the handler written under time pressure, which is the one that logs the
authorization header.

## Personal data

```
Identifiers   logged: userId, orderId, teamId
Contents      not logged by default: email, name, address, phone
Exception     when the log's purpose requires it, with the retention stated
              in the architecture and the field named in the policy
```

An email address in a log is personal data with the log's retention, and that
retention is usually longer than anyone intended.

## Volume

```
Per request   a handful of lines, not one per function call
Loops         never one line per iteration; log the summary with counts
Hot paths     info level only for state changes, not for progress
Sampling      where volume demands it, sample debug and info, never error
```

A log that costs more than the application it observes is a log nobody keeps.

## Retention

Stated deliberately, per level and per environment.

```
| Environment | error | warn | info | debug |
|---|---|---|---|---|
| production | 90d | 30d | 14d | off |
| staging | 14d | 14d | 7d | 3d |
| development | 3d | 3d | 3d | 3d |
```

Retention is a privacy decision as much as a cost one. Personal data in logs
inherits these numbers.

## The removal test

Run periodically over the log volume: which events are most frequent, and
which of them has ever changed an operator's action?

Events that fail the test are removed. This is the only mechanism that keeps a
log useful over years; without it, every investigation adds lines and nothing
ever removes them.
