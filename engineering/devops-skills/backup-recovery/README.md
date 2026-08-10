# backup-recovery

Treats a backup as untested until a restore has been performed. Obtains RPO
and RTO as numbers, enumerates every asset including what lives only at a
provider, writes the policy against the objectives, rehearses the restore and
measures it, and reports honestly when rehearsal is impossible.

- Inputs: the client's recovery objectives, the assets, the platform.
- Outputs: backup policy, restore procedure, rehearsal record, recovery
  objectives.
- Depends on: engineering-core, devops-core, database-operations.
- Downstream: release-readiness, client-handover.

Rehearsals routinely find that the backup omits uploaded files, that retention
is shorter than believed, or that the job has been failing silently. None of
that is visible from a configuration screen.
