#!/usr/bin/env bash
# Vérifie la structure obligatoire de chaque skill de la suite.
# Usage : bash tests/validate-structure.sh
set -u

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
CATEGORIES="core genres poetry quality"
ERRORS=0
SKILLS=0

fail() {
  printf 'ERREUR  %s\n' "$1"
  ERRORS=$((ERRORS + 1))
}

for category in $CATEGORIES; do
  if [ ! -d "$ROOT/$category" ]; then
    fail "catégorie manquante : $category"
    continue
  fi
  for skill in "$ROOT/$category"/*/; do
    [ -d "$skill" ] || continue
    name="$(basename "$skill")"
    SKILLS=$((SKILLS + 1))

    [ -f "$skill/SKILL.md" ]  || fail "$category/$name : SKILL.md manquant"
    [ -f "$skill/README.md" ] || fail "$category/$name : README.md manquant"
    [ -d "$skill/examples" ]  || fail "$category/$name : dossier examples manquant"
    [ -d "$skill/resources" ] || fail "$category/$name : dossier resources manquant"

    if [ -d "$skill/examples" ] && [ -z "$(ls -A "$skill/examples" 2>/dev/null)" ]; then
      fail "$category/$name : examples est vide"
    fi
    if [ -d "$skill/resources" ] && [ -z "$(ls -A "$skill/resources" 2>/dev/null)" ]; then
      fail "$category/$name : resources est vide"
    fi

    if [ -f "$skill/SKILL.md" ]; then
      head -n 1 "$skill/SKILL.md" | grep -q '^---$' \
        || fail "$category/$name : bloc de métadonnées absent"
      for key in name description license metadata; do
        grep -q "^$key:" "$skill/SKILL.md" \
          || fail "$category/$name : clé de métadonnée manquante ($key)"
      done
      for key in category version depends_on outputs; do
        grep -q "^  $key:" "$skill/SKILL.md" \
          || fail "$category/$name : clé de metadata manquante ($key)"
      done
      grep -q "^name: $name$" "$skill/SKILL.md" \
        || fail "$category/$name : le champ name ne correspond pas au dossier"
      grep -q "^  category: $category$" "$skill/SKILL.md" \
        || fail "$category/$name : le champ category ne correspond pas au dossier"
      desc="$(grep -m1 '^description:' "$skill/SKILL.md" | cut -c14-)"
      [ "${#desc}" -ge 40 ] \
        || fail "$category/$name : description trop courte pour être découverte"
      grep -qi '^## .*[Aa]uto-critique' "$skill/SKILL.md" \
        || fail "$category/$name : section Auto-critique absente"
    fi
  done
done

for f in CLAUDE.md README.md CONTRIBUTING.md LICENSE; do
  [ -f "$ROOT/$f" ] || fail "fichier racine manquant : $f"
done
for d in resources examples documentation tests; do
  [ -d "$ROOT/$d" ] || fail "dossier racine manquant : $d"
done
for f in architecture.md skills-guide.md writing-rules.md workflow.md; do
  [ -f "$ROOT/documentation/$f" ] || fail "documentation manquante : $f"
done

printf '\n%s skills contrôlés, %s erreurs.\n' "$SKILLS" "$ERRORS"
[ "$ERRORS" -eq 0 ] || exit 1
printf 'Structure conforme.\n'
