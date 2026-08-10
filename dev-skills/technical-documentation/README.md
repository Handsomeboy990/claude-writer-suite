# technical-documentation

Documentation written from the code, in the same change as the code. Defines
what to write for each kind of change, one audience per document, standards
for readme, setup guide, architecture note, API reference, runbook, decision
record and changelog, plus a verification pass that runs every command and
deletes stale content.

- Inputs: the change, the code it touches, the existing documentation.
- Outputs: readme, api reference, setup guide, runbook, decision record,
  changelog entry.
- Depends on: engineering-core, project-exploration.
- Downstream: project-continuity, release-readiness, git-workflow.

Wrong documentation is worse than none, because it is trusted. Nothing is
described that was not read in the code first.
