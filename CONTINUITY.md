# Continuity, 2026-08-11

State of the repository for whoever takes it over, human or agent. Written to
`engineering/dev-skills/project-continuity/resources/continuity-template.md`.

## Completed

Session 1, engineering system: 20 `dev-skills`,
`tests/validate-orchestration.sh`, `documentation/engineering-system.md`.

Session 2, delivery and operations: 10 `delivery-skills`, 11 `devops-skills`,
14 agents plus the handoff protocol, `delivery-phases.md`,
`documentation/delivery-system.md`. Validation from nine checks to twelve.

Session 3, reorganisation: two trees, `writing/` and `engineering/`. 392 files
moved as pure renames. Six indexes created.

Session 4, this one:

- `shared/`: `self-critique` and `project-brief`, depending on nothing.
- `documents/`: 7 skills in three categories, governed by `document-core`.
- `config/`: the configuration contract, template and field reference.
- `install.sh`: rewritten. `--documents`, `--shared`, `--configure`,
  `--help`, recommendation-first numbered prompts, validation, and generation
  of `writer-suite-manual-tasks.md`.
- `delegation` section: eight fields deciding what the agent does and what it
  hands over. `git-workflow` section 2 carries the contract.
- All 42 writing skills rewritten in English, `SKILL.md` and `README.md`.
- `README.md` rewritten in English, `README.fr.md` created as the complete
  French equivalent.
- Four new documentation files: `installation.md`, `configuration.md`,
  `agents.md`, `documents-system.md`.
- Tree and category indexes, `architecture.md`, `skills-guide.md`,
  `documentation/README.md`, `tests/README.md`, `CONTRIBUTING.md`,
  `CLAUDE.md`: rewritten in English.
- Three validation scripts rewritten and extended: 13 orchestration checks, 6
  rule checks, duplicate name detection.
- Repository governance: `dev` as the integration branch, `main` as the
  release branch, `.github/CODEOWNERS`, a pull request template, a `validate`
  workflow, and a `pre-push` hook. Setup and its limits in
  `documentation/branch-protection.md`.
- Branch protection applied to `main` and `dev` through the GitHub API: pull
  request required, one approving review, code owner review required, stale
  approvals dismissed, `structure, rules, orchestration` as a required check,
  branch up to date, conversations resolved, linear history, no force pushes,
  no deletions. Read back and verified by attempting a direct push to each.
- `LICENSE` names the copyright holder, and both READMEs carry an Author
  section.
- Selective installation: the installer asks what to install rather than
  installing everything, supports `--skill` with transitive dependency
  resolution, `--list`, `--all`, combined scopes, and bootstraps itself from a
  clone when run through a pipe.

## Current state

Working today:

- the three scripts pass: 92 skills, 0 errors, 1 pre-existing warning on a
  deliberate typographic counter-example;
- `install.sh` works in every mode, and `--configure` was exercised end to end
  under a pseudo-terminal, producing both the configuration file and the
  manual task list;
- no skill contains a hardcoded personal identity, verified by check 4;
- every declared dependency and every `Interfaces` cross reference resolves
  across all four trees.

Looks finished and is not:

- `documentation/writing-rules.md`, `workflow.md`, `engineering-system.md` and
  `delivery-system.md` are still in French. Their content is correct and
  current; only the language has not been converted. They are deep reference
  documents, not entry points, so nothing is broken by this, but it is
  inconsistent with the rest.

## Decisions

- **English skill language, configurable output language.** The alternative
  was keeping the writing tree French throughout. Rejected: it made the system
  unusable to anyone outside French. The resolution is the three-layer model in
  `documentation/configuration.md`: instructions in English, output in the
  recipient's language, French reference data kept French because it is output
  rather than instruction.
- **The writing skills were rewritten, not translated.** Each one states what
  survives a change of output language and what does not. `proofreader` and
  `poet` are explicitly French-specific and say so.
- **French filenames kept under `writing/resources/` and the writing skills'
  `examples/` and `resources/`.** Renaming roughly eighty files would have
  produced churn and a risk of broken references for no gain: the content is
  French reference material. Recorded so it reads as a decision rather than an
  oversight.
- **A fourth tree, `shared/`, rather than placing the cross domain skills in
  an existing one.** They are called by all three others; putting them in one
  would have made the other two depend on it. Check 13 enforces that they
  depend on nothing.
- **`documents/` split by reader, not by document type.** Seven skills cover
  the whole surface because the split is by audience. A skill per document type
  would have produced thirty skills sharing one method, which would then drift.
- **Delegation is explicit and defaults to caution.** `push` defaults to
  `branch-only`, `deployments` and `database_operations` to `no`. The reason is
  that a wrong default here is expensive and silent, whereas an over-cautious
  one costs one prompt.
- **`CLAUDE.md` stays tracked.** It is the public memory and the agent entry
  point, contains no secret, and the exception is now recorded in the file
  itself as `git-workflow` section 6 requires. It was also cut down to a
  pointer, since it had already drifted: it carried a directory tree from
  before the 1.3.0 reorganisation.
- Earlier decisions stand: agents tracked in the repository rather than in
  `.claude/`, engineering content in English, `code-review-protocol` suffixed
  to avoid a name collision.

## Remaining

- `enforce_admins` is off on both branches, so the owner is not blocked from
  pushing directly; contributors are. Turn it on the day
  `.github/CODEOWNERS` names a second reviewer, and not before: GitHub does
  not allow approving your own pull request, so enabling it with one
  maintainer removes every path to a merge. Command in
  `documentation/branch-protection.md`.
- No demonstration project for the delivery system, equivalent to
  `writing/examples/saga-les-cendres-de-kivu/`. First step: run the fourteen
  phases on a small real application repository.
- No demonstration project for the `documents/` tree either. First step: a
  three-document set for one subject, exercising the reader split and the PDF
  render verification.
- `validate-orchestration.sh` does not check that each skill's examples are
  consistent with its `SKILL.md`. First step: verify the skill names cited
  inside `examples/`.
- Execution plans do not cover pure infrastructure tasks. First step: decide
  whether that justifies a twenty-first task category.
- Nothing verifies at runtime that the review gates between agents were
  respected. That remains a documented discipline.

## Risks

- A skill added without being listed in a plan or a phase is reported as an
  orphan by check 7.
- An agent added without being added to the expected list is reported by check
  10, and the reverse.
- Check 9 covers only the `Interfaces` section. A broken reference elsewhere in
  a `SKILL.md` is not detected automatically.
- Installation is flat. Two skills sharing a name would overwrite one another;
  `validate-structure.sh` now refuses that, verified across the 92 names.
- Internal cross references between skills stay relative to their tree: a
  writing skill cites `core/writing-constitution`, an engineering skill cites
  `dev-skills/engineering-core`. That is deliberate and consistent with flat
  installation. Only the root documents carry the tree prefix.
- The `delegation` contract is a documented discipline, not an enforced one. A
  runtime that grants full write access does not prevent an agent from pushing
  when the configuration says otherwise. `git-workflow` makes it an automatic
  failure in its auto-critique, which is the strongest available lever.

## Verification

- `bash tests/validate-structure.sh`: 92 skills, 0 errors.
- `bash tests/validate-rules.sh`: 0 errors, 1 pre-existing warning.
- `bash tests/validate-orchestration.sh`: 0 errors, thirteen checks.
- `bash -n` on the four shell scripts.
- `install.sh` exercised against a sandbox target in every mode: full 92
  skills and 14 agents, `--writing` 44, `--documents` 9, `--dev` 43 plus
  agents, `--shared` 2, scoped removal keeping the cross domain pair, full
  removal, and `--zip` producing 92 archives.
- `install.sh --configure` exercised under a pseudo-terminal: prompts,
  defaults, validation refusals, configuration file and manual task list all
  produced and inspected.
- `install.sh --configure` without a terminal: fails cleanly, points at the
  template, exit 1.
- Grep for hardcoded identity across the four skill trees: none.
- Links in the root documents and the tree indexes: resolve.

## Context

- Git identity is read from the configuration, not imposed by the repository.
  `git-workflow` stops and names the missing field rather than inventing one.
  No automatic signature, no `Co-authored-by`, no mention of a tool.
- Four trees, four scopes in the installer. The two cross domain skills install
  with every scope and survive a scoped removal, so removing one tree never
  breaks another.
- The arrow block, `U+2190` to `U+21FF`, is rejected by check 2 of
  `validate-rules.sh` alongside emoji. Diagrams are written with `->`.
- Phase numbering in `delivery-phases.md` is read with `10#` to avoid octal
  interpretation of `08` and `09`. Keep the `phase: NN` format.
- Helper functions in the validation scripts use their own loop variables. A
  shared name silently rewrites the caller's loop; that bug was introduced and
  fixed during this session in `is_procedural`.
- Never name a shell variable `GROUPS`. It is a bash built-in array of the
  current user's group ids, and assigning to it fails silently rather than
  erroring. That cost the installer every skill it was meant to copy, and the
  scripts passed `bash -n` throughout. The lesson generalises: these scripts
  are verified by running them against a sandbox target, not by reading them.
- The installer is verified by running every mode against a sandbox target
  through `CLAUDE_SKILLS_DIR`, never against `~/.claude`. Three defects were
  found that way in the selection work alone: a bare `--skill NAME` rejected
  by the argument parser, an `exec 3</dev/tty` whose failure message escaped
  its own `2>/dev/null`, and a `die` inside a process substitution that killed
  only the subshell and let the install continue with a shorter list.
- `/dev/tty` can exist as a path and still refuse to open. Test it by
  attempting the open, never with `[ -r /dev/tty ]`: the path test passes in a
  sandbox, the read then fails, and the caller silently takes the default.
  That bug installed the writing tree for a user who had chosen nothing.
- Do not test branch protection by pushing to the protected branch. With
  `enforce_admins` off the push succeeds, and undoing it needs a force push,
  which the protection then refuses. It happened during setup: a probe commit
  reached `main` and `dev` and had to be removed by a revert, which is why
  `4c6f7bd` and `be42bb7` sit in the history. Test from an account without
  admin rights, or trust the read-back of the rule.
- After moving any directory, run all three scripts: two of them resolve paths
  and fail cleanly by naming what is missing.
