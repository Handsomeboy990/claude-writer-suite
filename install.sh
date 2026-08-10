#!/usr/bin/env bash
# Installe les skills de Claude Writer Suite dans le répertoire personnel
# de l'agent, puis prépare les archives destinées à un import manuel.
#
# Usage :
#   bash install.sh              installe les 62 skills dans ~/.claude/skills
#   bash install.sh --writing    installe les 42 skills d'écriture seulement
#   bash install.sh --dev        installe les 20 skills d'ingénierie seulement
#   bash install.sh --zip        construit aussi les archives dans dist/
#   bash install.sh --remove     désinstalle
#
# Les options de portée se combinent avec --zip et --remove :
#   bash install.sh --dev --zip
#   bash install.sh --writing --remove
set -u

ROOT="$(cd "$(dirname "$0")" && pwd)"
TARGET="${CLAUDE_SKILLS_DIR:-$HOME/.claude/skills}"
WRITING_CATEGORIES="core genres poetry quality"
DEV_CATEGORIES="dev-skills"

MODE="install"
SCOPE="all"

for arg in "$@"; do
  case "$arg" in
    --remove)  MODE="remove" ;;
    --zip)     MODE="zip" ;;
    --writing) SCOPE="writing" ;;
    --dev)     SCOPE="dev" ;;
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
    for skill in "$ROOT/$category"/*/; do
      [ -d "$skill" ] && printf '%s\n' "$skill"
    done
  done
}

if [ "$MODE" = "remove" ]; then
  count=0
  while IFS= read -r skill; do
    name="$(basename "$skill")"
    if [ -d "$TARGET/$name" ]; then
      rm -rf "${TARGET:?}/$name"
      count=$((count + 1))
    fi
  done < <(skills)
  printf '%s skills retirés de %s\n' "$count" "$TARGET"
  exit 0
fi

bash "$ROOT/tests/validate-structure.sh" >/dev/null || {
  printf 'Structure invalide, installation interrompue.\n'
  exit 1
}

mkdir -p "$TARGET"
count=0
while IFS= read -r skill; do
  name="$(basename "$skill")"
  rm -rf "${TARGET:?}/$name"
  cp -r "$skill" "$TARGET/$name"
  count=$((count + 1))
done < <(skills)
printf '%s skills installés dans %s\n' "$count" "$TARGET"

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
