# Claude Writer Suite

Four expertise systems for an agent, in one repository: **write**,
**produce documents**, **build software**, and **review your own work**.

92 skills and 14 agents. Not prompts: numbered protocols, decision criteria,
scoring grids and review procedures, each with a stated threshold for what
counts as finished.

[Version francaise](README.fr.md)

```
claude-writer-suite/
├── shared/           2 cross domain skills, called by every tree
├── writing/         42 creative writing skills
├── documents/        7 professional document skills
├── engineering/     41 software skills and 14 agents
├── config/           user specific values, nothing hardcoded
├── documentation/    technical documentation of the four trees
└── tests/            three validation scripts
```

## Why it exists

An agent that writes a chapter, a letter or an endpoint will produce something
plausible on the first attempt. Plausible is not the same as correct, and the
gap only appears later: at the deadline, in the reader's hands, in production.

Every skill here encodes the same shape. What the work is for. How it is done,
as a numbered procedure. What must be verified before it is called finished.
What score it has to reach. What it refuses to do.

## Language

The repository separates three languages that are routinely confused.

| Layer | What it is | Value |
|---|---|---|
| Skill language | the instructions themselves | English, all 92 skills |
| System language | paths, identifiers, config keys, commits | English |
| Output language | what the reader receives | theirs, set per project |

Skills are written in English so the system is usable internationally. What
they produce is a separate decision: `language.creative_output` defaults to
French because the writing tree encodes French craft, and
`language.document_output` is set to the language of whoever receives the
document. The French reference material in `writing/resources/` stays French,
because it is what the skills produce rather than how they are instructed.

## The four trees

### shared

Two skills that belong to no domain and are called by all of them.

| Skill | Runs | Produces |
|---|---|---|
| [project-brief](shared/project-brief/) | before the work | the agreement the work is measured against |
| [self-critique](shared/self-critique/) | after the work | the corrected result, and what was found |

`project-brief` inspects what exists, asks the decision-critical questions once
in a single batch, and records an assumption for everything it did not ask.
`self-critique` selects the professional roles that will actually receive the
work, runs one pass per role, and fixes what it finds rather than reporting it.

### writing

Creative writing. The agent works as novelist, screenwriter, editor, critic,
researcher, proofreader and beta reader, from a short story to a saga.

| Category | Skills | Purpose |
|---|---|---|
| [core](writing/core/) | 14 | foundations and production |
| [genres](writing/genres/) | 15 | thriller, mystery, fantasy, SF, romance, historical |
| [poetry](writing/poetry/) | 5 | French prosody and four forms |
| [quality](writing/quality/) | 8 | diagnosis, rewriting, correction, validation |

Index: [writing/README.md](writing/README.md).

### documents

Professional documents that are delivered to someone.

| Category | Skills | Question it answers |
|---|---|---|
| [documentation](documents/documentation/) | 4 | how the reader understands and uses the system |
| [administrative](documents/administrative/) | 1 | how a formal document survives being filed and quoted |
| [publishing](documents/publishing/) | 2 | how it looks, paginates and renders |

Four rules run through the tree: the audience is named before the first
sentence; the output language is the recipient's; nothing is asserted that was
not verified; and a generated PDF is not a finished PDF until the rendered
pages have been looked at.

Index: [documents/README.md](documents/README.md).

### engineering

Software engineering and project delivery. The agent takes a specification and
delivers a system that is implemented, tested, documented, deployed and
verified in production.

| Category | Skills | Question it answers |
|---|---|---|
| [dev-skills](engineering/dev-skills/) | 20 | how a change is made correctly |
| [delivery-skills](engineering/delivery-skills/) | 10 | what to build, in what order, with what approval |
| [devops-skills](engineering/devops-skills/) | 11 | how the system runs, deploys and restores |
| [agents](engineering/agents/) | 14 | who owns what, and what is handed on |

Stack and platform agnostic: the system reads the project it is given rather
than assuming its shape.

Index: [engineering/README.md](engineering/README.md).

## Installation

No dependencies. The repository is Markdown and shell.

```bash
git clone <repository-url> claude-writer-suite
cd claude-writer-suite

bash tests/validate-structure.sh
bash tests/validate-rules.sh
bash tests/validate-orchestration.sh

bash install.sh
bash install.sh --configure
```

Scopes, each of which also installs the two cross domain skills:

```bash
bash install.sh --writing      42 creative writing skills
bash install.sh --documents     7 professional document skills
bash install.sh --dev          41 engineering skills and 14 agents
bash install.sh --shared        the 2 cross domain skills only
bash install.sh --agents        the 14 agents only
bash install.sh --no-agents     skills without agents
bash install.sh --zip           also build one archive per skill in dist/
bash install.sh --remove        uninstall
```

Skills go to `~/.claude/skills`, agents to `~/.claude/agents`, configuration to
`~/.claude/writer-suite.config.yaml`. All three are overridable with
`CLAUDE_SKILLS_DIR`, `CLAUDE_AGENTS_DIR` and `CLAUDE_CONFIG_FILE`.

Full detail, including installing one skill alone:
[documentation/installation.md](documentation/installation.md).

## Configuration

Nothing assumes who you are, which tools you use, or which language your
readers speak.

```bash
bash install.sh --configure
```

Every question has a recommended answer, already selected: press enter to
accept it. Only the fields relevant to the scope you installed are asked.

Two fields are required and have no default, ever: `identity.author_name` and
`identity.author_email`. A commit carries a real person, and `git-workflow`
stops and names the missing field rather than inventing one. The installer
rejects an author name that looks like a tool.

### What the agent may do on its own

The `delegation` section decides how much of the work reaches you as a
finished action and how much reaches you as a prepared step.

| Field | Values |
|---|---|
| `commits` | yes, stage-only, no |
| `branches` | yes, no |
| `push` | yes, branch-only, no |
| `pull_requests` | yes, draft, no |
| `release_tags` | yes, no |
| `deployments` | yes, non-production, no |
| `database_operations` | yes, non-production, no |
| `dependency_changes` | yes, with-justification, no |

Say no to anything you would rather do yourself. The agent stops at that
boundary, hands you what it prepared, and names the step.

Everything you keep is written to `writer-suite-manual-tasks.md`, next to the
configuration file, with the command for each step. Nothing is silently left
undone.

Two rules are never delegated: a destructive operation is counted and
confirmed before it runs, and a leaked secret is reported for rotation rather
than quietly removed.

Field reference: [config/README.md](config/README.md). Installer side:
[documentation/configuration.md](documentation/configuration.md).

## Which skill do I need

| Situation | Skill |
|---|---|
| I am starting a project of any kind | `shared/project-brief` |
| I finished something and want it checked | `shared/self-critique` |
| I am starting a novel | `writing/core/novel-architect` |
| My scene is flat | `writing/core/scene-builder` |
| Every character speaks alike | `writing/core/dialogue-master` |
| My middle sags | `writing/quality/story-doctor` |
| Is this publishable | `writing/quality/literary-critic` |
| A partner must integrate with our API | `documents/documentation/technical-writing` |
| A customer cannot find how to do something | `documents/documentation/user-documentation` |
| Leadership must decide | `documents/documentation/report-writing` |
| A formal letter has to be sent | `documents/administrative/administrative-writing` |
| The client wants a PDF | `documents/publishing/pdf-production` |
| I have a coding task | `engineering/dev-skills/engineering-orchestrator` |
| I have a bug | `engineering/dev-skills/debugging` |
| I have a specification, not a task | `engineering/delivery-skills/delivery-orchestrator` |
| Something must be deployed | `engineering/devops-skills/devops-core` |

Full directory: [documentation/skills-guide.md](documentation/skills-guide.md).

## Using a skill

Every skill is a self-contained directory:

```
skill-name/
├── SKILL.md      the expertise: procedure, thresholds, refusals
├── README.md     summary, inputs, outputs, dependencies, configuration
├── examples/     at least one worked example
└── resources/    at least one grid, checklist or reference
```

The README states its dependencies in four lines. `Depends on: nothing` means
it works alone; copy the directory and use it. A skill that depends on another
refers to it rather than restating it, so the other one is needed too.

Six skills depend on nothing and work entirely on their own:
`shared/self-critique`, `shared/project-brief`,
`documents/documentation/document-core`,
`engineering/dev-skills/engineering-core`,
`engineering/devops-skills/devops-core`,
`writing/core/writing-constitution`.

## Agents

Fourteen role definitions, for a runtime that supports subagents.

```
Skill          how this kind of work is done correctly
Agent          who owns this piece of work, what they may touch, what they hand on
Orchestration  which agents run, in what order, and where the gates are
```

An agent is thin by design: it names the skills it uses and never restates
them. For a single task the skills alone are enough; install with
`--no-agents` and let `engineering-orchestrator` sequence them in one context.

Detail: [documentation/agents.md](documentation/agents.md).

## Dependencies between skills

```
project-brief
    -> requirements-analysis -> architecture-proposal -> validation-gate
    -> implementation -> testing-quality -> security-audit
    -> code-review-protocol -> release-readiness
    -> self-critique
```

Each tree has one constitution that every skill in it refers to and none
restates:

| Tree | Constitution |
|---|---|
| writing | `writing/core/writing-constitution` |
| documents | `documents/documentation/document-core` |
| engineering | `engineering/dev-skills/engineering-core` |
| engineering, operations | `engineering/devops-skills/devops-core` |

`tests/validate-orchestration.sh` verifies that every declared dependency and
every cross reference resolves, so the declarations are accurate rather than
aspirational.

## What the system refuses

```
guessing anything the repository can establish
asserting without having run it
writing a command into a document without running it first
inventing a legal reference, a registration number or an institution
leaving fake functionality on a reachable path
writing production code before the architecture is approved
weakening a test to obtain a green pipeline
hardcoding a value that varies by environment
running a destructive statement without counting the rows first
declaring a deployment successful without exercising a journey
delivering a PDF whose pages were never rendered and looked at
attributing a commit to a tool
```

Two prohibitions apply to every file in the repository, including this one:
**no emoji**, **no em dash**. Both are enforced by
`tests/validate-rules.sh`.

## Validation

```bash
bash tests/validate-structure.sh      structure and metadata of 92 skills
bash tests/validate-rules.sh          emoji, em dash, secrets, hardcoded identity
bash tests/validate-orchestration.sh  plans, phases, agents, cross references
```

All three must pass before any commit. Detail in
[tests/README.md](tests/README.md).

## Documentation

| File | Contents |
|---|---|
| [documentation/architecture.md](documentation/architecture.md) | organisation, skill isolation, metadata |
| [documentation/skills-guide.md](documentation/skills-guide.md) | directory of the 92 skills |
| [documentation/installation.md](documentation/installation.md) | full and per-skill installation |
| [documentation/configuration.md](documentation/configuration.md) | the configuration contract |
| [documentation/agents.md](documentation/agents.md) | skill, agent, orchestration |
| [documentation/documents-system.md](documentation/documents-system.md) | the documents tree in detail |
| [documentation/engineering-system.md](documentation/engineering-system.md) | the dev-skills layer in detail |
| [documentation/delivery-system.md](documentation/delivery-system.md) | delivery, operations and agents |
| [documentation/writing-rules.md](documentation/writing-rules.md) | the writing rules, operational form |
| [documentation/workflow.md](documentation/workflow.md) | the writing workflow, phase by phase |
| [documentation/branch-protection.md](documentation/branch-protection.md) | who may write to main and dev, and how |
| [CONTINUITY.md](CONTINUITY.md) | state of the repository for whoever takes over |
| [CHANGELOG.md](CHANGELOG.md) | version history |

## Contributing

Branch from `dev`. Never from `main`.

```bash
git switch dev && git pull
git switch -c feat/my-change
git config core.hooksPath .githooks    # once per clone
# work, commit
git push -u origin feat/my-change      # then open a pull request into dev
```

`main` is the release branch and receives only pull requests from `dev`,
opened by a maintainer. Both branches require a pull request, a green
`validate` run and an approval from a code owner listed in
[.github/CODEOWNERS](.github/CODEOWNERS).

Adding a skill: create the directory with its four elements, declare the
metadata, refer to the constitution of its tree without restating it, add at
least one example and one resource, update the category index and
`documentation/skills-guide.md`, then run the three scripts.

Full rules: [CONTRIBUTING.md](CONTRIBUTING.md). Branch rules and their setup:
[documentation/branch-protection.md](documentation/branch-protection.md).

## Philosophy

- Constraint produces style. Rules remove noise rather than freedom.
- A text is judged on its effect, never on its intention.
- A system is judged on what was executed, never on what was planned.
- Consistency is a form of respect, for the reader and for the next engineer.
- A skill must stay useful at chapter 3 and at chapter 90, at the first commit
  and at the hundredth.
- Every rule stated must be verifiable by an explicit procedure.
- Critical severity is a service, not a posture.

## Author

**Lauret Chacha**

| | |
|---|---|
| GitHub | [@Handsomeboy990](https://github.com/Handsomeboy990) |
| Portfolio | [lauret-chacha.vercel.app](https://lauret-chacha.vercel.app) |
| LinkedIn | [in/lauret-chacha](https://linkedin.com/in/lauret-chacha) |
| Email | lauretchacha@gmail.com |

## License

MIT. See [LICENSE](LICENSE).

Copyright (c) 2026 Lauret Chacha (Handsomeboy990).
