---
name: release-readiness
description: Final gate before shipping: verifies scope, tests, security, performance, migrations, configuration, documentation, rollback and observability, then issues a go or no go verdict with named blockers. Use on any ship, deploy, release or version request.
license: MIT
metadata:
  category: dev-skills
  version: 1.0.0
  depends_on: [engineering-core, testing-quality, security-audit, project-continuity]
  outputs: [readiness-report, go-no-go-verdict, rollback-plan, deployment-notes]
---

# Release Readiness

The last point at which a problem is cheap. Everything after this is an
incident.

The output is a verdict with evidence, not an opinion. `Go` means the checks
below were run and passed on this revision.

## 1. Scope of the review

```
Revision      the exact commit being released
Diff          since the last release, read, not summarised from memory
Surface       what a user can do differently after this
Blast radius  who is affected if it is wrong
Reversibility what can be undone, and what cannot
```

The irreversible parts drive the rigour. A migration that drops a column and
an email that goes to every customer are the two things a rollback does not
fix.

## 2. The nine gates

Each is `pass`, `fail` with the blocker, or `not applicable` with the reason.

**1. Scope.** Every intended change is present. Nothing unintended is present.
The diff contains no debug code, no commented out block, no leftover feature
flag that nobody reads, no work in progress.

**2. Tests.** The full suite ran on this revision and passed. New behaviour is
covered, including the negative cases. No test was skipped or weakened to
reach green. Browser tests ran where they exist.

**3. Security.** The applicable points of `security-audit` were checked on the
diff. No secret in the diff or in the history added since the last release.
Dependency advisories reviewed. Manual actions are listed and their owners
know.

**4. Performance.** No unbounded query, no query in a loop, no missing index
on a new filter path, introduced by this diff. Where a performance change is
claimed, both numbers exist.

**5. Migrations.** Reversible, or the irreversibility is stated and accepted.
The order relative to the code deploy is decided. The previous version works
during the window. Lock behaviour on large tables is known. A backfill is
batched and can be resumed.

**6. Configuration.** Every new environment variable exists in the target
environment, or the service fails fast with a clear message rather than
running degraded. Provider dashboards, webhooks, storage policies and cron
entries are configured. Nothing depends on a value that only exists on a
developer machine.

**7. Documentation.** The API reference, setup guide and changelog match this
revision. Breaking changes carry their migration step. Removed behaviour is
removed from the documentation.

**8. Rollback.** The exact steps are written before the deploy. What the
rollback restores and what it does not is stated. Time to roll back is known.

**9. Observability.** A failure of this change is visible: logs with enough
context, an error surface, and a metric or a query that answers whether it is
working, named explicitly.

## 3. Blockers versus notes

| Kind | Definition |
|---|---|
| blocker | ship and something breaks, leaks, corrupts, or cannot be undone |
| note | worth knowing, does not stop the release |

Any `fail` on gates 1, 2, 3, 5 or 8 is a blocker by default. Downgrading one
requires a written reason and a named person accepting it.

## 4. Deployment notes

Produced for whoever performs the deploy, in order:

```
Before        configuration to set, migrations to run, order relative to code
Deploy        the sequence, including any pause between steps
After         what to verify, with the specific check
Watch         what to look at for the first period, and the threshold that
              means roll back
Rollback      the exact steps, and what they do not restore
Inform        who needs to know, and when
```

## 5. Rollback plan

Written before the deploy, always, even when it is one line.

```
Code          how to revert, and how long it takes
Database      what the migration rollback restores; a dropped column's data
              is not restored by reverting the migration
Side effects  emails sent, webhooks delivered, payments captured, files
              written: none of these roll back
Cache         what must be invalidated after a rollback
Verification  how to confirm the rollback worked
```

The side effects line is the one that changes decisions. A release that sends
mail is not reversible, whatever the code does, and that fact belongs in the
verdict rather than in the incident review.

## 6. The verdict

```
Go              all applicable gates pass, evidence attached
Go with notes   all gates pass, listed notes accepted
No go           one or more blockers, each named with what unblocks it
```

There is no `probably fine`. A gate that could not be checked is reported as
unchecked with the missing input, and the verdict accounts for it explicitly.

## 7. Report format

```
Release        v2.4.0, revision a91f0c2
Diff           48 commits since v2.3.1, 112 files
Surface        team invitations, invoice scoping change

1 Scope         pass    no debug code, no leftover flags
2 Tests         pass    npm test 228 passing, playwright 6 passing
3 Security      pass    18 points checked, 5 findings fixed, 3 manual actions
4 Performance   pass    dashboard 4.8s to 1.4s, no new unbounded query
5 Migrations    pass    one additive, reversible, index created concurrently
6 Configuration BLOCKER STRIPE_WEBHOOK_SECRET is not set in production; the
                        service now fails to start without it
7 Documentation pass    api reference and changelog updated, breaking change
                        documented with its migration step
8 Rollback      pass    revert plus redeploy, 6 minutes, migration stays
9 Observability pass    invitation.email.failed logged, delivery state queryable

Verdict: NO GO
Unblocks: set STRIPE_WEBHOOK_SECRET in the production environment.
After that, re-run gate 6 and the verdict is Go with notes.

Notes
- Cross team invitation flooding is unlimited. Not a regression, recorded.
- Invoice scoping is a breaking change for any client sending customerId.
  Documented; no known external client uses it.
```

## 8. Prohibitions

- Never issue a verdict without running the checks.
- Never declare a system secure or bug free.
- Never downgrade a blocker to meet a deadline without a named acceptance.
- Never ship with a red suite, whatever the reason given for the red.
- Never deploy without a rollback plan, including for a small change.
- Never assume an environment variable is set because it exists locally.

## 9. Auto-critique

Score from 0 to 5: gates actually executed, evidence attached, blockers
correctly classified, migration and rollback realism, configuration verified
rather than assumed, side effects acknowledged, verdict honesty.

Threshold: no axis below 3, average at least 4. A `Go` issued without
executing gate 2 is an automatic failure of the whole review.

## 10. Interfaces

- Upstream: `testing-quality`, `security-audit`,
  `performance-engineering`, `technical-documentation`,
  `project-continuity`, `git-workflow`.
- Downstream: the deployment itself, and the continuity note that records
  what shipped.
