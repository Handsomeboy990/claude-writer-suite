#!/usr/bin/env bash
# Installe les skills de Claude Writer Suite dans le répertoire personnel
# de l'agent, puis prépare les archives destinées à un import manuel.
#
# Usage :
#   bash install.sh              installe les 83 skills et les 14 agents
#   bash install.sh --writing    installe les 42 skills d'écriture seulement
#   bash install.sh --dev        installe les 41 skills d'ingénierie seulement
#   bash install.sh --agents     installe les agents seulement
#   bash install.sh --no-agents  installe les skills sans les agents
#   bash install.sh --zip        construit aussi les archives dans dist/
#   bash install.sh --remove     désinstalle
#
# Les options de portée se combinent avec --zip et --remove :
#   bash install.sh --dev --zip
#   bash install.sh --writing --remove
#
# Les skills vont dans ~/.claude/skills, les agents dans ~/.claude/agents.
# Les répertoires cibles sont configurables par CLAUDE_SKILLS_DIR et
# CLAUDE_AGENTS_DIR.
set -u

ROOT="$(cd "$(dirname "$0")" && pwd)"
TARGET="${CLAUDE_SKILLS_DIR:-$HOME/.claude/skills}"
AGENT_TARGET="${CLAUDE_AGENTS_DIR:-$HOME/.claude/agents}"
WRITING_CATEGORIES="core genres poetry quality"
DEV_CATEGORIES="dev-skills delivery-skills devops-skills"

# Le repository sépare deux arbres ; l'arbre est un préfixe de chemin.
tree_of() {
  case "$1" in
    core|genres|poetry|quality) printf 'writing' ;;
    *) printf 'engineering' ;;
  esac
}

MODE="install"
SCOPE="all"
WITH_AGENTS="yes"
WITH_SKILLS="yes"

for arg in "$@"; do
  case "$arg" in
    --remove)    MODE="remove" ;;
    --zip)       MODE="zip" ;;
    --writing)   SCOPE="writing"; WITH_AGENTS="no" ;;
    --dev)       SCOPE="dev" ;;
    --agents)    WITH_SKILLS="no"; WITH_AGENTS="yes" ;;
    --no-agents) WITH_AGENTS="no" ;;
    *)
      printf 'Option inconnue : %s\n' "$arg"
      exit 1
      ;;
  esac
done

case "$SCOPE" in
  writing) CATEGORIES="$WRITING_CATEGORIES" ;;
  dev)     CATEGORIES="$DEV_CATEGORIES" ;;
  *)       CATEGORIES="$WRITING_CATEGORIES $DEV_CATEGORIES" ;;
esac

skills() {
  for category in $CATEGORIES; do
    tree="$(tree_of "$category")"
    for skill in "$ROOT/$tree/$category"/*/; do
      [ -d "$skill" ] && printf '%s\n' "$skill"
    done
  done
}

# Les agents sont des fichiers uniques ; README et protocole ne sont pas des
# définitions d'agent et ne sont pas installés.
agents() {
  for agent in "$ROOT/engineering/agents"/*.md; do
    [ -f "$agent" ] || continue
    case "$(basename "$agent")" in
      README.md|handoff-protocol.md) continue ;;
    esac
    printf '%s\n' "$agent"
  done
}

if [ "$MODE" = "remove" ]; then
  count=0
  if [ "$WITH_SKILLS" = "yes" ]; then
    while IFS= read -r skill; do
      name="$(basename "$skill")"
      if [ -d "$TARGET/$name" ]; then
        rm -rf "${TARGET:?}/$name"
        count=$((count + 1))
      fi
    done < <(skills)
    printf '%s skills retirés de %s\n' "$count" "$TARGET"
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
    printf '%s agents retirés de %s\n' "$acount" "$AGENT_TARGET"
  fi
  exit 0
fi

bash "$ROOT/tests/validate-structure.sh" >/dev/null || {
  printf 'Structure invalide, installation interrompue.\n'
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
  printf '%s skills installés dans %s\n' "$count" "$TARGET"
fi

if [ "$WITH_AGENTS" = "yes" ]; then
  mkdir -p "$AGENT_TARGET"
  acount=0
  while IFS= read -r agent; do
    cp "$agent" "$AGENT_TARGET/$(basename "$agent")"
    acount=$((acount + 1))
  done < <(agents)
  printf '%s agents installés dans %s\n' "$acount" "$AGENT_TARGET"
fi

if [ "$MODE" = "zip" ]; then
  command -v zip >/dev/null || { printf 'zip absent, archives non construites.\n'; exit 0; }
  mkdir -p "$ROOT/dist"
  rm -f "$ROOT"/dist/*.zip
  while IFS= read -r skill; do
    name="$(basename "$skill")"
    parent="$(dirname "$skill")"
    ( cd "$parent" && zip -rq "$ROOT/dist/$name.zip" "$name" )
  done < <(skills)
  printf '%s archives construites dans dist/\n' "$(ls "$ROOT"/dist/*.zip | wc -l)"
fi
