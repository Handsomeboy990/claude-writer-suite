# Error contract

One shape for the whole API. The shape below is an example; the real one is
whatever the project already returns, discovered by reading two existing
handlers.

## Shape

```json
{
  "error": "invitation_already_pending",
  "message": "An invitation is already pending for this address.",
  "fields": { "email": "Already invited" }
}
```

- `error` is a stable machine readable code. Clients branch on it. It never
  changes once released.
- `message` is human readable and safe to display. It contains no internal
  detail.
- `fields` appears only for validation failures, and only where field level
  disclosure is safe.

## Status codes

| Code | Meaning | Typical cause |
|---|---|---|
| 400 | malformed | unparseable body, wrong types, schema failure |
| 401 | unauthenticated | missing or invalid credentials |
| 403 | unauthorized | valid identity, insufficient rights |
| 404 | absent | the resource does not exist, or is hidden from this caller |
| 405 | wrong method | route exists, verb does not |
| 409 | conflict | duplicate, concurrent modification, state conflict |
| 410 | gone | expired invitation, revoked token |
| 413 | too large | body or upload over the limit |
| 415 | unsupported type | content type not accepted |
| 422 | semantically invalid | well formed, but violates a business rule |
| 429 | rate limited | with a Retry-After header |
| 500 | unexpected | anything the code did not anticipate |
| 502 or 503 | upstream failure | a dependency is unavailable |

## The 403 versus 404 decision

Returning 403 tells the caller the resource exists. For resources whose
existence is itself private, return 404 instead. Decide per resource, write it
down, and be consistent, because inconsistency is itself an oracle.

## Expected versus unexpected

```ts
// Expected: a business outcome, not an incident
if (existing) {
  return conflict("invitation_already_pending", {
    message: "An invitation is already pending for this address.",
  })
}

// Unexpected: log everything, return nothing
try {
  await sendInvitationEmail(invitation)
} catch (error) {
  logger.error("invitation.email.failed", {
    invitationId: invitation.id,
    teamId: invitation.teamId,
    error,
  })
  return internalError()
}
```

The distinction drives three things: the status code, the log level, and
whether an alert fires. An expected failure that logs at error level trains
the team to ignore alerts.

## What never appears in a response

- stack traces;
- SQL, ORM messages, constraint names;
- file paths;
- internal identifiers of other entities;
- the reason a lookup failed when the reason is sensitive;
- provider error text passed through verbatim, which often contains an
  account identifier or a key prefix.

## Retryability

The client must be able to tell whether retrying helps.

| Class | Retryable |
|---|---|
| 400, 403, 404, 409, 422 | no, the request must change |
| 401 | after refreshing credentials |
| 429 | yes, after `Retry-After` |
| 500 | no, unless the endpoint is documented idempotent |
| 502, 503, 504 | yes, with backoff |

A client that retries a 409 duplicates work. A client that does not retry a
503 fails a transient outage. Both are contract failures, not client bugs.
