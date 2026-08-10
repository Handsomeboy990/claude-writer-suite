---
name: backup-recovery
description: Treats a backup as untested until a restore has been performed. Covers what to back up, frequency and retention against stated objectives, restore rehearsal, the restore procedure itself, and honest reporting when rehearsal is impossible.
license: MIT
metadata:
  category: devops-skills
  version: 1.0.0
  depends_on: [engineering-core, devops-core, database-operations]
  outputs: [backup-policy, restore-procedure, rehearsal-record, recovery-objectives]
---

# Backup and Recovery

A backup that has never been restored is a hypothesis. The only evidence that
a system can be recovered is that it has been.

## 1. The two objectives

Both are stated as numbers before any policy is written. Without them,
frequency and retention are arbitrary.

```
RPO  recovery point objective
     how much data the project can afford to lose, in time
     drives backup frequency

RTO  recovery time objective
     how long the project can afford to be down while recovering
     drives the restore mechanism and the rehearsal
```

An internal tool may honestly answer twenty four hours and four hours. A
payment system answering the same numbers has not thought about it. The
answers come from the client, not from the engineer.

## 2. What is backed up

Enumerate. A backup covering the database and nothing else recovers a system
that cannot serve a single uploaded file.

```
Database          the primary case
Object storage    uploaded files, generated documents
Configuration     the environment variable inventory, without values
Secrets           in the secret store's own backup, never alongside the data
Infrastructure    the definitions, which live in the repository
Code              the repository, plus its remote
Third party state what lives only in a provider's system, and cannot be
                  recovered from your side
```

The last line is the one that is discovered during an incident. Anything that
exists only in a provider account is not covered by your backups, and that
fact belongs in the policy rather than in the incident review.

## 3. Policy

```
| Asset | Method | Frequency | Retention | Location | Encrypted |
|---|---|---|---|---|---|
```

Rules:

- Frequency satisfies the RPO, with margin.
- Retention covers the time it takes to notice a slow corruption, which is
  longer than most teams assume.
- Location is separate from production. A backup in the same account, region
  and credentials as the thing it protects fails the case it exists for.
- Encrypted at rest, with the key not stored beside the backup.
- Backups are monitored: a job that stops running silently is the normal
  failure mode.

## 4. Restore rehearsal

The core of this skill. Performed on a schedule, and at least once before the
system holds data that exists nowhere else.

```
1  Take a real backup, not a specially prepared one
2  Restore it into an isolated environment
3  Measure the time from decision to a working system
4  Verify the data: row counts, a sample of records, referential integrity
5  Verify the application runs against the restored data
6  Record the measured RTO against the target
7  Record what was missing, and fix the policy
```

Rehearsals routinely discover: the backup covers the database and not the
files, the retention window is shorter than believed, the restore needs a
credential nobody has, the measured time is several times the target, or the
backups have been failing silently for weeks.

None of these is discoverable from a backup configuration screen.

## 5. Restore procedure

Written before it is needed, imperative, executable under pressure.

```
Decide        the criteria for restoring rather than repairing
Announce      who is told, and when
Isolate       stop writes to the damaged system where possible
Preserve      snapshot the current damaged state before overwriting it
Restore       the exact commands, in order
Verify        row counts, a sample, referential integrity, the application
Reconcile     what happened between the backup and the incident, and what
              becomes of it
Resume        traffic, and confirm
Record        what was lost, precisely
```

The `Preserve` step is the one omitted under pressure and the one that makes
the restore itself reversible. Restoring over a damaged database destroys the
evidence of what went wrong and any data written since the backup.

## 6. Data loss reporting

After any restore, state precisely what was lost.

```
Backup taken:  timestamp
Incident at:   timestamp
Window:        the duration
Lost:          what was written in the window, counted where possible
Recoverable:   what can be reconstructed from another source, and how
Unrecoverable: what cannot, stated plainly
```

`Some recent data may have been lost` is not a report. The client needs to
know whether to contact anyone.

## 7. When rehearsal is impossible

Say so, precisely, rather than implying a capability that has not been shown.

```
Unknown: recovery time for the production database.
Missing: the staging environment cannot host a restore of production volume,
and no isolated environment exists.
Consequence: the RTO of 4 hours is a target, not a measured figure. The
restore procedure is written and reviewed, and untested.
Recommended: a quarterly rehearsal in an ephemeral environment, roughly a day
of work to set up.
```

This is an honest and useful statement. `Backups are in place` in the same
situation is neither.

## 8. Protocol

1. Obtain the RPO and RTO from the client, as numbers.
2. Enumerate the assets, section 2, including what lives only at a provider.
3. Write the policy, section 3, satisfying the objectives.
4. Confirm backups run and are monitored.
5. Write the restore procedure, section 5.
6. Rehearse, section 4, and measure.
7. Record the rehearsal, or the reason it was impossible, section 7.
8. Re-rehearse on the schedule, and after any change to the data model or the
   infrastructure.

## 9. Auto-critique

Score from 0 to 5: objectives obtained as numbers, assets enumerated
completely, policy satisfying the objectives, location genuinely separate,
backup monitoring in place, restore procedure written before it is needed,
rehearsal performed and measured, honest reporting when it was not.

Threshold: no axis below 3, average at least 4. Reporting that backups are in
place without a rehearsal, or without stating that none has been performed, is
an automatic failure.

## 10. Interfaces

- Upstream: `devops-core`, `database-operations`,
  the DevOps section of the architecture document, produced by
  `architecture-proposal`.
- Lateral: `secrets-management` for the backup credentials and encryption
  key, `observability` for backup job monitoring.
- Downstream: `release-readiness` gate 5, `client-handover` for the restore
  procedure and the honest state of rehearsal.
