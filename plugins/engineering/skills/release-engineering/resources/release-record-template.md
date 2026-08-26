# Release record template

One per release, kept where the project keeps its releases.

````markdown
# v2.4.0

Commit:      a91f0c2
Released:    2026-08-11 14:20 UTC by <name>
Readiness:   go with notes, see the readiness report
Rollout:     rolling, 4 instances, health gated
Duration:    6 minutes to full traffic

## Contents

### Breaking

- `GET /api/invoices` no longer accepts `customerId`. Invoices are always
  scoped to the authenticated user. Clients sending the parameter should
  remove it; no other change is required.

### Added

- Team administrators can invite members by email. Invitations expire after
  seven days.

### Fixed

- The order confirmation email showed the pre discount total when a coupon
  was applied.

### Security

- The payment webhook endpoint now verifies the request signature. Deployments
  must set `STRIPE_WEBHOOK_SECRET`; the service refuses to start without it.
  Anyone running a previous version should upgrade promptly.

## Migrations

| Migration | Kind | Reversible | Notes |
|---|---|---|---|
| 20260810_invitations | additive | yes | table plus a partial unique index, created concurrently |
| 20260810_role_support | additive | yes | new enum value |

No destructive migration in this release.

## Verification

Production verification: verified, 13 of 13 checks.
Watch window: 30 minutes, error rate 0.1 percent against a 1 percent
threshold, p95 unchanged.

## Rollback

Available until: the next destructive migration, expected in v2.5.0
Command: <the revert command>
Duration: 6 minutes, measured
Does not restore: invitations created since the release, emails sent

## Observed

Nothing unusual during the window.

## Deferred to follow up

- FU21 second payout rail for CH, NO, IS
- FU12 index on orders.customer_id, recommended before 50k rows
````

## The breaking change discipline

The version is `2.4.0`, not `3.0.0`, and the changelog contains a breaking
change. That combination requires justification, and here it is:

```
The removed parameter was never part of the documented public contract. It
was accepted by the handler and ignored by the authorization logic, which was
the security defect being fixed. No documented client used it.
```

That reasoning is written in the record. Without it, the next reader sees a
breaking change in a minor release and cannot tell whether the scheme is being
followed or ignored.

Where a genuine public contract breaks, the version is major. Shipping it as
minor to avoid the conversation is the failure this section exists to prevent.

## Changelog entries, before and after

```
From the commit log, which is not a changelog
  fix: correct invoice scoping
  feat: add invitation service with expiry and quota rules
  feat: add team invitation endpoints
  test: cover invitation duplicates
  refactor: extract validation helpers
  chore: bump dependencies

For a reader
  Breaking: GET /api/invoices no longer accepts customerId
  Added:    team administrators can invite members by email
```

Six commits, two entries. The refactor, the test and the dependency bump
change nothing for anyone reading the changelog, and including them buries the
two lines that matter.

## Feature flag entry, when a release contains one

```
| Flag | Controls | Default | Scope | Owner | Removal | Expiry |
|---|---|---|---|---|---|---|
| new_checkout | the rewritten checkout flow | off | per account | product | when enabled for all accounts for 2 weeks with no regression, delete the flag and the old path | 2026-11-01 |
```

The removal condition and the expiry are what stop the flag becoming permanent
configuration with a dead branch behind it.
