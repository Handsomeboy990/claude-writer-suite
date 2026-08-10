# Rollback plan template

Written before the deploy. One line is acceptable; absent is not.

```markdown
## Rollback, release v2.4.0

### Code

Revert to v2.3.1 and redeploy.
Command: <the project's deploy command with the previous revision>
Time: approximately 6 minutes, of which 4 is the build.

### Database

The migration adds the invitations table and an index. It is not reverted
during a rollback; the previous code ignores the table.

If the migration must be reverted: <command>. This drops the table and every
invitation created since the deploy. Those invitations cannot be recovered.

### What a rollback does not restore

- Invitation emails already sent. Recipients hold valid tokens which the
  reverted code does not recognise; they will see an error page.
- Analytics events already emitted.
- Nothing else in this release has an external side effect.

### Cache

Invalidate the team members and invitations keys after rolling back, otherwise
the pending list renders from a cache the reverted code cannot refresh.
Command: <the project's cache invalidation command>

### Verification after rollback

1. The members page loads without the invitations section.
2. POST to the invitations endpoint returns 404.
3. Error rate returns to its pre deploy level within five minutes.

### Decision threshold

Roll back if any of these holds in the first thirty minutes:
- error rate on /api/teams above 1 percent;
- any report of a user seeing another team's data;
- invitation email delivery failure rate above 20 percent.
```

## Rules

**Write it before, not during.** A rollback plan composed during an incident is
composed by someone under pressure who is also reading the code for the first
time in a week.

**State what does not roll back.** This is the section that changes decisions.
Sent mail, delivered webhooks, captured payments, written files and dropped
columns are all outside the revert.

**Give a time.** Knowing that a rollback takes six minutes and not sixty
changes whether it is attempted.

**Give a threshold.** A number decided calmly beforehand beats a judgement
made during an incident.

**Include cache.** A rollback that leaves a cache populated by the new code is
a rollback that did not work, and it presents as an intermittent failure that
nobody can reproduce.
