# Example: three months of green backup jobs

The handover document said: nightly automated backups, 30 day retention,
encrypted, stored off site.

Every statement was true. The system was not recoverable.

## What the first rehearsal found

The rehearsal was scheduled because `client-handover` had recorded a
limitation: backups existed, a restore had never been performed.

```
14:00  decision to restore, clock starts
14:04  located the backup listing
       most recent entry: 2026-05-09
       today: 2026-08-11
```

Three months of nothing. The backup job had been running nightly and
succeeding, and writing to a bucket whose lifecycle policy deleted objects
after seven days. The retention setting on the backup tool said thirty days;
the bucket policy said seven; and a separate change in May had reduced it
further while nobody was watching.

The job reported success every night, because writing the object succeeded.
Nothing checked that the object still existed the next morning.

## Continuing the rehearsal on the May backup

Because the exercise was already under way, it continued against the oldest
available backup.

```
14:22  restore started
14:41  restore completed, database up
14:44  application pointed at it, started, serving

Verification
  orders        212,006 rows, against 338,204 in production
                consistent with a three month old backup
  uploads       empty
                the policy covered the database only
  sequences     correct
  referential   no orphans
```

The uploads line is the second discovery. Every uploaded course material,
every generated attestation stored as a file, and every user avatar was
outside the backup policy. A restore would have produced a system with
complete records pointing at files that no longer existed.

## Third discovery, during the same afternoon

```
15:10  attempted to verify the encryption key
       the backup objects are encrypted with a key managed by the backup tool
       the tool's key is stored in the tool's own account
       that account's credentials are in the same password manager entry as
       the production database credentials
```

The disaster scenario the off site backup existed for is account compromise.
In that scenario, the attacker holds the key to the backups.

## What was changed

```
1  Bucket lifecycle policy corrected to 35 days, and a check added: a daily
   job lists the backup objects and alerts when the newest is older than 26
   hours or the count is below 30.
   This is the check whose absence made three months invisible.

2  Object storage added to the backup policy. Uploads are now replicated to a
   second bucket in a different region, versioned, with the same retention.

3  Encryption key moved to a key management service in a separate account,
   with access granted to two named people and a break glass path.

4  The restore procedure rewritten with the corrected console paths and the
   commands as they actually behave in the current tool version.

5  A quarterly rehearsal scheduled, with an ephemeral environment defined in
   the repository so provisioning is not part of the recovery time.
```

## The second rehearsal, six weeks later

```
Decision at:   10:00
Serving at:    11:12
Measured RTO:  1h12
Target RTO:    4h                                   met

Backup used:   previous night, 03:00
orders         341,908 rows, matches production at 03:00
uploads        sample of 20 files, all present, checksums match
sequences      correct
newest record  02:58

Problems found
1 the restored application needed PUBLIC_APP_URL, which was absent from the
  ephemeral environment definition. Five minutes, corrected.
```

One minor problem instead of three fundamental ones.

## What the honest handover line looked like, before and after

```
Before, in the handover
  L5  backup restore never tested; recovery time unknown
      Trigger: before the platform holds attestations that exist nowhere else

After
  Backups: nightly database, continuous object replication, 35 day retention,
  encrypted with a key held in a separate account. Restore rehearsed
  2026-09-22, measured recovery 1h12 against a 4h objective. Next rehearsal
  scheduled. Procedure: docs/runbook.md, restore.
```

The first version is what made the rehearsal happen. Writing `backups are in
place` instead would have been true, reassuring, and would have left the
system unrecoverable for a further quarter.

## The general lesson

Three separate mechanisms all reported health: the backup job succeeded, the
retention setting said thirty days, and the handover said backups were in
place. None of them checked the only thing that matters, which is whether a
usable backup exists right now and whether restoring it produces a working
system.

Only the rehearsal checks that.
