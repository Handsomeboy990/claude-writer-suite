# Document templates

## API endpoint reference

````markdown
### POST /api/teams/:teamId/invitations

Invites a member to a team. Requires an authenticated administrator of the
team.

**Path parameters**

| Name | Type | Notes |
|---|---|---|
| teamId | uuid | must be a team the caller administers |

**Body**

| Field | Type | Required | Constraints |
|---|---|---|---|
| email | string | yes | valid address, maximum 254 characters |
| role | string | yes | `member` or `admin` |
| message | string | no | maximum 500 characters |

**Response 201**

```json
{
  "id": "inv_01H8XK",
  "email": "ada@example.com",
  "role": "member",
  "status": "pending",
  "expiresAt": "2026-08-17T10:00:00.000Z"
}
```

The invitation token is not returned. It is only sent to the invited address.

**Errors**

| Status | error | Cause |
|---|---|---|
| 400 | invalid_body | field constraints not met |
| 401 | unauthenticated | no valid session |
| 403 | forbidden | caller is not an administrator of this team |
| 404 | not_found | team does not exist, or is not visible to the caller |
| 409 | already_member | the address belongs to a current member |
| 409 | invitation_pending | an invitation is already pending |
| 402 | seat_limit_reached | the plan seat quota is reached |
| 429 | rate_limited | more than 20 invitations in an hour |

**Example**

```bash
curl -X POST https://api.example.com/api/teams/$TEAM_ID/invitations \
  -H "Content-Type: application/json" \
  -H "Cookie: sid=$SESSION" \
  -d '{"email":"ada@example.com","role":"member"}'
```
````

## Runbook entry

```markdown
### Invitation emails are not arriving

**Presents as**
Users report that invitations show as pending but no email arrives. The
invitations list shows delivery state `failed`.

**Confirm**
1. Query recent invitations with a failed delivery state.
2. Check the mail provider status page.
3. Check the application logs for `invitation.email.failed`.

**Act**
1. If the provider is down, no action; deliveries retry for one hour.
2. If the provider returns an authentication error, the API key was rotated
   without updating the environment. Update it and redeploy.
3. If a specific domain is rejecting, check the provider suppression list.

**Afterwards**
Trigger a resend for the affected invitations. Confirm the delivery state
changes to `sent`.

**Inform**
The team owner whose invitations failed, if more than one hour has passed.
```

## Decision record

Use the template in `architecture-design/resources/decision-record-template.md`.
It is not duplicated here.

## Changelog entry

```markdown
## 2.4.0

### Breaking

- `GET /api/invoices` no longer accepts a `customerId` query parameter.
  Invoices are always scoped to the authenticated user. Remove the parameter
  from client calls; no other change is required.

### Added

- Team administrators can invite members by email. Invitations expire after
  seven days.

### Fixed

- The order confirmation email showed the pre discount total when a coupon was
  applied.

### Security

- The Stripe webhook endpoint now verifies the payload signature. Set
  `STRIPE_WEBHOOK_SECRET` before deploying; the service fails to start
  without it.
```

Rules: user visible changes only, breaking changes first with the migration
step, and never a paraphrased commit log.

## Setup guide section

````markdown
## Environment variables

| Name | Required | Purpose | Where to obtain |
|---|---|---|---|
| DATABASE_URL | yes | PostgreSQL connection | your local instance, or the team vault |
| SESSION_SECRET | yes | signs session cookies | generate with `openssl rand -base64 32` |
| STRIPE_SECRET_KEY | yes | payment API access | Stripe dashboard, developers, API keys |
| STRIPE_WEBHOOK_SECRET | yes | verifies webhook signatures | Stripe dashboard, webhook endpoint |
| MAIL_FROM | no | sender address, defaults to noreply@localhost | |

Values are never committed. Copy `.env.example` to `.env` and fill it in.

## Verify the setup

```bash
pnpm db:migrate
pnpm test
pnpm dev
```

The last command serves the application on port 3000. Opening it shows the
sign in page. If the database is unreachable, the process exits with
`DATABASE_URL is not reachable` rather than starting in a broken state.
````
