# Decision record template

One file per decision that is expensive to reverse. Numbered, dated, never
edited after acceptance; a superseding record is written instead.

```markdown
# ADR 0007: single writer for the invitations table

Date: 2026-08-10
Status: accepted
Supersedes: none

## Context

The invitations feature is written by the API service. The scheduled cleanup
job currently deletes expired rows directly through its own connection. A
second writer means the expiry rule exists in two places and has already
diverged once.

Constraint: one PostgreSQL instance, one deployable API, one worker process.
Load: fewer than one thousand invitations per day.
Failure cost: a wrongly deleted invitation blocks a paying customer from
onboarding a team member.
Change rate: the expiry rule changed twice in six months.

## Options

1. Keep two writers, duplicate the rule, add a test in both places.
   Cost: the rule diverges again on the third change.
2. Move the cleanup into the API service behind an internal call.
   Cost: the worker gains a network dependency on the API.
3. Move the expiry rule into a shared module, both processes call it, the
   worker keeps writing.
   Cost: two writers remain, so a future schema change still touches both.
4. The API owns the table, the worker triggers cleanup through a job the API
   executes.
   Cost: one more job definition, no network dependency.

## Decision

Option 4. The API service is the single writer of `invitations`. The worker
enqueues a cleanup job; the API executes it.

## Consequences

Positive: one owner, one expiry rule, one place to change the schema.
Negative: cleanup latency now depends on queue drain time, bounded at five
minutes, which the failure cost tolerates.
Operational: the queue depth for the cleanup job needs a monitor.

## Reversal cost

Low. Reverting means restoring the direct delete in the worker, roughly thirty
lines and one migration free change. Nothing else depends on this decision.
```

## Rules

- Context states forces, not opinions. Every number is measured or marked
  `Unknown`.
- At least two options, and the option that was not taken keeps its honest
  advantages. An option list where every alternative is a straw man is worth
  nothing.
- Consequences include the negative ones. A record with only benefits was not
  written honestly.
- Reversal cost is mandatory. It is the single most useful line for the next
  engineer.
- Status values: `proposed`, `accepted`, `superseded`, `rejected`.
- File naming: `NNNN-short-kebab-title.md`, in the directory the project
  already uses for documentation.
