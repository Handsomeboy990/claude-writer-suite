---
name: devops-core
description: Constitution of the operations family: the environment ladder, configuration that is never hardcoded, parity rules, the fail fast principle, blast radius classification and the destructive action protocol. Load before any environment, pipeline, deployment, database operation or production work.
license: MIT
metadata:
  category: devops-skills
  version: 1.0.0
  depends_on: [engineering-core]
  outputs: [environment-model, operational-rules, blast-radius-assessment]
---

# DevOps Core

Constitution of `devops-skills`. Every skill in the family inherits these
rules and never restates them. Where a family skill and this document
disagree, this document wins.

`engineering-core` governs how code is written. This governs how it runs, and
what happens when it does not.

## 1. The environment ladder

```
local        one developer's machine, disposable, real data never present
development  shared, unstable, safe to break, seeded data
test         ephemeral, created and destroyed by the pipeline
staging      production shaped, production configured, anonymised data
production   real users, real data, real money
```

Not every project has all five. A project with one server has `local` and
`production`, and saying so is better than pretending there is a staging.

Rules that hold whatever the ladder:

1. Every environment is created from the repository, not by hand.
2. An environment nobody can recreate is a liability, and it is named as one.
3. Changes flow up the ladder, never down. Nothing is fixed in production and
   backported later.
4. Real personal data never moves down the ladder. It is anonymised or
   generated.

## 2. Parity

Staging is useful only to the extent it resembles production. State the
differences rather than assuming there are none.

```
| Dimension | Staging | Production | Consequence of the gap |
|---|---|---|---|
| runtime version | | | |
| database engine and version | | | |
| instance count | | | |
| data volume | | | |
| external services | | | |
| TLS and domain | | | |
| secrets source | | | |
```

The two gaps that produce most surprises: instance count, because a single
instance hides every concurrency and shared state defect, and data volume,
because a hundred seeded rows hide every missing index.

## 3. Configuration

Configuration is what differs between environments. Everything else is code
and belongs in the repository.

Never hardcoded, in any file, at any layer:

secrets, tokens, keys, passwords, connection strings, production hostnames and
URLs, environment specific identifiers, provider account identifiers, bucket
names, queue names, per environment feature flags, email addresses that differ
by environment.

```
Code       identical in every environment
Config     differs by environment, injected, never committed
Secrets    config that is also sensitive, from a secret source, never a file
           in the repository
```

A value that is the same everywhere is not configuration. Making it
configurable adds a way to break production and buys nothing.

## 4. Fail fast

A process that starts without the configuration it needs will fail later, in a
worse place, in a way that looks like a defect.

```
At startup, validate every required variable, and exit non zero with a
message naming the missing one when any is absent.
```

Never a silent default for a secret. Never a fallback to a development value
in production. Never starting in a degraded state nobody chose.

```
Correct:  SESSION_SECRET is not set. Refusing to start.
Wrong:    const secret = process.env.SESSION_SECRET ?? "dev-secret"
```

The wrong version starts, works, and signs production sessions with a value
that is in the repository.

## 5. Blast radius

Before any operation touching an environment above `local`, classify it.

| Class | Definition | Requirement |
|---|---|---|
| none | reversible, no user visible effect | proceed |
| low | affects one deployment, revert restores everything | proceed, report |
| medium | affects users during a window, fully recoverable | announce, proceed, verify |
| high | data changes, partial recovery only | approval, backup verified first |
| irreversible | deleted data, sent mail, moved money, dropped column | explicit approval, naming the irreversibility |

The classification is written before the action, not after.

## 6. Destructive action protocol

Applies to anything at `high` or `irreversible`: dropping a table or a column,
deleting rows in bulk, truncating, restoring over live data, rotating a
credential in use, deleting a bucket, scaling to zero, changing DNS.

```
1  State what will happen, in one sentence, including what cannot be undone
2  Confirm the target: which environment, which resource, verified by reading
   it back, never by trusting the shell variable
3  Verify a backup exists and is recent, and say when it was taken
4  Obtain explicit approval, naming the irreversibility
5  Execute, with the output captured
6  Verify the intended effect, and check the unintended one
7  Record what was done, by whom, when
```

Step 2 exists because the most common serious operational incident is the
right command against the wrong environment.

## 7. Idempotence

Every operational procedure runs twice without harm: provisioning, migration
application, deployment, seeding, configuration application, backup.

A procedure that only works from a known starting state fails the first time
it is run after something went wrong, which is exactly when it is needed.

## 8. Observability precedes deployment

A system deployed without a way to see it fail is a system whose failures are
reported by users.

Before the first production deployment: errors surface somewhere a person
looks, a health endpoint answers, logs are structured and correlated, and the
one metric that says whether the system works is named.

## 9. Documentation of operations

Every operational procedure exists in written form before it is needed, in the
imperative, runnable by someone who did not write it, at three in the morning.

An operation performed once and never written down will be performed
differently next time, by someone else, under pressure.

## 10. Protocol

1. Establish the environment ladder this project actually has.
2. Classify configuration: code, config, or secret.
3. Enforce fail fast at startup.
4. Assess blast radius before every operation above `local`.
5. Apply the destructive protocol where the class demands it.
6. Verify idempotence of every procedure.
7. Confirm observability before the first deployment.
8. Write the procedure down.

## 11. Auto-critique

Score from 0 to 5: environment ladder stated honestly, parity gaps named,
nothing hardcoded that differs by environment, fail fast enforced, blast
radius classified before acting, destructive protocol applied, procedures
idempotent, observability in place before deployment.

Threshold: no axis below 3, average at least 4. A secret in the repository or
a silent production default is an automatic failure.

## 12. Interfaces

- Upstream: `engineering-core`, `technology-selection`,
  the DevOps section of the architecture document, produced by
  `architecture-proposal`.
- Downstream: every skill in `devops-skills`.
- Lateral: `backend-engineering` for the application side of configuration
  and logging.
