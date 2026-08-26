---
name: incident-response
description: Runs a production incident from detection to prevention: severity and roles, communication on a rhythm, stopping the bleeding before understanding the cause, safe diagnosis under pressure, mitigation and recovery, verification that it is genuinely over, a blameless postmortem with a timeline, and action items that are scheduled rather than admired. Use the moment production is degraded, and afterwards to write it up.
license: MIT
metadata:
  category: devops-skills
  version: 1.0.0
  depends_on: [devops-core, observability, production-verification]
  outputs: [incident-record, timeline, mitigation-log, postmortem, action-items]
---

# Incident Response

During an incident the goal is to restore service, not to be right. Diagnosis
is a means; the customer's experience is the objective.

Afterwards the goal reverses: understanding is everything, and blame is the
fastest way to lose it.

## 1. Declare early

An undeclared incident is handled by one person guessing in silence.

```
declare when: customers are affected, data may be at risk, or a critical
  path is degraded, and nobody is certain it is not spreading
declaring is cheap, and it is reversible
the person who notices declares. Seniority is irrelevant at this step.
```

## 2. Severity

| Level | Meaning | Response |
|---|---|---|
| 1 | complete outage, data loss risk, security breach | everyone needed, immediately, at any hour |
| 2 | a critical path broken for many users, no workaround | immediate, during and outside hours |
| 3 | degraded, or broken for a subset with a workaround | during hours, prioritised over feature work |
| 4 | minor, visible, not urgent | normal queue |

Severity can be raised at any time and is never lowered to reduce noise.

## 3. Roles

Even with two people, name them:

```
incident lead   decides, sequences, and does not debug
communicator    writes updates on a rhythm, internal and external
operator        makes the changes, one hand on the system
scribe          records the timeline as it happens, with timestamps
```

The lead does not type. The moment the lead starts debugging, nobody is
holding the whole picture, and that is when a second incident is created by
the response.

## 4. Communication rhythm

```
first update within minutes of declaring, even with nothing to say
then on a fixed interval: 15 or 30 minutes, kept even when nothing changed
each update: what is affected, what we know, what we are doing, next update
never speculate about cause in an external message
never promise a resolution time before mitigation is understood
state clearly when it is resolved, and what customers should do
```

`We are investigating, next update at 14:30` is a complete update, and it
costs nothing to send.

## 5. Stop the bleeding first

Mitigation precedes understanding.

```
roll back the recent change, even if it is not proven to be the cause
disable the feature behind its flag
shed load, or restrict to the critical path
fail over, scale up, drain the bad node
put up a maintenance page rather than serve corrupted data
stop a job that is making it worse, especially one writing data
```

The one exception: when the fastest mitigation would destroy the evidence
needed to prevent recurrence, capture the evidence first, briefly, and then
mitigate. Snapshots, a heap dump, a copy of the logs, thirty seconds.

## 6. Diagnosis under pressure

```
what changed: deployments, configuration, flags, migrations, provider status,
  certificates, quotas, and traffic. Most incidents are a change.
when exactly did it start, and what was released nearest that time
is it all users or a subset: a region, a plan, a tenant, a client version
which signal moved first, from the dashboards, not from memory
one hypothesis at a time, tested, and stated as a hypothesis
one change at a time to the system, announced before it is made
```

Two people changing the system independently is how a severity 3 becomes a
severity 1.

## 7. Data incidents

When data may be corrupted or lost:

```
stop the writes before anything else
do not repair in place before understanding the extent
quantify: how many records, over what period, which fields
preserve a copy of the current state before any correction
restore from a backup only after verifying what the backup contains
reconcile rather than overwrite where both sides have real data
tell the truth about what was lost
```

## 8. Personal data breach

Treat as severity 1 regardless of volume, and follow the notification
obligations, which have deadlines measured in hours.

```
contain access, preserve evidence, do not tamper with logs
determine what data, whose, how much, and for how long it was exposed
involve whoever owns legal notification immediately: engineering does not
  decide whether to notify
rotate every credential that could have been exposed
document every step, since the record will be examined
```

`security-testing` and `secrets-management` hold the technical procedures;
this skill holds the sequencing.

## 9. Resolution and verification

Resolved means verified, not deployed.

```
the failing signal has returned to normal, and stayed there
the critical journeys are exercised against production
queues, jobs and backlogs have drained
data written during the incident is correct, or the correction is scheduled
customers who saw errors are handled: retries, refunds, notifications
the temporary mitigations are recorded, with owners, because a flag disabled
  at three in the morning is forgotten by Monday
```

## 10. Postmortem

Within days, while memory is accurate. Blameless, which is not politeness: an
account that names a person stops being accurate, because the next person
learns to describe less.

```
summary       what happened, in three sentences, in plain language
impact        who, how many, how long, what they experienced, what it cost
timeline      timestamped, from the first signal to verification, including
              what people believed at each point and why
detection     how it was found, and how long that took
what went     the parts of the response that worked, named
  well
contributing  the several conditions that combined. There is rarely one
  factors      cause, and `human error` is never one: it is a system that
               permitted an error
lessons       what this taught us about the system
actions       specific, owned, dated, and sized to actually happen
```

## 11. Action items

```
each has an owner and a date, and enters the normal work queue
prefer one action that removes the class over five that patch the instance
an action nobody will do is not written down as if it will be
prevention, detection and response are three different kinds: an incident
  that took two hours to notice needs a detection action, not only a fix
review the previous incidents' actions when writing new ones: the same
  unimplemented action appearing twice is the finding
```

## 12. Prohibitions

- Never debug before mitigating, unless mitigation destroys the evidence.
- Never make two changes at once during an incident.
- Never communicate a cause before it is established.
- Never lower a severity to reduce noise.
- Never repair data in place before quantifying the damage.
- Never write a postmortem that names an individual as a cause.
- Never close an incident with temporary mitigations still active and
  unrecorded.
- Never let action items live only in the postmortem document.

## 13. Protocol

1. Declare, and set a severity.
2. Name the lead, the communicator, the operator and the scribe.
3. Send the first update, and set the next update time.
4. Mitigate: roll back, disable, shed, fail over, stop.
5. Capture evidence if mitigation would destroy it.
6. Diagnose: what changed, when, who is affected, which signal moved first.
7. One change at a time, announced, recorded by the scribe.
8. Verify recovery against production, not against a dashboard alone.
9. Handle the affected customers and the data written during the incident.
10. Record temporary mitigations with owners.
11. Write the postmortem within days, blameless, with a real timeline.
12. Put the action items into the normal queue with owners and dates.

## 14. Auto-critique

Score from 0 to 5: declared promptly, roles named, communication on a rhythm,
mitigation before diagnosis, one change at a time, evidence preserved,
verification against production, temporary mitigations recorded, postmortem
timeline accuracy, actions owned and scheduled.

Threshold: no axis below 3, average at least 4. An incident closed with an
undocumented temporary mitigation still in place, or a postmortem attributing
the cause to a person, fails regardless of how fast service was restored.

## 15. Interfaces

- Upstream: `observability` for detection and signals, `devops-core` for the
  blast radius rules, `deployment-engineering` for the rollback path.
- Lateral: `debugging` for root cause once service is restored,
  `database-operations` and `backup-recovery` for data incidents,
  `secrets-management` for credential exposure, `security-testing` for a
  suspected compromise.
- Downstream: `technical-debt` and `delivery-planning` for the action items,
  `technical-documentation` for the runbook this incident should have had,
  `project-continuity` for the record.
