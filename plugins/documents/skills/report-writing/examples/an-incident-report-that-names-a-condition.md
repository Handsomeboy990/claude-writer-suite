# An incident report that names a condition, not a person

A four hour checkout outage. Two versions of the same report.

## The version that was nearly sent

```markdown
## Cause

An engineer deployed a configuration change on Friday afternoon without
following the deployment checklist. The change set the database connection
pool to 5 instead of 50. This caused connection exhaustion under normal
traffic. Human error.

## Actions

1. Remind the team to follow the deployment checklist.
2. Add a warning to the checklist about connection pool settings.
```

Everything in it is true, and the report is worthless.

Section 5 rejects it on two counts: the cause is a person, and `human error`
is where the analysis stopped rather than what it found. Section 8 makes both
an automatic failure.

The consequences are practical. The two actions prevent nothing. A reminder
decays in a fortnight, and the next person to make this mistake will conceal
it, because the last one was named in a document.

## The questions that continued the analysis

```
What made the error possible?      Why could one typo reach production at all?
What made it undetected?           Why did nobody see it for four hours?
What made it unrecoverable fast?   Why did the fix take 47 minutes once found?
```

Three questions, five conditions, none of them a person.

## The version that was sent

```markdown
# Incident INC-2026-014, 2026-07-24

## Summary

Checkout was unavailable or severely degraded for 4 hours 12 minutes on 24
July, from 14:03 to 18:15 UTC. An estimated 3,200 checkout attempts failed.
No data was lost. Payments already authorised were unaffected. Service is
restored and the condition that allowed it is fixed.

| Item | Value |
|---|---|
| Detected | 14:41 UTC, by a customer email to support |
| Mitigated | 17:28 UTC, connection pool restored |
| Resolved | 18:15 UTC, queue drained |
| Duration of impact | 4h 12m |
| Checkouts failed | 3,200, counted from 5xx responses on POST /checkout |
| Data lost | none |

## Timeline

| Time | Event | Source |
|---|---|---|
| 13:58 | Configuration change merged, one line, pool size 50 to 5 | git log |
| 14:03 | Deployed automatically on merge | pipeline log |
| 14:05 | Connection wait times rise; no alert exists on this metric | metrics |
| 14:41 | Customer email reaches support | ticket 88214 |
| 15:20 | Support escalates after four more reports | ticket queue |
| 15:35 | Engineer begins investigation, starts from application logs | chat |
| 17:05 | Cause identified after comparing deployed config to previous | chat |
| 17:28 | Change reverted, pool restored, checkout recovers | pipeline log |
| 18:15 | Backlogged jobs drained, fully normal | metrics |

## Impact

3,200 failed checkout attempts, counted from 5xx responses on POST /checkout
between 14:03 and 17:28. Revenue impact is estimated, not measured: applying
the trailing four week conversion rate gives roughly 41,000 euro of
uncompleted orders, an unknown share of which returned later.

No payment was taken without an order. No order was created without a payment.
Both verified by reconciling the provider against the orders table for the
window.

## Cause

The database connection pool was reduced from 50 to 5 by a configuration
change. Under normal traffic, checkout requests exhausted the pool and blocked
on connection acquisition until they timed out.

The change reached production because five conditions held at once:

1. Connection pool size is a plain integer in a configuration file with no
   validated range. A value of 5 is as acceptable to the system as 50.
2. The deployment pipeline has no smoke test on checkout. It verifies that the
   service starts, which it did.
3. No alert exists on connection pool saturation or acquisition wait time. The
   metric was recorded throughout and nobody was told.
4. The 5xx rate alert is configured at 25 percent over 15 minutes. Checkout is
   8 percent of total traffic, so a complete checkout failure produces
   8 percent and never fires.
5. Configuration changes are not visible in the deployment notification, which
   lists application version only. The investigating engineer had no reason to
   suspect configuration and spent 90 minutes in application logs.

Any one of the five would have contained this. Condition 4 is the most
serious: the alerting threshold makes a total failure of any subsystem under
a quarter of traffic invisible by design.

## Detection

Detected by a customer, 38 minutes after impact began, and escalated 39
minutes after that. Nothing automated fired at any point. The metric that
would have shown it was being recorded the whole time.

## Response

Worked: the revert path was fast and clean once the cause was known.

Did not work: 90 minutes were spent in application logs because configuration
changes are invisible in the deployment record. The engineer was looking in
the correct place for the information available to them.

Missing: a way to diff deployed configuration against the previous
deployment. It was reconstructed by hand from git history.

## Actions

| # | Action | Prevents | Owner | By | Status |
|---|---|---|---|---|---|
| 1 | Validate pool size on startup, range 10 to 200, refuse to start outside it | condition 1 | Platform | 2026-08-07 | done |
| 2 | Alert on pool saturation above 80 percent for 2 minutes | condition 3 | Platform | 2026-08-07 | done |
| 3 | Per-route error rate alerts, replacing the global threshold | condition 4 | Platform | 2026-08-21 | in progress |
| 4 | Checkout smoke test in the deployment pipeline, blocking | condition 2 | Delivery | 2026-08-21 | in progress |
| 5 | Configuration diff in the deployment notification | condition 5, and detection time | Platform | 2026-09-04 | planned |
| 6 | Review all alert thresholds expressed as a share of total traffic | condition 4, generalised | Platform | 2026-09-04 | planned |

Action 6 exists because condition 4 is not specific to checkout. Every
subsystem below a quarter of traffic has the same blind spot today.
```

## What the rewrite changed

| Version 1 | Version 2 |
|---|---|
| Cause: a person and a checklist | Cause: five system conditions, each independently sufficient |
| 2 actions, both reminders | 6 actions, each mapped to a named condition |
| Nothing measurable | Every figure counted or explicitly labelled as an estimate |
| Detection unexamined | Detection is a finding: 38 minutes, by a customer, nothing fired |
| Would recur | Conditions 1 to 4 closed within four weeks |
| Discourages reporting | Names no individual |

The engineer who made the change is not in the report. Their name adds nothing
a reader can act on, and its absence is what makes the next person willing to
say *I think I just broke something* at 14:04 instead of 14:41.

## Gate record

```
Document: Incident report INC-2026-014, v1, English
Audience: engineering leadership plus operations; forwarded to the client
1 Content     pass  every timestamp from a log, revenue explicitly an estimate
2 Structure   pass  summary standalone, cause before actions
3 Language    pass  no blame language, no softening of the duration
4 Formatting  pass
5 Audience    pass  no code, no stack traces; annexed instead
6 Consistency pass  UTC throughout, one time zone
7 Requirement pass
8 Self critique  pass  incident responder, operations engineer, executive, client
Gaps remaining: revenue impact is an estimate; finance owns the measured figure
```

The client role in the panel produced one change: the original summary opened
with the technical cause. A client reading four hours of downtime needs to
know first whether they lost data or money. That moved to sentence three and
four, before any mention of a connection pool.
