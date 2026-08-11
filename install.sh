#!/usr/bin/env bash
# Claude Writer Suite installer.
#
#   bash install.sh                install every skill and every agent
#   bash install.sh --writing      the creative writing tree only
#   bash install.sh --documents    the professional document tree only
#   bash install.sh --dev          the engineering tree only
#   bash install.sh --shared       the cross domain skills only
#   bash install.sh --agents       the agents only
#   bash install.sh --no-agents    skills without agents
#   bash install.sh --configure    ask for the user specific values only
#   bash install.sh --zip          also build one archive per skill in dist/
#   bash install.sh --remove       uninstall
#   bash install.sh --help         this text
#
# Scope options combine with --zip and --remove:
#
#   bash install.sh --dev --zip
#   bash install.sh --writing --remove
#
# Targets, all overridable:
#
#   CLAUDE_SKILLS_DIR   default ~/.claude/skills
#   CLAUDE_AGENTS_DIR   default ~/.claude/agents
#   CLAUDE_CONFIG_FILE  default ~/.claude/writer-suite.config.yaml
set -u

ROOT="$(cd "$(dirname "$0")" && pwd)"
TARGET="${CLAUDE_SKILLS_DIR:-$HOME/.claude/skills}"
AGENT_TARGET="${CLAUDE_AGENTS_DIR:-$HOME/.claude/agents}"
CONFIG_FILE="${CLAUDE_CONFIG_FILE:-$HOME/.claude/writer-suite.config.yaml}"

# A skill group is a repository relative path holding skill directories.
WRITING_GROUPS="writing/core writing/genres writing/poetry writing/quality"
DOCUMENT_GROUPS="documents/documentation documents/administrative documents/publishing"
ENGINEERING_GROUPS="engineering/dev-skills engineering/delivery-skills engineering/devops-skills"
SHARED_GROUPS="shared"

MODE="install"
SCOPE="all"
WITH_AGENTS="yes"
WITH_SKILLS="yes"
WITH_SHARED="yes"

usage() {
  sed -n '2,30p' "$0" | sed 's/^# \{0,1\}//'
}

for arg in "$@"; do
  case "$arg" in
    --help|-h)   usage; exit 0 ;;
    --remove)    MODE="remove" ;;
    --zip)       MODE="zip" ;;
    --configure) MODE="configure" ;;
    --writing)   SCOPE="writing";   WITH_AGENTS="no" ;;
    --documents) SCOPE="documents"; WITH_AGENTS="no" ;;
    --dev)       SCOPE="dev" ;;
    --shared)    SCOPE="shared";    WITH_AGENTS="no" ;;
    --agents)    WITH_SKILLS="no";  WITH_AGENTS="yes" ;;
    --no-agents) WITH_AGENTS="no" ;;
    *)
      printf 'Unknown option: %s\n\n' "$arg"
      usage
      exit 1
      ;;
  esac
done

# The cross domain skills belong to every scope, because every tree calls
# them. They are only uninstalled by an unscoped removal or by --shared,
# so removing one tree never breaks another.
case "$SCOPE" in
  writing)   SKILL_GROUPS="$WRITING_GROUPS $SHARED_GROUPS" ;;
  documents) SKILL_GROUPS="$DOCUMENT_GROUPS $SHARED_GROUPS" ;;
  dev)       SKILL_GROUPS="$ENGINEERING_GROUPS $SHARED_GROUPS" ;;
  shared)    SKILL_GROUPS="$SHARED_GROUPS" ;;
  *)         SKILL_GROUPS="$WRITING_GROUPS $DOCUMENT_GROUPS $ENGINEERING_GROUPS $SHARED_GROUPS" ;;
esac

case "$SCOPE" in
  all|shared) REMOVE_SHARED="yes" ;;
  *)          REMOVE_SHARED="no" ;;
esac

skills() {
  for group in $SKILL_GROUPS; do
    for skill in "$ROOT/$group"/*/; do
      [ -d "$skill" ] && printf '%s\n' "$skill"
    done
  done
}

removable_skills() {
  for group in $SKILL_GROUPS; do
    case "$group" in
      shared) [ "$REMOVE_SHARED" = "yes" ] || continue ;;
    esac
    for skill in "$ROOT/$group"/*/; do
      [ -d "$skill" ] && printf '%s\n' "$skill"
    done
  done
}

# Agents are single files. README and the handoff protocol are documentation,
# not agent definitions, and are not installed.
agents() {
  for agent in "$ROOT/engineering/agents"/*.md; do
    [ -f "$agent" ] || continue
    case "$(basename "$agent")" in
      README.md|handoff-protocol.md) continue ;;
    esac
    printf '%s\n' "$agent"
  done
}

# ---------------------------------------------------------------------------
# Configuration
# ---------------------------------------------------------------------------

# Current value of section.key in the configuration file, empty when absent.
config_get() {
  [ -f "$CONFIG_FILE" ] || return 0
  awk -v section="$1:" -v key="  $2:" '
    $0 == section { inside = 1; next }
    /^[a-z]/ { inside = 0 }
    inside && index($0, key) == 1 {
      value = substr($0, length(key) + 1)
      gsub(/^[ \t]+|[ \t]+$/, "", value)
      gsub(/^"|"$/, "", value)
      print value
      exit
    }
  ' "$CONFIG_FILE"
}

# A credential must never reach this file.
looks_like_secret() {
  printf '%s' "$1" | grep -Eiq 'key|token|secret|password|passwd|credential'
}

# An author must be a person, not the tool that typed for them.
looks_like_a_tool() {
  printf '%s' "$1" | grep -Eiq '(^|[^a-z])(ai|bot|gpt|llm|claude|chatgpt|openai|anthropic|copilot|assistant|generated|generator)([^a-z]|$)'
}

valid_email() {
  printf '%s' "$1" | grep -Eq '^[^@[:space:]]+@[^@[:space:]]+\.[^@[:space:]]+$'
}

in_list() {
  needle="$1"; shift
  for candidate in "$@"; do
    [ "$needle" = "$candidate" ] && return 0
  done
  return 1
}

# ask <section> <key> <prompt> <required:yes|no> <fallback> [allowed...]
ask() {
  local section="$1" key="$2" prompt="$3" required="$4" fallback="$5"
  shift 5
  local allowed="$*"
  local current answer

  if looks_like_secret "$key"; then
    printf '  refused: %s.%s looks like a credential and is not stored here\n' \
      "$section" "$key"
    return 0
  fi

  current="$(config_get "$section" "$key")"
  [ -n "$current" ] || current="$fallback"

  while true; do
    if [ -n "$current" ]; then
      printf '  %s [%s]: ' "$prompt" "$current"
    elif [ "$required" = "yes" ]; then
      printf '  %s (required): ' "$prompt"
    else
      printf '  %s (optional, enter to skip): ' "$prompt"
    fi
    IFS= read -r answer || answer=""
    [ -n "$answer" ] || answer="$current"

    if [ -z "$answer" ] && [ "$required" = "yes" ]; then
      printf '    this field has no default, and no value is invented for you\n'
      continue
    fi
    if [ -n "$allowed" ] && [ -n "$answer" ] && ! in_list "$answer" $allowed; then
      printf '    accepted values: %s\n' "$allowed"
      continue
    fi
    if [ "$key" = "author_email" ] && [ -n "$answer" ] && ! valid_email "$answer"; then
      printf '    not an email address\n'
      continue
    fi
    if { [ "$key" = "author_name" ] || [ "$key" = "author_email" ]; } \
       && [ -n "$answer" ] && looks_like_a_tool "$answer"; then
      printf '    an author is a person, not a tool; history has to stay auditable\n'
      continue
    fi
    break
  done

  eval "CFG_${section}_${key}=\"\$answer\""
}

value_of() {
  eval "printf '%s' \"\${CFG_$1_$2:-}\""
}

# choose <section> <key> <prompt> <recommended_index> <label|value> ...
# Numbered menu. The recommended option is marked and pre-selected, so the
# usual answer is the enter key.
choose() {
  local section="$1" key="$2" prompt="$3" recommended="$4"
  shift 4
  local labels=() values=() pair i
  for pair in "$@"; do
    labels+=("${pair%%|*}")
    values+=("${pair##*|}")
  done

  local current default_index="$recommended"
  current="$(config_get "$section" "$key")"
  for i in "${!values[@]}"; do
    [ "${values[$i]}" = "$current" ] && default_index=$((i + 1))
  done

  printf '\n  %s\n' "$prompt"
  for i in "${!labels[@]}"; do
    if [ $((i + 1)) -eq "$recommended" ]; then
      printf '    %d) %s   (recommended)\n' "$((i + 1))" "${labels[$i]}"
    else
      printf '    %d) %s\n' "$((i + 1))" "${labels[$i]}"
    fi
  done

  local answer
  while true; do
    printf '  Choice [%d]: ' "$default_index"
    IFS= read -r answer || answer=""
    [ -n "$answer" ] || answer="$default_index"
    case "$answer" in
      *[!0-9]*|'') printf '    enter a number between 1 and %d\n' "${#values[@]}"; continue ;;
    esac
    if [ "$answer" -ge 1 ] && [ "$answer" -le "${#values[@]}" ]; then
      eval "CFG_${section}_${key}=\"\${values[\$((answer - 1))]}\""
      return 0
    fi
    printf '    enter a number between 1 and %d\n' "${#values[@]}"
  done
}

configure() {
  if [ ! -t 0 ]; then
    printf 'Configuration needs a terminal.\n'
    printf 'Non interactive alternative: copy config/writer-suite.config.example.yaml\n'
    printf 'to %s and edit it.\n' "$CONFIG_FILE"
    exit 1
  fi

  printf 'Claude Writer Suite configuration\n'
  printf 'File: %s\n\n' "$CONFIG_FILE"
  printf 'Every question has a recommended answer, already selected.\n'
  printf 'Press enter to accept it. Values in brackets are what is stored now.\n'
  printf 'Answer no to anything you would rather do yourself: the agent will\n'
  printf 'stop at that boundary and list the step for you instead.\n'
  printf 'Never put a secret here. Field reference: config/README.md\n'

  local need_engineering=no need_writing=no need_documents=no
  case "$SCOPE" in
    all)       need_engineering=yes; need_writing=yes; need_documents=yes ;;
    dev)       need_engineering=yes ;;
    writing)   need_writing=yes ;;
    documents) need_documents=yes ;;
    shared)    ;;
  esac

  if [ "$need_engineering" = "yes" ]; then
    printf '\n--- Identity, used on every commit ---\n'
    ask identity author_name  "Author name"  yes ""
    ask identity author_email "Author email" yes ""

    printf '\n--- What the agent may do on your repository ---\n'
    printf 'Each no is a step that moves to your manual task list.\n'

    choose delegation commits "May the agent create commits?" 1 \
      "Yes, atomic commits following the convention below|yes" \
      "Yes, but stage only and let me write the message|stage-only" \
      "No, I commit myself|no"

    choose delegation branches "May the agent create branches?" 1 \
      "Yes, following the branch convention below|yes" \
      "No, I create branches and tell it which one to use|no"

    choose delegation push "May the agent push?" 2 \
      "Yes, including the default branch|yes" \
      "Yes, but never to a protected branch|branch-only" \
      "No, I push myself|no"

    choose delegation pull_requests "May the agent open pull requests?" 1 \
      "Yes, with the full description|yes" \
      "Yes, but as a draft only|draft" \
      "No, I open them myself|no"

    choose git protected_branches "Which branches are protected, so nothing reaches them without a pull request?" 1 \
      "The default branch only|default" \
      "The default branch and any release branch|default+release" \
      "None, direct pushes are allowed|none"

    choose delegation release_tags "May the agent create version tags and releases?" 2 \
      "Yes|yes" \
      "No, I tag and release myself|no"

    choose delegation deployments "May the agent deploy?" 3 \
      "Yes, to any environment|yes" \
      "Yes, but never to production|non-production" \
      "No, it prepares and I deploy|no"

    choose delegation database_operations "May the agent run migrations and data operations on a live database?" 3 \
      "Yes|yes" \
      "Yes, but never on production|non-production" \
      "No, it writes the migration and I run it|no"

    choose delegation dependency_changes "May the agent add or upgrade dependencies?" 2 \
      "Yes|yes" \
      "Yes, but it must justify each one first|with-justification" \
      "No|no"

    printf '\n--- Version control conventions ---\n'
    choose git commit_convention "Commit message convention" 1 \
      "Conventional, feat: add user profile endpoint|conventional" \
      "Plain imperative, Add user profile endpoint|plain"

    choose git branch_convention "Branch naming" 1 \
      "type/short-kebab-description, for example feat/team-invitations|type/short-kebab-description" \
      "username/description|username/description" \
      "ticket-id-description, for example PROJ-142-invitations|ticket-id-description"

    ask git default_branch "Default branch" no main

    printf '\n--- Engineering defaults ---\n'
    printf 'Empty means detect it from the project, which is what the skills do anyway.\n'
    ask engineering package_manager     "Preferred package manager"   no ""
    ask engineering deployment_platform "Preferred deployment target" no ""
    ask engineering database            "Preferred database"          no ""

    choose language documentation "Language of the technical documentation the agent writes" 1 \
      "English|english" "French|french" "Spanish|spanish" \
      "German|german" "Portuguese|portuguese" "Italian|italian"
  fi

  if [ "$need_writing" = "yes" ]; then
    printf '\n--- Creative writing ---\n'
    choose language creative_output "Default output language for fiction and poetry" 1 \
      "French, the craft these skills encode|french" \
      "English|english" "Spanish|spanish" \
      "German|german" "Portuguese|portuguese" "Italian|italian"
  fi

  if [ "$need_documents" = "yes" ]; then
    printf '\n--- Professional documents ---\n'
    ask identity organization "Organisation name on covers and letterheads" no ""

    choose language document_output "Default output language for documents, override it per recipient" 1 \
      "English|english" "French|french" "Spanish|spanish" \
      "German|german" "Portuguese|portuguese" "Italian|italian"

    choose documents pdf_engine "PDF engine" 1 \
      "Choose per document, then verify it is installed|" \
      "Headless Chromium|chromium" "WeasyPrint|weasyprint" \
      "Typst|typst" "LaTeX|latex"

    choose documents page_size "Page size" 1 "A4|A4" "US Letter|Letter"

    choose documents date_format "Date format" 1 \
      "ISO, 2026-08-11|iso" "French, 11 aout 2026|fr" "US, August 11, 2026|us"
  fi

  mkdir -p "$(dirname "$CONFIG_FILE")"
  {
    printf '# Claude Writer Suite configuration\n'
    printf '# Written by install.sh --configure. Never store a secret here.\n'
    printf '# Field reference: config/README.md\n\n'
    printf 'identity:\n'
    printf '  author_name: "%s"\n'  "$(value_of identity author_name)"
    printf '  author_email: "%s"\n' "$(value_of identity author_email)"
    printf '  organization: "%s"\n' "$(value_of identity organization)"
    printf '\ndelegation:\n'
    printf '  commits: %s\n'             "$(value_of delegation commits)"
    printf '  branches: %s\n'            "$(value_of delegation branches)"
    printf '  push: %s\n'                "$(value_of delegation push)"
    printf '  pull_requests: %s\n'       "$(value_of delegation pull_requests)"
    printf '  release_tags: %s\n'        "$(value_of delegation release_tags)"
    printf '  deployments: %s\n'         "$(value_of delegation deployments)"
    printf '  database_operations: %s\n' "$(value_of delegation database_operations)"
    printf '  dependency_changes: %s\n'  "$(value_of delegation dependency_changes)"
    printf '\ngit:\n'
    printf '  commit_convention: %s\n'   "$(value_of git commit_convention)"
    printf '  branch_convention: "%s"\n' "$(value_of git branch_convention)"
    printf '  default_branch: %s\n'      "$(value_of git default_branch)"
    printf '  protected_branches: %s\n'  "$(value_of git protected_branches)"
    printf '\nlanguage:\n'
    printf '  skill: english\n'
    printf '  documentation: %s\n'    "$(value_of language documentation)"
    printf '  creative_output: %s\n'  "$(value_of language creative_output)"
    printf '  document_output: %s\n'  "$(value_of language document_output)"
    printf '\nengineering:\n'
    printf '  package_manager: "%s"\n'     "$(value_of engineering package_manager)"
    printf '  deployment_platform: "%s"\n' "$(value_of engineering deployment_platform)"
    printf '  database: "%s"\n'            "$(value_of engineering database)"
    printf '\ndocuments:\n'
    printf '  pdf_engine: "%s"\n' "$(value_of documents pdf_engine)"
    printf '  page_size: %s\n'    "$(value_of documents page_size)"
    printf '  date_format: %s\n'  "$(value_of documents date_format)"
  } > "$CONFIG_FILE"

  chmod 600 "$CONFIG_FILE" 2>/dev/null || true
  printf '\nWritten: %s\n' "$CONFIG_FILE"

  write_manual_tasks
}

# Everything the agent was told not to do becomes a step somebody has to
# perform. This file is that list, with the commands, so nothing is silently
# left undone.
write_manual_tasks() {
  local file="${CLAUDE_MANUAL_TASKS_FILE:-$(dirname "$CONFIG_FILE")/writer-suite-manual-tasks.md}"
  local branch commits push prs tags deploys dbops deps protected count=0
  branch="$(value_of git default_branch)";      [ -n "$branch" ] || branch=main
  commits="$(value_of delegation commits)"
  push="$(value_of delegation push)"
  prs="$(value_of delegation pull_requests)"
  tags="$(value_of delegation release_tags)"
  deploys="$(value_of delegation deployments)"
  dbops="$(value_of delegation database_operations)"
  deps="$(value_of delegation dependency_changes)"
  protected="$(value_of git protected_branches)"

  {
    printf '# Your manual steps\n\n'
    printf 'Generated by `bash install.sh --configure` on %s.\n\n' "$(date +%Y-%m-%d)"
    printf 'These are the actions you asked to keep. The agent will stop at each\n'
    printf 'boundary, hand you what it prepared, and name the step rather than\n'
    printf 'performing it. Re-run `--configure` to change any of them.\n\n'
    printf '## What you kept\n\n'

    case "$commits" in
      stage-only)
        count=$((count + 1))
        printf '### Commits\n\n'
        printf 'The agent stages the change and gives you the message it would have used.\n\n'
        printf '```bash\ngit diff --staged     # read it before committing\ngit commit\n```\n\n'
        ;;
      no)
        count=$((count + 1))
        printf '### Commits\n\n'
        printf 'The agent leaves the working tree ready and lists the atomic commits it\n'
        printf 'would have made, in order, with a message for each.\n\n'
        printf '```bash\ngit status\ngit diff\ngit add -p\ngit commit\n```\n\n'
        ;;
    esac

    [ "$(value_of delegation branches)" = "no" ] && {
      count=$((count + 1))
      printf '### Branches\n\n'
      printf 'Create the branch before asking for work, and tell the agent its name.\n\n'
      printf '```bash\ngit switch -c <type>/<short-description>\n```\n\n'
    }

    case "$push" in
      branch-only)
        count=$((count + 1))
        printf '### Pushing to a protected branch\n\n'
        printf 'The agent pushes feature branches only. Anything reaching `%s` is yours.\n\n' "$branch"
        ;;
      no)
        count=$((count + 1))
        printf '### Pushing\n\n'
        printf 'The agent commits locally and stops. Every push is yours.\n\n'
        printf '```bash\ngit log --oneline origin/%s..HEAD    # review first\ngit push -u origin HEAD\n```\n\n' "$branch"
        ;;
    esac

    case "$prs" in
      draft)
        count=$((count + 1))
        printf '### Marking a pull request ready\n\n'
        printf 'The agent opens drafts. Reviewing and marking ready is yours.\n\n'
        ;;
      no)
        count=$((count + 1))
        printf '### Pull requests\n\n'
        printf 'The agent writes the description into the branch and stops. Open it yourself.\n\n'
        printf '```bash\ngh pr create --fill\n```\n\n'
        ;;
    esac

    [ "$tags" = "no" ] && {
      count=$((count + 1))
      printf '### Tags and releases\n\n'
      printf 'The agent prepares the changelog and the version number, then stops.\n\n'
      printf '```bash\ngit tag -a v<x.y.z> -m "<summary>"\ngit push origin v<x.y.z>\n```\n\n'
    }

    case "$deploys" in
      non-production)
        count=$((count + 1))
        printf '### Production deployment\n\n'
        printf 'The agent deploys to non production environments and verifies them.\n'
        printf 'Promotion to production is yours, and so is running\n'
        printf '`production-verification` afterwards.\n\n'
        ;;
      no)
        count=$((count + 1))
        printf '### Deployment\n\n'
        printf 'The agent prepares the artefact, the migrations and the environment\n'
        printf 'variable list, then stops. Every deployment is yours.\n\n'
        ;;
    esac

    case "$dbops" in
      non-production)
        count=$((count + 1))
        printf '### Production database operations\n\n'
        printf 'The agent runs migrations outside production only. Production runs are\n'
        printf 'yours, after the row count check the migration note gives you.\n\n'
        ;;
      no)
        count=$((count + 1))
        printf '### Database operations\n\n'
        printf 'The agent writes the migration and the rollback, and states what each\n'
        printf 'one locks and for how long. Running them is yours.\n\n'
      ;;
    esac

    case "$deps" in
      with-justification)
        count=$((count + 1))
        printf '### Approving dependencies\n\n'
        printf 'The agent proposes each dependency with the twelve point evaluation from\n'
        printf '`dependency-selection`. Approval is yours before it installs anything.\n\n'
        ;;
      no)
        count=$((count + 1))
        printf '### Dependencies\n\n'
        printf 'The agent names what it needs and why, and writes the code against it.\n'
        printf 'Installing is yours.\n\n'
        printf '```bash\n<your package manager> add <package>\n```\n\n'
        ;;
    esac

    if [ "$count" -eq 0 ]; then
      printf 'Nothing. You delegated every step, so the agent carries the work from\n'
      printf 'the first commit to the verified deployment.\n\n'
      printf 'Two things are never delegated, whatever this file says:\n\n'
      printf '- A destructive operation is always counted and confirmed first.\n'
      printf '- A secret is never committed, and a leaked one is reported for\n'
      printf '  rotation rather than quietly removed.\n\n'
    fi

    printf '## Branch protection\n\n'
    case "$protected" in
      none)
        printf 'You allowed direct pushes. If you later protect `%s`, re-run\n' "$branch"
        printf '`--configure` so the agent switches to the pull request path.\n\n'
        ;;
      default)
        printf '`%s` is protected: nothing reaches it without a pull request.\n' "$branch"
        printf 'The agent never pushes to it directly, and never force pushes a shared\n'
        printf 'branch.\n\n'
        ;;
      default+release)
        printf '`%s` and the release branches are protected: nothing reaches them\n' "$branch"
        printf 'without a pull request. The agent never pushes to them directly.\n\n'
        ;;
    esac
    printf 'If protection is not configured on the host yet:\n\n'
    printf '```bash\ngh api -X PUT repos/{owner}/{repo}/branches/%s/protection \\\n' "$branch"
    printf '  -f required_pull_request_reviews.required_approving_review_count=1\n```\n\n'

    printf '## Files that must never be committed\n\n'
    printf 'Your responsibility as much as the agent'"'"'s. Verify the ignore file covers:\n\n'
    printf '```\n.env and .env.*\nprivate keys, certificates, credential files\nlocal agent and editor configuration\n```\n\n'
    printf 'A secret already committed is not fixed by deleting it. Rotate it.\n\n'
    printf '## Changing any of this\n\n'
    printf '```bash\nbash install.sh --configure\n```\n\n'
    printf 'Answers are pre-filled with what you chose. This file is rewritten.\n'
  } > "$file"

  printf 'Written: %s\n' "$file"
  printf 'Read it: it lists the steps you kept, with their commands.\n'
}

# Reports what the installed skills still need. Never guesses a value.
report_configuration_state() {
  local needs_identity=no
  case "$SCOPE" in
    all|dev) needs_identity=yes ;;
  esac
  [ "$needs_identity" = "yes" ] || return 0

  if [ ! -f "$CONFIG_FILE" ]; then
    printf 'Configuration missing: %s\n' "$CONFIG_FILE"
    printf 'git-workflow stops without an author identity. Run: bash install.sh --configure\n'
    return 0
  fi
  local name email
  name="$(config_get identity author_name)"
  email="$(config_get identity author_email)"
  if [ -z "$name" ] || [ -z "$email" ]; then
    printf 'Configuration incomplete in %s:\n' "$CONFIG_FILE"
    [ -n "$name" ]  || printf '  identity.author_name is empty\n'
    [ -n "$email" ] || printf '  identity.author_email is empty\n'
    printf 'Run: bash install.sh --configure\n'
  fi
}

# ---------------------------------------------------------------------------
# Modes
# ---------------------------------------------------------------------------

if [ "$MODE" = "configure" ]; then
  configure
  exit 0
fi

if [ "$MODE" = "remove" ]; then
  count=0
  if [ "$WITH_SKILLS" = "yes" ]; then
    while IFS= read -r skill; do
      name="$(basename "$skill")"
      if [ -d "$TARGET/$name" ]; then
        rm -rf "${TARGET:?}/$name"
        count=$((count + 1))
      fi
    done < <(removable_skills)
    printf '%s skills removed from %s\n' "$count" "$TARGET"
    [ "$REMOVE_SHARED" = "yes" ] \
      || printf 'Cross domain skills kept: another tree may still use them.\n'
  fi
  if [ "$WITH_AGENTS" = "yes" ]; then
    acount=0
    while IFS= read -r agent; do
      name="$(basename "$agent")"
      if [ -f "$AGENT_TARGET/$name" ]; then
        rm -f "${AGENT_TARGET:?}/$name"
        acount=$((acount + 1))
      fi
    done < <(agents)
    printf '%s agents removed from %s\n' "$acount" "$AGENT_TARGET"
  fi
  printf 'Configuration left untouched: %s\n' "$CONFIG_FILE"
  exit 0
fi

bash "$ROOT/tests/validate-structure.sh" >/dev/null || {
  printf 'Structure invalid, installation stopped. Run tests/validate-structure.sh for the detail.\n'
  exit 1
}

if [ "$WITH_SKILLS" = "yes" ]; then
  mkdir -p "$TARGET"
  count=0
  while IFS= read -r skill; do
    name="$(basename "$skill")"
    rm -rf "${TARGET:?}/$name"
    cp -r "$skill" "$TARGET/$name"
    count=$((count + 1))
  done < <(skills)
  printf '%s skills installed in %s\n' "$count" "$TARGET"
fi

if [ "$WITH_AGENTS" = "yes" ]; then
  mkdir -p "$AGENT_TARGET"
  acount=0
  while IFS= read -r agent; do
    cp "$agent" "$AGENT_TARGET/$(basename "$agent")"
    acount=$((acount + 1))
  done < <(agents)
  printf '%s agents installed in %s\n' "$acount" "$AGENT_TARGET"
fi

if [ "$MODE" = "zip" ]; then
  command -v zip >/dev/null || { printf 'zip not found, archives not built.\n'; exit 0; }
  mkdir -p "$ROOT/dist"
  rm -f "$ROOT"/dist/*.zip
  while IFS= read -r skill; do
    name="$(basename "$skill")"
    parent="$(dirname "$skill")"
    ( cd "$parent" && zip -rq "$ROOT/dist/$name.zip" "$name" )
  done < <(skills)
  printf '%s archives built in dist/\n' "$(ls "$ROOT"/dist/*.zip | wc -l)"
fi

report_configuration_state
