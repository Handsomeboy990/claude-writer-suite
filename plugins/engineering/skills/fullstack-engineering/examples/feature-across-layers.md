# Example: one feature, traced through every layer

Feature: a team administrator invites a member by email.

## The chain, success path

```
click Invite
  -> InviteDialog form state
  -> client schema check, email shape and role enum
  -> POST /api/teams/:teamId/invitations
  -> inviteParams and inviteSchema parsed
  -> requireSession
  -> getMembership, must be admin of this team
  -> createInvitation service
       seat quota checked
       existing member checked
       pending invitation checked
       token generated, hashed, stored
  -> transaction: insert invitations row
  -> after commit: send email through the mailer
  -> 201 with the invitation, without the token
  -> invalidate ["team", teamId, "invitations"] and ["team", teamId, "members"]
  -> dialog closes, focus returns to the Invite button
  -> the pending list shows the new row, live region announces it
```

## The chain, failures, implemented at the same time

| Failure | Server | Client |
|---|---|---|
| malformed email | 400 invalid_body with fields | error under the field, focus moved there |
| not an admin | 403 forbidden | message, dialog stays open, no team detail |
| team does not exist | 404 not_found | identical message to 403 by design |
| already a member | 409 already_member | message naming the person, dialog stays open |
| invitation pending | 409 invitation_pending | offer to resend instead of a duplicate |
| seat limit | 402 seat_limit_reached | upgrade link, input preserved |
| mail provider down | 201, invitation created, delivery marked failed | banner: created, delivery retrying |
| rate limited | 429 with Retry-After | submit disabled, countdown shown |
| database down | 500 internal | generic error state, retry button |

The mail provider row is the one that gets decided badly by default. Two
options: fail the request, so the user retries and creates two rows, or commit
and retry the delivery. The second was chosen, and the UI tells the truth
about it. The decision is in the contract, not implied by a try block.

## Order of work, actually followed

**1. Contract.** One page, in `resources/contract-template.md` form, including
the error table above.

**2. Migration.**

```sql
create table invitations (
  id            text primary key,
  team_id       uuid not null references teams(id) on delete cascade,
  email         text not null,
  role          text not null check (role in ('member','admin')),
  token_hash    text not null,
  status        text not null default 'pending',
  expires_at    timestamptz not null,
  created_at    timestamptz not null default now()
);

create unique index invitations_pending_uniq
  on invitations (team_id, email) where status = 'pending';

create index invitations_team_status_idx on invitations (team_id, status);
```

The partial unique index is the feature's real concurrency control. Two
simultaneous invitations for the same address produce one row and one
conflict, without a lock and without a read then write.

The role check constraint duplicates the schema enum on purpose: the database
is the last line, and it does not trust the application either.

**3. Server.** Service rules, then handler, in the order from
`backend-engineering`. The token is generated with a cryptographic random
source, stored hashed, and returned to nobody.

**4. Contract test, before any UI exists.**

```
POST returns 201 and the declared shape                    ok
token is absent from the response                          ok
non admin receives 403                                     ok
unknown team receives 404, identical body to 403           ok
duplicate pending invitation receives 409                  ok
existing member receives 409 already_member                ok
two concurrent identical requests: one 201, one 409        ok
seat limit reached receives 402                            ok
```

At this point the endpoint is trustworthy, and the UI can be built against
something real instead of an assumption.

**5. Client data layer.**

```ts
export function useCreateInvitation(teamId: string) {
  const qc = useQueryClient()
  return useMutation({
    mutationFn: (input: CreateInvitation) => api.invitations.create(teamId, input),
    onSuccess: () => {
      qc.invalidateQueries({ queryKey: ["team", teamId, "invitations"] })
      qc.invalidateQueries({ queryKey: ["team", teamId, "members"] })
    },
  })
}
```

The invalidation is written with the mutation, not after someone reports that
the list is stale.

**6. UI.** The dialog implements the five states, maps every error code from
the table, keeps the input on failure, and restores focus to the trigger on
close.

**7. Journey test.** Playwright: sign in, open the dialog, invite, see the row
appear, then invite the same address again and see the conflict message.

## Cross layer consistency, checked explicitly

| Rule | Result |
|---|---|
| client rules are a subset of server rules | yes, client checks email shape and role only |
| every server error code handled | 9 of 9 |
| one type definition | generated from the Zod schema, imported both sides |
| timestamps | ISO 8601 UTC on the wire, formatted at render |
| empty list | empty array, both sides |
| every mutation declares invalidation | yes |
| UI hiding is not the protection | the 403 test proves the server rejects |

## Matrix

Every row `done`. The one exception recorded honestly:

```
external effects | done | n/a | done | partial
```

The mail failure path is covered by a unit test with a stubbed mailer, but not
by an end to end test, because the test environment has no mail sandbox.
Recorded in the continuity notes with the exact gap rather than left as an
implied pass.
