# Release checklist

Nine gates. Each line is `pass`, `fail` with the blocker, or `n/a` with the
reason.

## 1. Scope

- [ ] Every intended change is present in the diff.
- [ ] Nothing unintended is present.
- [ ] No debug output, no commented out code, no scratch file.
- [ ] No leftover feature flag that nothing reads.
- [ ] No work in progress path reachable by a user.
- [ ] The diff since the last release was read, not summarised from memory.

## 2. Tests

- [ ] The full suite ran on this exact revision.
- [ ] The suite passed. Not mostly passed.
- [ ] New behaviour is covered, including negative cases.
- [ ] No test was skipped or weakened to reach green.
- [ ] Browser tests ran where they exist, twice if they are new.
- [ ] Type checking and linting pass.

## 3. Security

- [ ] The applicable audit points were checked against the diff.
- [ ] No secret in the diff.
- [ ] No secret in the history added since the last release.
- [ ] Dependency advisories reviewed for reachability.
- [ ] Manual actions listed, with owners who know about them.
- [ ] New endpoints have authorization, verified rather than assumed.

## 4. Performance

- [ ] No unbounded query introduced.
- [ ] No query inside a loop introduced.
- [ ] New filter, join and order paths are indexed.
- [ ] Claimed improvements carry a before and an after number.
- [ ] Bundle size change is known where a client bundle exists.

## 5. Migrations

- [ ] Reversible, or the irreversibility is stated and accepted by a name.
- [ ] Order relative to the code deploy is decided.
- [ ] The previous application version works during the deploy window.
- [ ] Lock behaviour on large tables is known.
- [ ] Backfills are batched and resumable.
- [ ] Indexes on large tables are created without blocking writes.
- [ ] The migration was run against a copy of realistic data, or the absence
      of that rehearsal is stated.

## 6. Configuration

- [ ] Every new environment variable exists in the target environment.
- [ ] Missing configuration causes a fast, clear failure, not degraded
      operation.
- [ ] Provider dashboards are configured: webhooks, keys, callbacks.
- [ ] Storage policies, cron entries and queues are configured.
- [ ] Nothing depends on a value that exists only on a developer machine.
- [ ] Configuration changes are recorded in the deployment notes.

## 7. Documentation

- [ ] API reference matches this revision.
- [ ] Setup guide matches this revision.
- [ ] Changelog entry written, user visible changes only.
- [ ] Breaking changes carry their migration step.
- [ ] Documentation for removed behaviour was deleted.

## 8. Rollback

- [ ] The steps are written before the deploy.
- [ ] Time to roll back is known.
- [ ] What the rollback does not restore is stated: dropped data, sent mail,
      delivered webhooks, captured payments, written files.
- [ ] Cache invalidation after a rollback is specified.
- [ ] The verification that the rollback worked is specified.

## 9. Observability

- [ ] A failure of this change produces a log with enough context.
- [ ] The error surfaces somewhere a person will see.
- [ ] A named metric or query answers whether the change is working.
- [ ] The threshold that means roll back is stated.

## Verdict

- [ ] Every gate has an answer.
- [ ] Every blocker names what unblocks it.
- [ ] Unchecked gates are reported as unchecked, with the missing input.
- [ ] The verdict is `Go`, `Go with notes`, or `No go`. Nothing else.
