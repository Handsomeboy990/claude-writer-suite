# CLAUDE.md

Entry point for an agent working on this repository. Read it before any
modification.

This file is deliberately short and holds no duplicated content. It points at
the canonical documents and states only the rules an agent must know before it
touches anything.

## What this repository is

Claude Writer Suite: 119 skills and 16 agents, in four trees.

| Tree | Contents | Constitution |
|---|---|---|
| `shared/` | 2 cross domain skills | none, they depend on nothing |
| `writing/` | 42 creative writing skills | `writing/core/writing-constitution` |
| `documents/` | 7 professional document skills | `documents/documentation/document-core` |
| `engineering/` | 68 software skills, 16 agents | `engineering/dev-skills/engineering-core` and `engineering/devops-skills/devops-core` |

Full picture: `README.md`. Architecture: `documentation/architecture.md`.

## Routing

Determine the nature of the request before acting, then load the governing
skill. Never run a whole chain by reflex: compose the smallest complete plan.

| Request | Load first |
|---|---|
| Any significant project, or taking one over | `project-brief` |
| Fiction, poetry, screenplay, text revision | `writing-constitution` |
| A delivered document, report, letter, manual, PDF | `document-core` |
| A single coding task: feature, bug, review, refactor | `engineering-orchestrator` |
| A specification, brief or client request | `delivery-orchestrator` |
| Environment, pipeline, deployment, production database, secret | `devops-core` |
| Anything just finished | `self-critique` |

`engineering-orchestrator` loads `engineering-core` then selects the rest.
`delivery-orchestrator` holds the approval gates of the fourteen phases.

## Mandatory gates

- Writing: no text is finished before `self-critique-protocol`, then at least
  one revision skill.
- Documents: no document is delivered before the eight-point gate of
  `document-core`, eleven when it is paginated.
- Code: no task is finished before `code-review-protocol`, with a test run and
  observed.
- Project: no production code before `validation-gate`, scaffolding included.
- Deployment: nothing is announced as delivered before
  `production-verification`.

## Permanent rules

1. No emoji, in any file or any output.
2. No em dash. The en dash is for dialogue only.
3. Skill language is English, for all 119 skills and all 16 agents. Output
   language is the recipient's, set in the configuration. The three layers are
   defined in `documentation/configuration.md`.
4. Commits are atomic, in English, with no mention of an AI, an assistant or
   `Co-authored-by`. Full procedure in `git-workflow`.
5. Never commit a `.env`, a private key, a certificate or a credential.
6. Never hardcode a user specific value. It belongs in the configuration; the
   field reference is `config/README.md`.

## Delegation

What an agent may do on its own is set by the `delegation` section of the
configuration: commits, branches, push, pull requests, release tags,
deployments, database operations, dependency changes.

Anything the user kept is prepared and handed over with its command, never
performed anyway, and never silently skipped. `git-workflow` section 2 holds
the contract.

## Working on this repository

Before any modification:

1. Read this file.
2. Read the constitution of the tree concerned.
3. Check consistency with `documentation/architecture.md`, and with the
   system document for the tree: `documents-system.md`,
   `engineering-system.md`, `delivery-system.md`.
4. Run the three scripts in `tests/`.
5. Commit atomically, in English.

Contribution rules and the pre-pull-request checklist: `CONTRIBUTING.md`.
State of the repository for whoever takes over: `CONTINUITY.md`.

## Why this file is committed

It is the public memory of the project and the entry point an agent reads
first. It contains no secret and no local machine configuration, which is what
`.gitignore` excludes. That exception is deliberate and recorded here rather
than left implicit, as `git-workflow` section 6 requires.

Local agent configuration, `.claude/`, `*.local` and every secret pattern stay
ignored.
