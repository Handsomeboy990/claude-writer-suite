# Example: a campaign on a multi-tenant SaaS, from request to verdict

Request received: `test the app before we ship on Friday, here is the staging
link`.

## What was not done

No browser was opened, and no question was asked, until the repository had
been read. A campaign that starts with a click starts with an assumption.

## Discovery, forty minutes, no questions asked

```
Stack           Next.js 14, pnpm, Postgres via Prisma, Vitest, Playwright present
Surfaces        12 authenticated routes, 3 public, 41 API routes, 2 cron jobs
Identity        session cookie, roles owner, admin, member, viewer
Tenancy         organisationId on 23 of 25 models
Environments    local, staging, production. Staging shares the mail provider
Existing tests  Vitest 214 tests, mostly unit. Playwright: 3 specs, 1 skipped
                since March. Coverage config excludes app/api entirely
CI              lint, typecheck, unit. E2E job exists and is allow-failure
Known state     staging runs commit 8f21c04, one release behind main
```

Three facts changed the whole plan before anyone was asked anything:

1. `app/api` is excluded from coverage, so the API is the least verified
   surface despite carrying every authorization decision.
2. Two models have no `organisationId`. Both are attachment tables reachable
   by identifier.
3. The e2e job cannot fail the pipeline, so its green colour means nothing.

## The brief, one message, six questions

Only what the repository could not answer:

```
1 Is staging safe to write to, and is its database a copy of production?
2 Which accounts and roles do we have, and in how many organisations?
3 Which three flows would you call an incident if they broke on Friday?
4 Is the mail provider on staging pointed at a sandbox, or does it send?
5 Do we have authorisation to test authorization boundaries between two
  organisations we control, including direct API calls?
6 May we fix what we find, or only report it?
```

Answers: staging is writable, database anonymised, two organisations with all
four roles, critical flows are signup with invitation, subscription upgrade
and CSV export, mail goes to a sandbox, security testing authorised on staging
only and limited to accounts we own, fixes allowed for high and critical.

## Contract, condensed

```
Scope in      web app and API on staging, commit 8f21c04
Scope out     production, the marketing site, the mail provider itself
Critical      invitation signup, subscription upgrade, CSV export
Disciplines   testing-quality, api-testing, playwright-automation,
              exploratory-testing, bug-hunting, accessibility-testing,
              security-testing, reliability-testing, regression-testing,
              test-reporting
Dropped       performance-engineering: no stated threshold and no reported
              symptom. Measured values reported, no optimisation work.
Forbidden     production, load generation, deleting shared organisations,
              testing any tenant not created by this campaign
Security      staging host only, two organisations owned by the campaign,
              no destructive scenario, authorised by the head of engineering
Deliverables  report with evidence, tests committed, continuity notes
```

## What the campaign found, in order of discovery

```
api-testing          attachments endpoint accepted any attachmentId and
                     returned the file, no tenancy check. Critical.
security-testing      confirmed cross organisation read with two accounts we
                     own. Same defect, one endpoint, two ways in.
exploratory-testing   upgrading a subscription while a second tab held the old
                     plan produced two active subscriptions.
bug-hunting           double click on Export produced two CSV jobs and two
                     mails. No idempotency key.
accessibility-testing invitation dialog trapped focus but never returned it to
                     the trigger, and the role select had no label.
reliability-testing   with the mail provider stubbed to time out, the
                     invitation was created and the UI reported failure. The
                     user retried and produced a duplicate invitation.
playwright-automation the three critical journeys pass, including the states
                     they traverse.
```

The single most important line is the first, and it was found by reading the
route file, not by clicking. Discovery said the API was the least covered
surface, and the campaign started there.

## Fixes, then regression

Critical and high fixed under the contract: tenancy check on attachments,
idempotency key on export, transactional invitation with a real failure path.
Each fix got a failing test first. Regression was run on the tenancy layer,
the export flow and the invitation flow, not on the whole suite twice.

## Verdict

```
Status: PASS WITH WARNINGS

Critical  1 found, 1 fixed, regression green
High      3 found, 3 fixed
Medium    4 found, 2 fixed, 2 accepted for next sprint, named
Low       6 reported

Not covered
  performance: no thresholds exist. Measured LCP 2.9s on the dashboard,
  reported, not treated as a defect.
  cross browser: Safari not exercised, no macOS runner available. Stated
  rather than implied.
  the two attachment tables still lack organisationId. The endpoint is fixed;
  the schema gap remains and is recorded as a risk.
```

The warning list is the point. A report that had said `all good` would have
shipped a schema with two untenanted tables and no one would have known.
