# Skills guide

Directory of the 119 skills. One line each: what it does, and when to open it.

Every skill's own `README.md` carries its inputs, outputs, dependencies and
configuration in four lines. This file is the index; the READMEs are the
contracts.

## Choosing by situation

| Situation | Skill |
|---|---|
| I am starting anything significant | `project-brief` |
| I finished something and want it checked | `self-critique` |
| I must validate a whole product before launch | `quality-engineering` |
| I need to know what to re-run after a fix | `regression-testing` |
| The API works and I do not trust it | `api-testing` |
| I want the defects tests do not find | `exploratory-testing`, `bug-hunting` |
| Someone asked whether it is accessible | `accessibility-testing` |
| I am authorised to test the security of a running system | `security-testing` |
| I want to know what happens when a provider fails | `reliability-testing` |
| I have findings and need a report | `test-reporting` |
| I am designing an endpoint anyone else will call | `api-design` |
| I am about to create a table | `database-design` |
| The structure fights me every time I change it | `refactoring` |
| I inherited a codebase with no tests | `legacy-code` |
| We must move off this framework, database or provider | `migration-engineering` |
| Everyone complains about the code and nobody agrees | `technical-debt` |
| This choice will be questioned in two years | `decision-records` |
| It is slow and someone said cache it | `caching-strategy` |
| This work does not belong in the request | `background-jobs` |
| It must update live | `realtime-systems` |
| Users upload files | `file-handling` |
| Money moves | `payment-engineering` |
| We are launching in a second language | `internationalization` |
| The public pages must be found | `seo-engineering` |
| Every screen looks slightly different | `design-system` |
| We hold personal data | `data-privacy` |
| We must provision infrastructure | `infrastructure-as-code` |
| Production is down | `incident-response` |
| I am starting a novel | `novel-architect` |
| I do not know where to cut my chapters | `chapter-architect` |
| My scene is flat | `scene-builder` |
| Every character speaks alike | `dialogue-master` |
| My protagonist is dull | `character-psychologist` |
| My setting reads like a brochure | `immersion-director` |
| I am writing about a real trade or period | `research-director` |
| I have lost track of the dates | `timeline-manager` |
| I no longer know who knows what | `continuity-manager` |
| My middle sags | `story-doctor` |
| My text is correct but flat | `literary-editor` |
| Is this publishable | `literary-critic` |
| I am delivering a manuscript | `publication-review` |
| A partner must integrate with our API | `technical-writing` |
| A customer cannot find how to do something | `user-documentation` |
| Leadership must decide | `report-writing` |
| A formal letter has to be sent | `administrative-writing` |
| Four deliverables must look like one set | `document-design` |
| The client wants a PDF | `pdf-production` |
| I have a coding task | `engineering-orchestrator` |
| I have never seen this codebase | `project-exploration` |
| I have a bug | `debugging` |
| It is slow | `performance-engineering` |
| Is it safe to ship | `release-readiness` |
| I have a specification, not a task | `delivery-orchestrator` |
| Something must be deployed | `devops-core` |
| Is the deployment actually working | `production-verification` |

## shared, 2 skills

Depend on nothing. Callable from any tree, usable alone.

| Skill | What it does |
|---|---|
| `project-brief` | frames work before it starts: inspects, asks the decision-critical questions in one batch, records assumptions, writes the working agreement |
| `self-critique` | reviews finished work from the roles that will receive it, checks it against the request, fixes what it finds, re-reviews |

## writing, 42 skills

### core, 14

| Skill | What it does |
|---|---|
| `writing-constitution` | the non-negotiable rules and the conformity grid |
| `novel-architect` | premise, dramatic question, structure, arcs, reveal schedule, outline |
| `chapter-architect` | chapter breakdown, entry and exit values, worked titles |
| `scene-builder` | objective, escalating conflict, costly outcome, irreversibility |
| `narrator` | person, focalisation, tense, distance, free indirect speech, voice |
| `dialogue-master` | French dialogue typography, incises, subtext, voice differentiation |
| `character-psychologist` | the seven field core, access layers, behavioural translation, arcs |
| `world-builder` | material constraint, geography, economy, power, special systems |
| `immersion-director` | nine sensory and cultural channels, dosage, anti-exoticism |
| `research-director` | research needs, depth levels, sources, anachronism control |
| `continuity-manager` | eight registers, per-chapter updates, eight-pass audit |
| `timeline-manager` | master and reader chronologies, ellipses, flashbacks |
| `saga-architect` | volume question against saga question, long memory, narrative debts |
| `screenwriter` | pitch, treatment, breakdown, screenplay, adaptation |

### genres, 15

| Skill | Dominant requirement |
|---|---|
| `thriller` | temporal pressure |
| `mystery` | fairness of the clues |
| `detective` | procedural accuracy |
| `horror` | economy of showing |
| `fantasy` | necessity of the fantastic |
| `dark-fantasy` | absence of complacency |
| `science-fiction` | depth of consequences |
| `cyberpunk` | material density |
| `historical-fiction` | documentary accuracy |
| `romance` | strength of the internal obstacle |
| `adventure` | consistency of attrition |
| `dystopian` | credibility of the system |
| `political-fiction` | absence of manicheism |
| `espionage` | coherence of the betrayal |
| `magical-realism` | non-astonishment held |

### poetry, 5

| Skill | What it does |
|---|---|
| `poet` | French prosody, image, sound, seven-step composition |
| `sonnet` | fourteen lines, rhyme arrangements, the volta |
| `haiku` | brevity, season marker, the cut |
| `free-verse` | a constraint invented per poem and held |
| `prose-poetry` | a block, four cohesion forces, closure by displacement |

### quality, 8

| Skill | What it does |
|---|---|
| `self-critique-protocol` | eleven axes, quoted evidence, numeric thresholds |
| `story-doctor` | structural diagnosis, symptom to cause, repair plan |
| `rewriting-engine` | six rewrite modes, salvage rules |
| `literary-editor` | six style passes, editorial note, cut log |
| `proofreader` | five correction passes, French typography |
| `beta-reader` | simulated reading, drop-off points, no prescription |
| `literary-critic` | weighted grid, decision scale, one recommendation |
| `publication-review` | seven checks, written decision, publication dossier |

## documents, 7 skills

| Skill | Category | What it does |
|---|---|---|
| `document-core` | documentation | audience model, language layers, evidence rule, quality gate |
| `technical-writing` | documentation | architecture documents, API references, installation and operational guides |
| `user-documentation` | documentation | guides, manuals, help articles, support material |
| `report-writing` | documentation | status, audit, incident and options reports |
| `administrative-writing` | administrative | letters, notices, attestations, minutes, applications |
| `document-design` | publishing | hierarchy, typography, tables, page furniture, metadata |
| `pdf-production` | publishing | engine selection, generation, render verification |

## engineering, 68 skills

### dev-skills, 45

| Skill | What it does |
|---|---|
| `engineering-core` | the non-negotiable engineering rules |
| `engineering-orchestrator` | classifies a task and composes the smallest complete plan |
| `project-exploration` | maps an unfamiliar codebase before any change |
| `architecture-design` | the smallest architecture that serves the product |
| `ui-ux-engineering` | the rendered experience, states, accessibility |
| `dependency-selection` | twelve point evaluation before adding a library |
| `frontend-engineering` | pages, components, state, forms, the five UI states |
| `backend-engineering` | handlers, services, authorization, transactions, jobs |
| `fullstack-engineering` | a feature across every layer, contract first |
| `input-validation` | every external input treated as hostile |
| `security-audit` | twenty four point sweep of the real implementation |
| `debugging` | reproduction, evidence, root cause, verified fix |
| `testing-quality` | the right test layer, tests that can actually fail |
| `playwright-automation` | browser verification of real journeys |
| `performance-engineering` | baseline, bottleneck, targeted fix, proven delta |
| `code-review-protocol` | senior review that finds defects and fixes them |
| `technical-documentation` | documentation living in the codebase |
| `project-continuity` | leaves the project resumable by someone else |
| `git-workflow` | identity, atomic commits, delegation boundaries, pull requests |
| `release-readiness` | nine gates, then a go or no go verdict |
| `api-design` | the contract before the endpoint exists |
| `database-design` | schema, constraints, indexes from access patterns |
| `refactoring` | structure changed, behaviour proven unchanged |
| `legacy-code` | safe change in code nobody trusts |
| `migration-engineering` | moving a running system, in reversible steps |
| `technical-debt` | debt measured, ranked and paid inside real work |
| `decision-records` | why the system is built this way, immutably |
| `caching-strategy` | whether to cache, where, keyed by what, invalidated how |
| `background-jobs` | queues, retries, idempotency, scheduled work |
| `realtime-systems` | live features that survive a real network |
| `file-handling` | uploads, storage, processing and delivery, safely |
| `payment-engineering` | flows that stay correct when money moves |
| `internationalization` | more than one language and region, done properly |
| `seo-engineering` | the technical half of search visibility |
| `design-system` | tokens, component contracts, themes, adoption |
| `data-privacy` | what is held, for how long, and deletion that works |
| `quality-engineering` | coordinates a whole quality campaign and its verdict |
| `api-testing` | an HTTP surface against its contract, past the 200 |
| `exploratory-testing` | designed exploration under a charter and a time box |
| `bug-hunting` | systematic adversarial testing of a working feature |
| `regression-testing` | what to re-run, and what was deliberately excluded |
| `accessibility-testing` | keyboard first, scanner last |
| `security-testing` | authorized dynamic testing of the real controls |
| `reliability-testing` | what happens when a dependency fails |
| `test-reporting` | findings, severity, evidence, lifecycle, one verdict |

### delivery-skills, 10

| Skill | What it does |
|---|---|
| `delivery-orchestrator` | fourteen phases, four approval gates, completion verdict |
| `requirements-analysis` | a specification into an implementable engineering spec |
| `clarification-gate` | what must be asked, once, in one grouped batch |
| `technology-selection` | the stack, with a written justification per decision |
| `architecture-proposal` | the formal proposal, sized to the project |
| `validation-gate` | the firm stop before any production code |
| `delivery-planning` | ordered atomic tasks with dependencies and milestones |
| `implementation-integrity` | forbids and detects fake functionality |
| `scope-and-change-control` | protects an approved scope from silent drift |
| `client-handover` | the delivery package another team can take over |

### devops-skills, 13

| Skill | What it does |
|---|---|
| `devops-core` | environment ladder, configuration, blast radius, destructive protocol |
| `environment-management` | the variable inventory and drift detection |
| `secrets-management` | credential lifecycle, rotation, leak handling |
| `containerization` | whether a container is warranted, and how to build it |
| `ci-cd-pipelines` | a pipeline that fails for the right reasons |
| `deployment-engineering` | a verified artefact running in a target environment |
| `database-operations` | migrations, backfills, indexes, production safety |
| `observability` | logs, health, metrics, alerts on user impact |
| `backup-recovery` | a backup is untested until a restore has been performed |
| `production-verification` | proves a deployed system works, by exercising it |
| `release-engineering` | versioning, tagging, changelog, rollout, hotfix path |
| `infrastructure-as-code` | infrastructure in code, state, plans, drift |
| `incident-response` | declaration to postmortem, mitigation before diagnosis |

### agents, 16

`delivery-orchestrator`, `principal-engineer`, `requirements-analyst`,
`software-architect`, `frontend-engineer`, `backend-engineer`,
`database-engineer`, `security-engineer`, `qa-engineer`,
`playwright-engineer`, `ui-ux-engineer`, `devops-engineer`,
`performance-engineer`, `documentation-engineer`, `release-engineer`,
`incident-responder`.

Public contracts in `agents.md`. An agent is a role: it names the skills it
uses and restates none of them.

## Skills that work alone

Six depend on nothing and can be copied and used on their own:

```
shared/self-critique
shared/project-brief
documents/documentation/document-core
engineering/dev-skills/engineering-core
engineering/devops-skills/devops-core
writing/core/writing-constitution
```

Every other skill declares its dependencies in `depends_on` and in its README.
`tests/validate-orchestration.sh` check 8 verifies that each one resolves.

## Skills that read configuration

| Skill | Fields |
|---|---|
| `git-workflow` | `identity.*`, `git.*`, `delegation.*` |
| `release-engineering` | `git.commit_convention`, `delegation.release_tags` |
| `deployment-engineering` | `engineering.deployment_platform`, `delegation.deployments` |
| `database-operations` | `delegation.database_operations` |
| `dependency-selection` | `engineering.package_manager`, `delegation.dependency_changes` |
| `technical-documentation`, `technical-writing` | `language.documentation` |
| the `writing/` tree | `language.creative_output` |
| the `documents/` tree | `language.document_output`, `identity.organization`, `documents.*` |

Field reference in `config/README.md`.
