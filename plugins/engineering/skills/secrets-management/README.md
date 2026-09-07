# secrets-management

Owns the credential lifecycle: what counts as a secret, where each one lives,
how it reaches a process, how it is rotated, how a leak is handled, and how
the repository and its history are proven clean.

- Inputs: the variable inventory, the platform, the repository and its
  history.
- Outputs: secret inventory, rotation procedures, leak response, repository
  scan.
- Depends on: engineering-core, devops-core, environment-management.
- Lateral: security-audit, git-workflow, containerization, ci-cd-pipelines.

The rule that governs everything here: an exposed secret is compromised, and
deletion does not undo exposure. Leak response starts with rotation, not with
removal.
