---
name: production-verification
description: Proves that a deployed system actually works, by exercising it. Checks availability, version, authentication, critical journeys, data connectivity, assets, configuration, headers, logs and errors against the running deployment. A successful deploy command is not a verified deployment.
license: MIT
metadata:
  category: devops-skills
  version: 1.0.0
  depends_on: [engineering-core, devops-core, deployment-engineering, observability]
  outputs: [verification-report, smoke-results, rollback-decision]
---

# Production Verification

The deploy command exiting zero means an artefact moved. It says nothing about
whether the system works.

This skill exercises the deployed system and produces evidence.

## 1. The rule

Nothing is reported as deployed until a real request has been served
correctly by the deployed version.

```
Not verification   the deploy tool reported success
Not verification   the process is running
Not verification   the health check passes
Verification       a request that exercises the change returned what it
                   should, from the version that was just deployed
```

The health check is a precondition, not the proof. A system can pass a
database ping and fail every business path.

## 2. The checks

Ordered so a failure stops early.

### 1. Availability

The application answers on its public address, over the expected protocol,
with a valid certificate where TLS applies.

### 2. Version

The version endpoint reports the commit that was deployed. This is the check
that catches a deployment which appeared to succeed and left the previous
version serving, which happens more often than teams expect.

### 3. Health

Liveness and readiness both pass, on every instance where the platform exposes
them individually.

### 4. Authentication

Sign in works. A wrong password fails correctly. A session persists across a
request. Sign out invalidates.

### 5. Authorization

One negative check, at minimum: a caller without rights receives a refusal
rather than data. This is cheap and it is the check that catches a misdeployed
configuration that disabled a guard.

### 6. Critical journeys

The two or three paths whose failure is an incident, exercised end to end
against production, with data that is safe to create.

### 7. Data connectivity

A read returns real data. A write persists and survives a re-read. Where the
change touched the schema, the new shape is present.

### 8. External services

Each integration answers, or its degraded path behaves as designed. Where
exercising it costs money or sends a message, use the provider's test facility
or verify at the boundary.

### 9. Assets and rendering

Static assets load, with the expected cache headers. A page renders rather
than showing an application error. Where a client bundle changed, the new one
is being served.

### 10. Configuration

The environment reports the variables it should have, without values. Feature
flags are in their intended state.

### 11. Security headers

The headers the architecture specified are present on a real response, not
only in the configuration file.

### 12. Logs and errors

The deployment produced log lines. No new error class appeared. The error
reporter shows nothing new attributable to this release.

### 13. Performance

Latency on a critical path is within the expected range. A change that made
the system correct and four times slower is not a successful deployment.

## 3. Safe data in production

Verification writes to a real system. Use data that is unambiguous and
disposable.

```
Reserved domains for addresses, never a real person's
An obvious marker in names, so the row is identifiable
A cleanup step, and a record of what was created
Never a real payment; use the provider's test mode or a boundary check
Never a message to a real recipient
```

## 4. The watch window

Verification does not end when the checks pass. Watch for a stated period,
with a threshold decided in advance.

```
Duration    from the deployment plan, typically 15 to 60 minutes
Signals     error rate, latency, the domain metric, the queue depth
Threshold   the number that means roll back, decided before deploying
```

A threshold decided during an incident is decided badly.

## 5. Rollback decision

```
Roll back when   a check in section 2 fails and the cause is not immediately
                 fixable, or a watch signal crosses its threshold
Fix forward when the cause is understood, the fix is small, and the pipeline
                 can deliver it faster than a rollback
Never            leave a failing deployment in place while investigating,
                 unless rolling back is worse and that is stated
```

The decision is made against the thresholds, not against how close the fix
feels.

## 6. Report

```
Deployment    version, environment, time
1  Availability   pass, 200 from https://..., certificate valid to <date>
2  Version        pass, /version reports a91f0c2, the deployed commit
3  Health         pass, 4 of 4 instances ready
4  Authentication pass, sign in and sign out verified
5  Authorization  pass, non member received 403 on a team resource
6  Journeys       pass, invite and accept completed, test data removed
7  Data           pass, write persisted and survived a re-read
8  External       pass, provider test mode charge succeeded
9  Assets         pass, new bundle served, cache headers correct
10 Configuration  pass, 12 of 12 required variables present
11 Headers        pass, CSP, HSTS, frame ancestors, nosniff present
12 Logs           pass, no new error class in 20 minutes
13 Performance    pass, p95 on the dashboard 1.5s, within the 2s budget
Watch             30 minutes, error rate 0.1 percent, threshold 1 percent
Verdict           verified
Created           2 test rows, removed at 15:12
```

## 7. Prohibitions

- Never report a deployment as successful without exercising it.
- Never verify against staging and describe it as production verification.
- Never use a real customer's data or address for a smoke test.
- Never skip the version check; it is the cheapest and it catches the
  deployment that silently did nothing.
- Never leave test data behind without recording it.
- Never decide a rollback threshold after the deployment.

## 8. Protocol

1. Confirm the deployment completed and the version endpoint agrees.
2. Run the checks of section 2, in order.
3. Use safe data, section 3, and clean up.
4. Watch for the stated window, section 4.
5. Decide per section 5 on any failure.
6. Produce the report, section 6.
7. Record the deployment outcome with `deployment-engineering`.

## 9. Auto-critique

Score from 0 to 5: real requests made against the real deployment, version
verified, at least one negative authorization check, critical journeys
exercised, safe data used and cleaned up, watch window observed with a
threshold set beforehand, report evidence based, honest verdict.

Threshold: no axis below 3, average at least 4. Reporting a deployment as
verified without having exercised a business path is an automatic failure.

## 10. Interfaces

- Upstream: `deployment-engineering`, `observability`.
- Lateral: `playwright-automation` for scripted journeys,
  `security-audit` for the header check.
- Downstream: `release-engineering`, `release-readiness` gate 9,
  `project-continuity`.
