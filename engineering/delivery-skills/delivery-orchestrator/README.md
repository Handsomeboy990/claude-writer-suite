# delivery-orchestrator

Owns a project from specification to handover. Sequences fourteen phases,
holds the approval and verification gates, decides what may run in parallel,
applies change control when implementation contradicts the approved
architecture, and maintains the delivery checklist.

- Inputs: a specification, brief, PRD, feature list or client requirements.
- Outputs: phase plan, delivery checklist, gate decisions, delivery verdict.
- Depends on: engineering-core, engineering-orchestrator.
- Delegates: every implementation task to engineering-orchestrator, every
  operational task to the devops-skills family.

Two failure modes define the job: coding before the architecture is approved,
and asking permission for every file afterwards. Phases are sized to the
project, never skipped.
