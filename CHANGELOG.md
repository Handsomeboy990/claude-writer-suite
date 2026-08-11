# Changelog

Every notable change to this project is recorded here. The format follows
semantic versioning.

## 2.0.0

Two new trees, an English-first skill language, and a configuration system
with explicit delegation boundaries. The engineering tree keeps its content;
the writing tree keeps its expertise and changes its instruction language.

Breaking: skills are now written in English, `README.fr.md` is the French
entry point rather than `README.md`, and skills that read user specific values
now require the configuration file instead of embedded defaults.

### Added

- `shared/`: 2 cross domain skills, depending on nothing and callable from
  every tree.
  - `self-critique`: selects the professional roles that will receive the
    work, runs one pass per role, checks the result against what was actually
    requested, ranks findings by severity, fixes them, re-reviews what the
    fixes touched. Delegates depth to the domain reviewers and keeps the one
    check none of them performs.
  - `project-brief`: inspects what exists, asks the decision-critical
    questions once in a single batch, records an assumption for everything it
    did not ask, and produces the working agreement that becomes the
    operational source of truth. Covers taking over existing work.
- `documents/`: 7 skills for documents delivered to someone, in three
  categories.
  - `document-core`: the constitution. Audience model, the three languages,
    the evidence rule, the shared style standard, an eight-point quality gate,
    eleven when paginated.
  - `technical-writing`, `user-documentation`, `report-writing`: separated by
    reader, not by subject.
  - `administrative-writing`: letters, notices, attestations, minutes,
    applications, with country conventions and the evidence rule at its
    strictest.
  - `document-design`, `pdf-production`: layout, then rendering and its
    verification.
- `config/`: the configuration contract. Template, field reference, and the
  rule that identity values have no default and never will.
  - `delegation` section: commits, branches, push, pull requests, release
    tags, deployments, database operations, dependency changes. Anything the
    user keeps is prepared and handed over rather than performed.
  - `install.sh --configure`: recommendation-first numbered prompts, scoped to
    what was installed, with validation that refuses an author name resembling
    a tool.
  - Selective installation. `bash install.sh` with no argument now asks what
    to install instead of installing all 92 skills. A developer is not given a
    novelist's toolkit, and the reverse. Scopes combine, `--all` restores the
    old behaviour explicitly, and with no terminal and no scope the installer
    refuses rather than guessing.
  - `--skill <name>` installs one skill with its dependencies resolved
    transitively across trees, so a named skill is never installed broken. An
    unknown name stops the run instead of silently shortening it. A named
    removal takes only what was named, since dependencies are shared.
  - `--list` prints every skill with its purpose.
  - The script bootstraps itself: with no skills beside it, it clones the
    repository into `~/.cache/claude-writer-suite`, which makes
    `curl ... | bash -s -- --writing` work. It opens the terminal directly for
    its questions, since its own stdin is the pipe.
  - `writer-suite-manual-tasks.md`, generated next to the configuration:
    every step the user kept, with its command.
- `README.fr.md`: complete French entry point, equivalent to `README.md`.
- `documentation/installation.md`, `configuration.md`, `agents.md`,
  `documents-system.md`, `branch-protection.md`.
- Repository governance. `dev` becomes the integration branch every
  contribution targets; `main` becomes the release branch, receiving only pull
  requests from `dev`.
  - `.github/CODEOWNERS`: the maintainer owns everything by default, with
    commented lines for adding authorized reviewers and per-area owners.
  - `.github/pull_request_template.md`: base branch check, the three
    validation results, and the attribution prohibition.
  - `.github/workflows/validate.yml`: runs the three scripts plus a shell
    syntax check on every pull request, and fails a pull request whose commits
    attribute the work to a tool. Meant to be a required status check.
  - `.githooks/pre-push`: refuses a direct push to `main` or `dev`, refuses
    their deletion, refuses a commit attributed to a tool, refuses a commit
    with an empty author. Enabled with
    `git config core.hooksPath .githooks`, with a documented maintainer
    override for a deliberate release push.
  - Branch protection applied to both branches through the GitHub API: pull
    request required, one approving review, code owner review required, stale
    approvals dismissed, `structure, rules, orchestration` as a required
    status check, branch up to date, conversations resolved, linear history,
    no force pushes, no deletions. `enforce_admins` deliberately off, so the
    owner keeps a release path while contributors are blocked.
- An Author section in both READMEs, and the copyright holder named in
  `LICENSE`.
- `validate-orchestration.sh` checks 12 and 13: the document pipeline, and the
  independence of `shared/`.
- `validate-rules.sh` checks 3 and 4: credential-shaped strings anywhere, and
  hardcoded personal identity in any skill tree.
- `validate-structure.sh`: duplicate skill name detection, since installation
  is flat.

### Changed

- Skill language is English for all 92 skills. The 42 writing skills were
  rewritten rather than translated: the structural expertise is unchanged, the
  French craft rules are retained and marked as French, and each skill states
  what happens when the output language is not French.
- Output language is now a configuration decision.
  `language.creative_output` defaults to French for `writing/`;
  `language.document_output` is set per recipient for `documents/`. The
  reference material in `writing/resources/` and the writing skills'
  `examples/` stays French, being output rather than instruction.
- `git-workflow`: the author identity is read from `identity.author_name` and
  `identity.author_email` instead of being hardcoded, and the skill stops and
  names the missing field rather than inventing one. New section 2 carries the
  delegation contract; the protocol reports every step stopped at.
- `install.sh`: rewritten in English, with `--documents`, `--shared`,
  `--configure` and `--help`. Cross domain skills install with every scope and
  survive a scoped removal.
- `validate-structure.sh`: group paths replace the tree-to-category mapping,
  covering four trees and ten groups; the `Protocol` and `Interfaces`
  requirement extends to `documents/` and `shared/`; skill README titles are
  checked for every tree.
- `validate-rules.sh`: rewritten in English. The straight quote check is
  scoped to `writing/`, since the rest of the repository is English where the
  straight quote is correct. `dist/` is excluded.
- `validate-orchestration.sh`: rewritten in English. Dependency and
  `Interfaces` resolution now spans all four trees.
- `README.md`, all tree and category indexes, `documentation/architecture.md`,
  `skills-guide.md`, `documentation/README.md`, `tests/README.md`,
  `CONTRIBUTING.md`, `CLAUDE.md`: rewritten in English.
- `CLAUDE.md` reduced to an entry point that points at the canonical
  documents instead of duplicating them, and records why it is committed.

### Fixed

- `documentation/architecture.md` carried a directory tree from before the
  1.3.0 reorganisation, showing categories at the repository root.
- `CLAUDE.md` carried the same stale tree.
- `git-workflow` and its resources embedded a real name and email address in a
  reusable skill, in `SKILL.md`, `README.md`, the pre-commit checklist and the
  worked example.
- `install.sh` used `GROUPS` as its skill group variable. `GROUPS` is a bash
  built-in array holding the current user's group ids, so the assignment was
  silently overwritten and every mode installed zero skills. Found by running
  the installer rather than by reading it. Renamed to `SKILL_GROUPS`, and all
  six modes re-verified against a sandbox target.

## 1.3.0

Reorganisation into two separate trees. No skill content changed; only paths.

### Changed

- Directory layout: the four writing categories, `resources/` and `examples/`
  moved under `writing/`; the three engineering categories and `agents/` moved
  under `engineering/`. The 392 files moved are pure renames and Git history is
  preserved.
- `README.md`: rewritten around the two trees, their categories, the minimum
  chains, the shared rules and the documentation table.
- `tests/validate-structure.sh`: resolves categories per tree, and now
  requires a `README.md` for each tree and each category.
- `tests/validate-orchestration.sh` and `install.sh`: paths adapted.
- `CLAUDE.md`, `CONTRIBUTING.md`, `CONTINUITY.md`, `documentation/*`,
  `tests/README.md`: paths prefixed with their tree.

### Added

- `writing/README.md` and `engineering/README.md`: tree indexes.
- `writing/core/README.md`, `writing/genres/README.md`,
  `writing/poetry/README.md`, `writing/quality/README.md`: category indexes,
  with order of use and a table of choice by situation. The four engineering
  categories already had theirs.

## 1.2.0

Extension of the engineering system into a full project delivery system. The
writing suite is unchanged.

### Added

- `delivery-skills/`: 10 project conduct skills, from specification to
  delivery, written in English.
  - `delivery-orchestrator`: fourteen phases, approval and verification gates,
    parallelisation, delivery checklist, verdict.
  - `requirements-analysis`, `clarification-gate`: understanding.
  - `technology-selection`, `architecture-proposal`, `validation-gate`:
    decision and approval.
  - `delivery-planning`, `implementation-integrity`,
    `scope-and-change-control`: execution.
  - `client-handover`: the takeover package.
- `devops-skills/`: 11 operations skills, platform agnostic.
  - `devops-core`, `environment-management`, `secrets-management`: foundation.
  - `containerization`, `ci-cd-pipelines`, `deployment-engineering`,
    `database-operations`: build and commissioning.
  - `observability`, `backup-recovery`, `production-verification`,
    `release-engineering`: operation.
- `agents/`: 14 specialised agent definitions and the handoff protocol. An
  agent cites skills; it copies none.
- `delivery-skills/delivery-orchestrator/resources/delivery-phases.md`: the
  fourteen phases in a machine-readable format, with their gates.
- `documentation/delivery-system.md`.
- Category indexes: `delivery-skills/README.md`, `devops-skills/README.md`,
  `agents/README.md`.

### Changed

- `tests/validate-structure.sh`: covers seven categories and 83 skills, and
  requires `Protocol` and `Interfaces` in the three engineering categories.
- `tests/validate-orchestration.sh`: from nine checks to twelve. Adds the
  fourteen delivery phases, the approval gates at phases 02, 05, 10 and 14, the
  fourteen agent definitions with their eight mandatory sections, and the
  skills cited by agents. Skill resolution now spans the three categories.
- `install.sh`: installs agents into `~/.claude/agents`, with `--agents` and
  `--no-agents`, and `CLAUDE_AGENTS_DIR` as a configurable target. Six modes
  verified.
- `CLAUDE.md`: three orchestrators and their scopes, the delivery workflow,
  the language of the new categories.
- `README.md`, `CONTRIBUTING.md`, `documentation/architecture.md`,
  `documentation/skills-guide.md`, `documentation/README.md`,
  `documentation/engineering-system.md`, `tests/README.md`, `CONTINUITY.md`:
  updated for the three new sets.

## 1.1.0

Addition of a second skill system, for software engineering. The writing suite
is unchanged.

### Added

- `dev-skills/`: 20 software engineering skills, stack agnostic, written in
  English.
  - Foundation: `engineering-core`, `project-exploration`,
    `engineering-orchestrator`.
  - Design: `architecture-design`, `ui-ux-engineering`,
    `dependency-selection`.
  - Implementation: `frontend-engineering`, `backend-engineering`,
    `fullstack-engineering`.
  - Verification: `input-validation`, `security-audit`, `debugging`,
    `testing-quality`, `playwright-automation`, `performance-engineering`,
    `code-review-protocol`.
  - Delivery: `technical-documentation`, `project-continuity`, `git-workflow`,
    `release-readiness`.
- `dev-skills/engineering-orchestrator/resources/execution-plans.md`: one
  machine-readable execution plan for each of the twenty task categories.
- `tests/validate-orchestration.sh`: nine coherence checks on the engineering
  system, including the five reference routing scenarios.
- `documentation/engineering-system.md`.
- `dev-skills/README.md`: index and reading order.
- `CONTINUITY.md`: state of the repository for whoever takes over.

### Changed

- `tests/validate-structure.sh`: covers the `dev-skills` category and
  requires, for it alone, a numbered `Protocol` section and an `Interfaces`
  section.
- `tests/validate-rules.sh`: the straight quote check ignores fenced code
  blocks, nested ones included. Warnings drop from three to one, the last being
  a deliberate typographic counter-example.
- `install.sh`: scope options `--writing` and `--dev`, combinable with `--zip`
  and `--remove`. Default installation of 62 skills.
- `.gitignore`: excludes local agent configuration and secret files.
  `CLAUDE.md` stays tracked, and the reason is written in the file.
- `CLAUDE.md`, `README.md`, `CONTRIBUTING.md`,
  `documentation/architecture.md`, `documentation/skills-guide.md`,
  `documentation/README.md`, `tests/README.md`: updated for the second system
  and the third validation script.

## 1.0.0

Initial version.

### Added

- `CLAUDE.md`: project memory, permanent rules, conventions, workflow, Git
  rules, philosophy.
- `core/writing-constitution`: founding document, typographic prohibitions,
  French dialogue conventions, flashback handling, style, characters, cultures,
  self-critique thresholds.
- 13 further `core` skills: novel-architect, chapter-architect, scene-builder,
  narrator, dialogue-master, character-psychologist, world-builder,
  immersion-director, research-director, continuity-manager, timeline-manager,
  saga-architect, screenwriter.
- 15 `genres` skills: thriller, mystery, detective, horror, fantasy,
  dark-fantasy, science-fiction, cyberpunk, historical-fiction, romance,
  adventure, dystopian, political-fiction, espionage, magical-realism.
- 5 `poetry` skills: poet, sonnet, haiku, free-verse, prose-poetry.
- 8 `quality` skills: self-critique-protocol, story-doctor, literary-editor,
  literary-critic, proofreader, beta-reader, rewriting-engine,
  publication-review.
- `resources/`: French typography, a catalogue of narrative structures,
  lexicons, project startup and tracking templates.
- `examples/saga-les-cendres-de-kivu/`: a complete demonstration project, from
  the bible to the validation report.
- `documentation/`: architecture, skills guide, writing rules, workflow.
- `tests/`: structure validation and constitution rule validation.
