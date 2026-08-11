# Installation

The repository is Markdown and shell. No runtime, no package manager, no
dependency.

## Requirements

| Tool | Needed for |
|---|---|
| `bash` 4 or later | the installer and the validation scripts |
| `git` | cloning, and the `git-workflow` skill |
| `zip` | the optional `--zip` mode only |

Optional, and only for `pdf-production`: `pdfinfo`, `pdffonts`, `pdftotext`
and `pdftoppm` from Poppler, plus `qpdf`. The skill states which of its checks
could not be run when they are absent rather than implying they passed.

## Full system installation

```bash
git clone <repository-url> claude-writer-suite
cd claude-writer-suite

bash tests/validate-structure.sh
bash tests/validate-rules.sh
bash tests/validate-orchestration.sh

bash install.sh
bash install.sh --configure
```

That installs 92 skills into `~/.claude/skills` and 14 agents into
`~/.claude/agents`, then asks for the user-specific values.

The installer runs `validate-structure.sh` itself and refuses to install a
repository that does not pass it.

## Partial installation

Each tree installs alone. The two cross-domain skills come with every scope,
because every tree calls them.

```bash
bash install.sh --writing      42 creative writing skills, plus shared
bash install.sh --documents     7 professional document skills, plus shared
bash install.sh --dev          41 engineering skills, 14 agents, plus shared
bash install.sh --shared        the 2 cross domain skills only
bash install.sh --agents        the 14 agents only
bash install.sh --no-agents     skills without agents
```

Scope options combine with `--zip` and `--remove`.

```bash
bash install.sh --dev --zip
bash install.sh --writing --remove
```

## Installing a single skill

Every skill is a self-contained directory. Copy it.

```bash
cp -r shared/self-critique ~/.claude/skills/
```

Before doing so, read the skill's `README.md`. It states its dependencies in
four lines. A skill with `Depends on: none` works alone. A skill that depends
on another needs that other one copied too, because it refers to it rather
than restating it.

Dependency-free and usable entirely on their own:

```
shared/self-critique
shared/project-brief
documents/documentation/document-core
engineering/dev-skills/engineering-core
engineering/devops-skills/devops-core
writing/core/writing-constitution
```

Every other skill declares its dependencies in the `depends_on` field of its
`SKILL.md` and in its README. `tests/validate-orchestration.sh` check 8
verifies that every declared dependency resolves, so the declarations are
accurate rather than aspirational.

## Archives

```bash
bash install.sh --zip
```

Builds one archive per skill in `dist/`, for a runtime that imports skills
individually. `dist/` is not tracked in version control.

## Targets

| Variable | Default | Holds |
|---|---|---|
| `CLAUDE_SKILLS_DIR` | `~/.claude/skills` | one directory per skill |
| `CLAUDE_AGENTS_DIR` | `~/.claude/agents` | one file per agent |
| `CLAUDE_CONFIG_FILE` | `~/.claude/writer-suite.config.yaml` | the user configuration |

```bash
CLAUDE_SKILLS_DIR=/opt/skills bash install.sh --dev
```

Skills are installed flat, one directory per skill name.
`tests/validate-structure.sh` refuses two skills sharing a name, so a flat
target never loses one to another.

## Using it without installing

Place the repository in the working directory and have the agent read
`README.md`, then the constitution of the tree concerned:

```
writing/core/writing-constitution            creative writing
documents/documentation/document-core        professional documents
engineering/dev-skills/engineering-core      software
engineering/devops-skills/devops-core        anything that runs
```

## Updating

```bash
git pull
bash tests/validate-structure.sh
bash install.sh
```

Installation overwrites each skill directory it manages. It never touches the
configuration file.

## Uninstalling

```bash
bash install.sh --remove             every skill and agent
bash install.sh --writing --remove   one tree
```

A scoped removal keeps the cross-domain skills, since another tree may still
use them. Only `--remove` without a scope, or `--shared --remove`, takes them
out.

Uninstalling never deletes the configuration file. Its path is printed so it
can be removed deliberately.

## Verifying the installation

```bash
ls ~/.claude/skills | wc -l      # 92 after a full install
ls ~/.claude/agents | wc -l      # 14
cat ~/.claude/writer-suite.config.yaml
```

After a full install, the installer reports whether the identity fields the
engineering tree requires are present, and names the ones that are missing. It
does not invent them.
