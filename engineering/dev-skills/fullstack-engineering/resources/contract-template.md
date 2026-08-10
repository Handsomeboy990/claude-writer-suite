# Feature contract template

Written before either side is implemented. One page. Both sides implement it
and the tests assert it.

```markdown
## Endpoint

POST /api/teams/:teamId/invitations

## Request

Path    teamId: uuid, must be a team the caller administers
Body    email: string, trimmed, lowercased, max 254, valid address
        role: "member" | "admin"
        message: string, max 500, optional
Headers none beyond the session cookie

Ownership: the caller identity comes from the session, never from the body.

## Response, 201

{
  "id": "inv_01H...",
  "email": "someone@example.com",
  "role": "member",
  "status": "pending",
  "expiresAt": "2026-08-17T10:00:00.000Z"
}

Explicit field list. The invitation token is never returned; it is only sent
by email.

## Errors

| Status | error | Retryable | Client behaviour |
|---|---|---|---|
| 400 | invalid_body | no | field errors on the form |
| 401 | unauthenticated | after sign in | keep the input, prompt to sign in |
| 403 | forbidden | no | message, no detail about the team |
| 404 | not_found | no | same as forbidden, team existence is private |
| 409 | already_member | no | message naming the person |
| 409 | invitation_pending | no | offer to resend rather than duplicate |
| 402 | seat_limit_reached | no | upgrade path |
| 429 | rate_limited | after Retry-After | disable submit and show the delay |
| 500 | internal | no | generic error state with retry |

## Effects

Writes    one row in invitations
Sends     one invitation email, after the transaction commits
Invalidates  the team invitations list and the team member count
Emits     invitation.created, with teamId and role, no email address

## Pagination

Not applicable to this endpoint. The list endpoint uses cursor pagination,
default 20, maximum 100.

## Representations

Timestamps  ISO 8601 with an explicit UTC offset
Identifiers opaque strings, never sequential integers in a response
Money       not applicable
Empty list  an empty array, never a missing field
```

## Rules

- The contract is written once and referenced, never restated in two places
  that can drift.
- Every error the server can produce appears in the table, and the client
  handles each row.
- The effects section is what makes cache invalidation a decision rather than
  an afterthought.
- If the stack can generate types from this shape, generate them and delete
  the hand written duplicates.
- A change to a released contract requires a version, a deprecation path or a
  migration, decided here and not in the pull request description.
