# release-engineering

Owns how a release happens: versioning scheme and the discipline of the major
bump, annotated immutable tags matching the artefact, a changelog written for
users rather than from commit subjects, rollout strategy chosen deliberately,
feature flags carrying removal conditions, a hotfix path that shortens review
but never testing, and a release record.

- Inputs: the approved revision, the changes, the platform.
- Outputs: version decision, release tag, changelog entry, rollout plan,
  hotfix procedure.
- Depends on: engineering-core, devops-core, git-workflow,
  deployment-engineering.
- Downstream: client-handover, project-continuity.

Distinct from release-readiness, which decides whether to ship at all. This
skill decides what the release is called and how it reaches users.
