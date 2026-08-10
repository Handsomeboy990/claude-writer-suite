---
name: secrets-management
description: Owns the lifecycle of credentials: where secrets live, how they reach a process, how they are rotated, how a leak is handled, and how the repository and its history are proven clean. Use whenever a credential is created, consumed, rotated or suspected of exposure.
license: MIT
metadata:
  category: devops-skills
  version: 1.0.0
  depends_on: [engineering-core, devops-core, environment-management]
  outputs: [secret-inventory, rotation-procedures, leak-response, repository-scan]
---

# Secrets Management

A secret is any value that grants access. The rule that governs all of them:
a secret that has been exposed is compromised, and deletion does not undo
exposure.

## 1. What is a secret

```
Yes  passwords, API keys, tokens, private keys, certificates with their keys,
     connection strings containing credentials, signing secrets, webhook
     secrets, session secrets, encryption keys, service account files,
     OAuth client secrets, database credentials, SSH keys
No   bucket names, public URLs, public keys, client identifiers that are
     designed to be public, feature flags, log levels, timeouts
```

Marking non secrets as secret is not caution. It fills the secret store with
noise and makes the real ones harder to manage.

## 2. Where secrets live

Ordered by preference. Use the highest the project can support.

| Storage | When |
|---|---|
| a managed secret store | the platform provides one; the default answer |
| the platform's secret variable type | distinct from ordinary variables, not readable after being set |
| an encrypted file with a key held elsewhere | no platform secret support |
| a `.env` file, local only, never committed | development machines |

Never: in the repository, in the pipeline definition, in an image layer, in a
log, in a URL, in a client bundle, in a comment, in documentation, in an
issue, in a message thread, in a screenshot.

## 3. How a secret reaches a process

```
Preferred  injected as an environment variable by the platform at start
Also fine  mounted as a file the process reads at start, with restrictive
           permissions, outside the repository
Avoid      fetched at runtime on every use, unless the store is designed for
           it and the failure mode is handled
Never      baked into an image, committed, or passed on a command line where
           it appears in the process list
```

The command line case is easy to miss: a secret passed as an argument is
visible to every process on the machine.

## 4. Rotation

Every secret has a written rotation procedure before it is needed. A leak
response that begins by working out what will break is a leak response that
takes hours.

```
| Secret | Procedure | What restarts | User impact |
|---|---|---|---|
```

Two patterns:

**Overlap rotation**, when the provider supports two active credentials:
create the new one, set it, deploy, verify, revoke the old one. No downtime.

**Cut rotation**, when it does not: set the new one, deploy, and accept the
window. The window is stated in the procedure, and if it is user visible it is
announced.

The `SESSION_SECRET` case deserves its own line in every project: rotating it
invalidates every session, and that is a decision someone makes, not one they
discover.

Rotate on a schedule where the provider makes it cheap, and always after: a
suspected exposure, a person with access leaving, a compromised machine, or a
credential appearing anywhere it should not.

## 5. Leak response

Order matters. The first step is not deletion.

```
1  Rotate. Immediately. The exposed value is compromised whatever happens
   next, and rotation is what stops the exposure being useful.
2  Assess. What did it grant, for how long, and is there evidence of use.
   Check the provider's access logs before they roll off.
3  Contain. Revoke the old credential once the new one is confirmed working.
4  Remove. Take it out of the code, the history, the logs, wherever it is.
5  Prevent. Why did it get there, and what stops the next one.
6  Record. What leaked, when, what was done, what remains uncertain.
```

Removing a secret from git history does not make it safe. The repository may
have been cloned, forked, mirrored, cached by a platform, or indexed. Assume
the value is public from the moment it was pushed.

A secret committed and not yet pushed is a different case: amend it out, and
still rotate if there is any doubt about whether it left the machine.

## 6. Repository scanning

Run over the working tree, the diff, and the history.

```
Working tree  before every commit, on the staged diff
History       once, when the practice is introduced, and after any suspicion
Continuous    a scanner in the pipeline, where the project supports one
```

Patterns worth searching: provider key prefixes, private key headers,
connection strings with credentials, high entropy strings assigned to names
containing `key`, `secret`, `token` or `password`, and any file matching the
ignore patterns that is nonetheless tracked.

A scan that finds nothing is evidence, not proof. It is recorded as a scan
with its date and its patterns.

## 7. Access

- Give the narrowest scope the task needs. A key that can read one bucket is
  not a key that can delete the account.
- Prefer per environment credentials. A staging key that also works in
  production removes the isolation the environments exist to provide.
- Prefer per service credentials, so revoking one does not stop everything.
- Keep a list of who and what holds access to each secret, and revisit it when
  someone leaves.

## 8. Protocol

1. Classify every value: secret or not, section 1.
2. Choose the storage for each, section 2.
3. Verify the injection path, section 3.
4. Write the rotation procedure for each, section 4.
5. Scan the working tree and the history, section 6.
6. Add a scanner to the pipeline where possible.
7. On any suspected exposure, run section 5 starting with rotation.
8. Record the secret inventory alongside the variable inventory, without
   values.

## 9. Prohibitions

- Never write a real secret into any tracked file, including an example file.
- Never write a secret into documentation, an issue, or a message.
- Never log a secret, including a prefix or a masked form.
- Never send a secret through a channel the recipient did not ask for.
- Never respond to a leak by deleting without rotating.
- Never treat a test or sandbox credential as harmless; it is still a
  credential and it identifies an account.
- Never reuse one credential across environments.

## 10. Auto-critique

Score from 0 to 5: correct classification, appropriate storage, safe injection
path, rotation procedure written before it was needed, scans performed and
recorded, leak response starting with rotation, access scoped narrowly, no
value anywhere.

Threshold: no axis below 3, average at least 4. A real secret found in the
repository, or a leak response that deleted without rotating, is an automatic
failure.

## 11. Interfaces

- Upstream: `devops-core`, `environment-management`.
- Lateral: `security-audit` points 17 and 18, `git-workflow` for the staged
  diff scan, `containerization` and `ci-cd-pipelines` for injection.
- Downstream: `deployment-engineering`, `client-handover` for the rotation
  table.
