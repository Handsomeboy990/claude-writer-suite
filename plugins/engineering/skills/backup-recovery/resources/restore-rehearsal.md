# Restore rehearsal

The exercise that turns a backup configuration into evidence.

## Preparation

```
Use a real backup, taken by the normal schedule, not one prepared for the
rehearsal. A specially taken backup tests a path nobody uses in an incident.

Restore into an isolated environment. Never into staging if staging is used
for anything, and never into anything sharing credentials with production.

Start the clock at the moment of the decision to restore, not at the moment
the command runs. Finding the backup, obtaining the credential and reading
the procedure are part of the recovery time.
```

## The exercise

```
1  Note the time. This is T0.
2  Locate the most recent backup. Note its timestamp.
3  Provision the target environment.
4  Restore the database.
5  Restore the object storage, if the policy covers it.
6  Point an application instance at the restored data.
7  Start it and confirm it serves.
8  Verify the data, section below.
9  Note the time. T1 minus T0 is the measured RTO.
10 Destroy the environment.
11 Record everything, including what went wrong.
```

## Data verification

Counting rows is necessary and not sufficient.

```
Row counts        per major table, compared against the production figures at
                  the backup timestamp
Sample records    a handful, read in full, checked against what they should
                  contain
Referential       no orphaned rows: children whose parents are absent
Recent boundary   the newest record in the restore, compared against the
                  backup timestamp; a gap means the backup is older than it
                  claims
Files             a sample of uploaded files opens and matches its record
Sequences         auto increment sequences are at the right position; a
                  restore that resets them produces primary key collisions on
                  the first write
```

The sequences line is the one that is discovered by the application failing
minutes after a restore that looked perfect.

## Rehearsal record

```markdown
# Restore rehearsal, <date>

Backup used:      <timestamp>, taken by the nightly schedule
Target:           ephemeral environment, isolated credentials
Decision at:      14:00
Serving at:       15:47
Measured RTO:     1h47
Target RTO:       4h                                        met

Data verification
  orders           338,204 rows, matches production at the backup timestamp
  users             12,884 rows, matches
  uploads           sample of 10 files, all present and readable
  referential       no orphans found
  sequences         correct
  newest record     03:02, consistent with a 03:00 backup

Problems found
1 the object storage backup covered one bucket of two; user avatars were
  absent. Policy corrected, second bucket added.
2 the restore credential was held by one person, who was on leave. A break
  glass credential now exists in the secret store with documented access.
3 the documented restore command used an option removed in the current tool
  version. Procedure corrected.
4 32 minutes of the 1h47 were spent locating the backup, because the console
  path in the procedure was outdated. Corrected.

Consequence
  Without this rehearsal, a real incident would have taken longer than the
  4 hour target, would have recovered no avatars, and would have begun with
  a call to someone on leave.

Next rehearsal: <date, quarterly>
```

## What rehearsals typically find

Ranked by how often they appear:

```
1  the backup covers the database and not the uploaded files
2  the restore takes several times the target, mostly in preparation
3  the documented procedure is out of date with the tooling
4  the credential needed is held by one person
5  backups have been failing, and the failure was not monitored
6  retention is shorter than believed
7  the backup is encrypted with a key nobody can locate
8  sequences reset, causing collisions after the restore
9  the restored application needs a variable nobody documented
10 the backup is in the same account as production, and the incident scenario
   was account compromise
```

Items 1, 5 and 10 make the backup worthless for the case it exists for. None
of the three is visible without a rehearsal.

## Frequency

```
Before   the system holds data that exists nowhere else
Then     quarterly, or after any change to the data model, the storage layout
         or the infrastructure
Always   after a change to the backup tooling itself
```

## When it cannot be done

State it in exactly these terms, and propose the path:

```
Unknown: measured recovery time for the production database.
Missing: no environment can host a restore at production volume.
Consequence: the 4 hour RTO is a target, not a measurement. The procedure is
written and reviewed; it has never been executed.
Recommended: an ephemeral rehearsal environment, roughly one day of setup,
then quarterly rehearsals of about two hours.
```
