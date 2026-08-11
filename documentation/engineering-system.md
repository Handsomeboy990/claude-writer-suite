# The engineering skill system

Technical documentation of `engineering/dev-skills`, the code practice layer.

Two layers complete it, documented in `delivery-system.md`:
`engineering/delivery-skills` runs a project from specification to delivery,
and `engineering/devops-skills` governs how the system runs. This document
covers one question: how a change is made correctly.

## 1. Purpose

To let an agent work on a production codebase the way an experienced engineer
does: read before writing, verify before asserting, finish the whole vertical
slice rather than the part that demonstrates well.

The system is stack agnostic. No skill assumes a framework, a database, an
authentication mechanism or a directory layout. Each reads the project it is
given.

## 2. Language

These skills produce code, commit messages, branch names, pull requests and
technical documentation, all in English by rule 6 of `engineering-core`.
Writing the instructions in the language of their output removes a permanent
translation and a source of error.

Since version 2.0.0 that is no longer specific to this tree: all 92 skills are
written in English, and the output language is a configuration decision. See
`configuration.md`.

Rules 1 and 2 of the writing constitution still apply to every file: no emoji,
no em dash.

## 3. The twenty skills

### Foundation

| Skill | Responsibility |
|---|---|
| `engineering-core` | eight laws, the evidence rule, the certainty vocabulary, the definition of done |
| `project-exploration` | turns an unknown repository into verified facts |
| `engineering-orchestrator` | classifies the task, composes the plan, imposes the gates |

### Design

| Skill | Responsibility |
|---|---|
| `architecture-design` | the smallest architecture that serves the product |
| `ui-ux-engineering` | the rendered experience, specified before it is built |
| `dependency-selection` | add, replace, upgrade or refuse a library |

### Implementation

| Skill | Responsibility |
|---|---|
| `frontend-engineering` | client features, the five states, accessibility |
| `backend-engineering` | handlers, services, data, transactions, jobs |
| `fullstack-engineering` | the vertical slice and the shared contract |

### Verification

| Skill | Responsibility |
|---|---|
| `input-validation` | every external value, validated at the trust boundary |
| `security-audit` | a twenty-four point sweep, fixes and manual actions |
| `debugging` | root cause with file, line and mechanism |
| `testing-quality` | the right layer, ten mandatory cases, tests that can fail |
| `playwright-automation` | browser journeys, responsive and keyboard proof |
| `performance-engineering` | measure, fix the dominant cost, prove the delta |
| `code-review-protocol` | five passes, then fix and verify |

### Delivery

| Skill | Responsibility |
|---|---|
| `technical-documentation` | documentation matching the implementation |
| `project-continuity` | a handover the next session can resume from |
| `git-workflow` | identity, delegation boundaries, atomic commits, history hygiene |
| `release-readiness` | nine gates and a go or no go verdict |

## 4. Execution chain

```
request  ->  engineering-core
         ->  engineering-orchestrator
              classification, locating the affected surface
         ->  project-exploration
              establishing the facts
         ->  the selected skills, in order
         ->  the mandatory gates
         ->  completion verdict
```

`engineering-core` loads first and is never copied by the others. The
orchestrator composes the smallest complete plan: a typo fix takes four steps,
a payment endpoint takes eleven. Both are correct.

## 5. Mandatory gates

Never abandoned to save time.

| Gate | Applies when |
|---|---|
| exploration before decision | unread code is touched |
| validation before persistence | an external input reaches storage or an effect |
| authorization before exposure | a route or a query returns a user's data |
| security review before merge | auth, payments, uploads, user content, permissions, secrets, dependencies |
| test before done | any behaviour change |
| review before delivery | any code written by the agent |
| continuity before handover | any session that changed the repository |
| author check before commit | every commit |

A gate can be satisfied by evidence rather than by running a whole skill. An
existing test, executed, red before and green after, satisfies the test gate.

## 6. Task categories

Twenty classification categories, each with a canonical plan in
`engineering/dev-skills/engineering-orchestrator/resources/execution-plans.md`:

EXPLORATION, ARCHITECTURE, FRONTEND, BACKEND, FULLSTACK, DATABASE, API,
AUTHENTICATION, SECURITY, VALIDATION, DEBUGGING, PERFORMANCE, UI_UX, TESTING,
BROWSER_AUTOMATION, DOCUMENTATION, GIT, RELEASE, REFACTORING, DEPENDENCY.

The plan format is machine readable, which is what allows
`tests/validate-orchestration.sh` to verify their coherence.

## 7. Dependency graph

```
engineering-core
      |
      +-- project-exploration
      |         |
      |         +-- engineering-orchestrator
      |         |
      |         +-- architecture-design --+
      |         +-- ui-ux-engineering ----+
      |         +-- dependency-selection -+
      |                                   |
      |                    +--------------+
      |                    |
      |         backend-engineering   frontend-engineering
      |                    |                 |
      |                    +-- fullstack-engineering
      |                                |
      +-- input-validation ------------+
      |                                |
      +-- security-audit               |
      +-- debugging                    |
      +-- testing-quality -------------+
      |         |                      |
      |         +-- playwright-automation
      |                                |
      +-- performance-engineering -----+
                                       |
                     code-review-protocol
                                |
      technical-documentation <--+--> project-continuity
                                |
                          git-workflow
                                |
                        release-readiness
```

`shared/self-critique` sits alongside `code-review-protocol` rather than
inside this graph. It selects the review panel and enforces the loop, then
delegates the depth here.

## 8. Validation

```bash
bash tests/validate-structure.sh      structure and metadata of the 92 skills
bash tests/validate-rules.sh          the repository-wide prohibitions
bash tests/validate-orchestration.sh  plans, references and scenarios
```

The third script covers the four trees and the agents. It verifies that every
task category has a plan, that every step names an existing skill, that the
mandatory gates appear where they are required, that plan ordering is
coherent, that no engineering skill is orphaned, that `depends_on` and cross
references resolve, and that the five reference routing scenarios hold.

It also covers the fourteen delivery phases, the fourteen agent definitions,
the document pipeline and the independence of `shared/`. The thirteen checks
are listed in `tests/README.md`.

The reference scenarios:

| Scenario | Category | Subsequence verified |
|---|---|---|
| A, bug in an API | DEBUGGING | exploration, debugging, backend, tests, review |
| B, new page | FRONTEND | exploration, UI/UX, frontend, validation, tests, playwright, performance, review |
| C, payment endpoint | BACKEND | exploration, architecture, backend, validation, security, tests, review |
| D, authentication review | SECURITY | exploration, security, review, documentation, with tests present |
| E, complete feature | FULLSTACK | the twelve steps of the vertical slice |

## 9. Extending

Adding an engineering skill:

1. create the directory in `engineering/dev-skills/` with its four mandatory
   elements;
2. declare `category: dev-skills` in the metadata block;
3. refer to `engineering-core` without copying it;
4. include a numbered `Protocol` section, an `Auto-critique` section and an
   `Interfaces` section;
5. add it to at least one execution plan, or check 7 reports it as an orphan;
6. update `engineering/dev-skills/README.md`, `skills-guide.md` and this file;
7. run the three validation scripts.
