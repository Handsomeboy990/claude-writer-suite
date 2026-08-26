# Example: a key in a public repository

Reported by an automated scanner at 09:14: a live payment provider secret key
in a public repository, committed eleven weeks earlier in an example file.

## The wrong sequence, which is the instinctive one

```
09:14  discover
09:16  delete the line, commit, push
09:20  start rewriting the history
10:40  history rewritten and force pushed
10:45  tell the client the secret has been removed
```

Ninety minutes during which the key remained valid, followed by a report that
describes housekeeping as remediation. The key was live for eleven weeks and
was live for another ninety minutes after discovery.

## What was actually done

```
09:14  discover
09:16  create a new restricted key in the provider dashboard
09:19  set STRIPE_SECRET_KEY in production and staging
09:22  redeploy production, health check green
09:24  verify: a test charge in the provider's test mode succeeds on the new
       key, confirmed in the dashboard
09:25  the exposure is now inert
```

Eleven minutes from discovery to the leaked key being useless. Everything
after this point is investigation and cleanup, done without pressure.

## Assessment, before revoking

```
Granted:   full API access on the live account: charges, refunds, customer
           data, payout configuration
Exposed:   11 weeks, public repository, commit 3d81ba0
Evidence:  provider access log covers 30 days
           no API calls from an IP outside our two known ranges
           no charge, refund or payout the ledger does not account for
Uncertain: the first 7 weeks are outside the log window. No evidence of
           misuse, and no ability to prove its absence.
```

The uncertainty is stated in exactly those terms in the report. The client
needs it to decide whether any notification obligation applies, and softening
it would take that decision away from them.

## Revocation

```
09:52  old key revoked, after confirming the new one had served traffic for
       28 minutes with no errors
```

Revoking at 09:19 would have broken checkout for three minutes between the
revocation and the deploy. The order exists to avoid turning a security event
into an outage.

## Removal, and its honest limits

```
Working tree  the line removed from .env.example, committed
History       not rewritten. The repository is public and has 40 forks. A
              rewrite would break every clone and would not remove the value
              from the forks, the platform's cache, or any scanner that
              already indexed it.
Recorded      the commit is public and will remain so. The key it contained is
              revoked and worthless.
```

Not rewriting is the correct call here and it is written down with its reason,
so nobody later assumes it was an oversight.

## Prevention

Root cause: a developer filled `.env.example` with working values so a
colleague could start quickly.

```
Changed
  .env.example holds empty values only; enforced by the drift check in the
  pipeline, which fails when a line has a non empty value
  a secret scanner added to the pipeline, running on every push
  a pre-commit scan of the staged diff, per git-workflow
  onboarding credentials now issued per person from the secret store, so
  nobody needs to share one
```

The last line addresses the actual motivation. A prevention that only forbids
the shortcut, without removing the need for it, gets worked around.

## The report, in full

```
Leaked:      STRIPE_SECRET_KEY, live account
Exposed:     2026-05-24 to 2026-08-10, public repository, commit 3d81ba0
Granted:     full live API access
Evidence:    30 day access log shows no calls from unknown addresses; ledger
             reconciles; no unexplained charge, refund or payout
Rotated:     2026-08-10 09:16, verified 09:24
Revoked:     2026-08-10 09:52
Removed:     working tree yes; history not rewritten, see reasoning
Remains public: the commit, containing a now revoked key
Prevention:  empty example values enforced in CI, secret scanner in the
             pipeline, pre-commit scan, per person onboarding credentials
Uncertain:   7 of the 11 weeks fall outside the provider's log retention. No
             evidence of misuse; absence of misuse cannot be proven for that
             period.
Recommend:   the client reviews whether their obligations require any
             notification for that window.
```

## The three lines that matter

**Rotation at 09:16, two minutes after discovery.** Everything else is
recoverable; the live key was not.

**Revocation after verification, not before.** The security response should
not create the outage.

**The uncertainty, unsoftened.** "No evidence of misuse" and "misuse did not
occur" are different statements, and only one of them is true.
