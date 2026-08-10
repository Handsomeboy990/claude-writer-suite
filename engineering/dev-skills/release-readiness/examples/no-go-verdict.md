# Example: a release that was stopped

Release requested: v2.4.0, forty eight commits since v2.3.1.

## Gates, as executed

```
1 Scope         pass
  Diff read. One leftover found and removed before the review completed:
  a console.log of the session object in lib/session.ts:44.

2 Tests         pass
  npm test                  228 passing, 0 failing
  npx playwright test       6 passing, run twice, stable
  npm run typecheck         clean
  npm run lint              clean

3 Security      pass with manual actions
  18 applicable points checked, 6 skipped with reasons.
  5 findings, all fixed in code.
  3 manual actions, listed below, owners informed.

4 Performance   pass
  Dashboard LCP 4.8s to 1.4s, both measured, conditions recorded.
  No new unbounded query. New index on orders(team_id, created_at desc).

5 Migrations    BLOCKER
  Two migrations. The second drops orders.legacy_customer_name.
  The previous application version reads that column at
  lib/orders/legacy.ts:18, which is still on the serving path for accounts
  created before 2024.
  Consequence: during the deploy window, the old instances error on every
  legacy order until they are replaced.

6 Configuration BLOCKER
  STRIPE_WEBHOOK_SECRET is not set in production.
  The webhook handler now refuses to start without it, which is the correct
  behaviour and also means the deployment fails.
  Verified by inspection of the deployment configuration, not assumed.

7 Documentation pass
  API reference updated, breaking change on GET /api/invoices documented with
  its migration step, changelog written.

8 Rollback      fail, dependent on gate 5
  A rollback after the column drop does not restore the data. The plan cannot
  be written honestly until the migration is split.

9 Observability pass
  invitation.email.failed and payment.attempt.pending are logged with
  correlation identifiers. Delivery state is queryable. Threshold for rollback
  defined at 1 percent error rate on /api/teams.
```

## Verdict

```
NO GO

Blockers
1 Gate 5. Split the migration. Ship the additive part now; the drop goes in
  the release after the legacy read path is removed. This is the standard
  expand and contract sequence, and skipping it is what makes deploys
  non atomic.
2 Gate 6. Set STRIPE_WEBHOOK_SECRET in the production environment. Owner
  informed. This is a one minute action that stops a failed deploy.

After both: gate 5 becomes pass, gate 8 becomes writable, verdict becomes
Go with notes.
```

## The blocker that would have been missed

Gate 6 is the one that looks like a formality. The variable existed locally,
existed in staging, and the code worked in every environment anyone had
checked. Nobody had opened the production configuration, because the
assumption that it matched staging is the assumption everyone makes.

Verifying it took one look. Not verifying it would have produced a failed
deploy on a Friday, and the failure would have presented as the application
refusing to start, which reads as a much larger problem than a missing
variable.

## The blocker that would have been costly

Gate 5 is the expensive one. The column drop passes every test, because the
tests run against the new code only. The failure appears only in the window
where old and new instances serve simultaneously, which no test environment
reproduces.

Consequence, had it shipped: several minutes of errors for a subset of
accounts, and a rollback that does not restore the dropped data. The
correction is a sequencing change, not a code change, and it costs one extra
release.

## Manual actions from gate 3, carried forward

```
1 Rotate STRIPE_SECRET_KEY. It appeared in .env.example in commit 3d81ba0.
  Removing it from the file does not undo the exposure.
2 Delete the old webhook endpoint in the Stripe dashboard; it points at the
  previous domain.
3 Restrict the uploads bucket to authenticated reads. Not visible from the
  repository, confirmed with the platform owner.
```

These do not block the release, and they are listed in the report rather than
in a separate place, so they are not lost the moment the release passes.

## What the release process produced

Two blockers, both cheap to fix, both invisible from the diff. The suite was
green throughout. That is the argument for the gate: a passing test suite
tells you the code is consistent with itself, not that the deployment will
work.
