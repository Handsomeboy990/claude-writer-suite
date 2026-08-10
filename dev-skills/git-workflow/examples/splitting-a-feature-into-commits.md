# Example: one feature, split correctly

Work completed: team invitations, end to end. Thirty one files changed.

## The commit that gets proposed

```
feat: add team invitations

31 files changed, 1,204 insertions(+), 38 deletions(-)
```

Unreviewable, unrevertable, and useless during a bisection three months later.

## The split that ships

```
chore: add rate limiter helper on the existing redis client
feat: add invitations table with a partial unique index
feat: add invitation service with expiry and quota rules
feat: add team invitation endpoints
feat: add invitation dialog to the members page
fix: return focus to the trigger when a dialog closes
test: cover invitation duplicates, quota and concurrency
docs: document the invitation flow and its expiry policy
```

Eight commits. Each one is a unit somebody can read, revert or bisect to.

## Why each boundary is where it is

**The rate limiter first, as `chore`.** It is infrastructure used by the
feature but not part of it. Committed first, it is available to the endpoint
commit and revertable independently if it turns out to be wrong.

**The migration alone.** Schema changes have a different deployment lifetime
from code. During a rollback, the migration commonly stays while the code
reverts, and that is only possible if they are separate commits.

**The service before the endpoint.** The rules are testable without HTTP. If
the endpoint design changes, the rules survive.

**The dialog separate from the endpoint.** Different reviewers, different
concerns, and a UI revert should not take the API with it.

**The focus fix as `fix`, not folded into the dialog commit.** It corrects
pre-existing behaviour in a shared dialog component that other screens use.
Buried inside the feature commit, nobody would find it when the same bug is
reported elsewhere.

**Tests in their own commit here**, because they cover three commits at once.
When tests belong to a single commit, they ship inside it.

**Documentation last**, describing what was actually built rather than what
was planned.

## The message body where one was needed

```
feat: add invitations table with a partial unique index

The unique index is partial on status = 'pending' so that a declined or
expired invitation does not block a new one for the same address.

Rejected: a plain unique constraint on (team_id, email), which would have
required deleting historic rows and losing the audit trail.
```

The body exists because the partial index would otherwise look like an
oversight to the next reader.

## Verification of the history

```bash
git log --format='%h %an <%ae> %s' -8
```

```
a91f0c2 Handsomeboy990 <lauretchacha@gmail.com> docs: document the invitation flow and its expiry policy
7c1a904 Handsomeboy990 <lauretchacha@gmail.com> test: cover invitation duplicates, quota and concurrency
b2f8e11 Handsomeboy990 <lauretchacha@gmail.com> fix: return focus to the trigger when a dialog closes
4f1c8a2 Handsomeboy990 <lauretchacha@gmail.com> feat: add invitation dialog to the members page
2a9d7b1 Handsomeboy990 <lauretchacha@gmail.com> feat: add team invitation endpoints
8c1e2f4 Handsomeboy990 <lauretchacha@gmail.com> feat: add invitation service with expiry and quota rules
3d81ba0 Handsomeboy990 <lauretchacha@gmail.com> feat: add invitations table with a partial unique index
5e0c7a6 Handsomeboy990 <lauretchacha@gmail.com> chore: add rate limiter helper on the existing redis client
```

```bash
git log --format='%b' -8 | grep -iE 'co-authored|generated|assistant|claude|\bai\b'
```

No output, which is the required result.

## The pull request

```markdown
## Summary
Team administrators can invite members by email. Invitations expire after
seven days and are limited by the team seat quota.

## Implementation
Eight commits, listed in order. The partial unique index on pending
invitations is the concurrency control; there is no application level lock.
Mail delivery happens after commit, so a provider outage does not roll back
the invitation, and the UI reports delivery separately from creation.

## Tests
14 unit and integration cases, 1 browser journey. Includes the concurrent
duplicate case, which fails against a plain unique constraint.
npm test: 228 passing. npx playwright test: 6 passing.

## Migrations
One additive migration, reversible. No backfill. The index is created
concurrently. The previous application version is unaffected.

## Deployment notes
No new environment variables. The rate limiter uses the existing Redis
connection.

## Risks
Mail delivery failure leaves an invitation the recipient never sees. The
pending list shows the delivery state, and a resend action is available.

## Follow up
Cross team invitation flooding for the same address is not limited. Recorded
in the continuity notes with the proposed constraint.
```

Every section carries information a reviewer could not get from the diff. That
is the only reason a pull request description exists.
