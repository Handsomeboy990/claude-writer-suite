#!/usr/bin/env bash
# Vérifie la structure obligatoire de chaque skill de la suite.
# Usage : bash tests/validate-structure.sh
set -u

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
WRITING_CATEGORIES="core genres poetry quality"
ENGINEERING_CATEGORIES="dev-skills delivery-skills devops-skills"
ERRORS=0
SKILLS=0

fail() {
  printf 'ERREUR  %s\n' "$1"
  ERRORS=$((ERRORS + 1))
}

# Le repository sépare deux arbres. Le nom de catégorie reste celui du dossier
# de skills ; l'arbre n'est qu'un préfixe de chemin.
tree_of() {
  case "$1" in
    core|genres|poetry|quality) printf 'writing' ;;
    *) printf 'engineering' ;;
  esac
}

for category in $WRITING_CATEGORIES $ENGINEERING_CATEGORIES; do
  tree="$(tree_of "$category")"
  if [ ! -d "$ROOT/$tree/$category" ]; then
    fail "catégorie manquante : $tree/$category"
    continue
  fi
  for skill in "$ROOT/$tree/$category"/*/; do
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
      # Les trois catégories d'ingénierie imposent en plus une section
      # Protocol numérotée et une section Interfaces. Les skills d'écriture
      # nomment leur procédure de façons variées, héritées de leur domaine.
      case "$category" in
        dev-skills|delivery-skills|devops-skills) engineering=1 ;;
        *) engineering=0 ;;
      esac
      if [ "$engineering" -eq 1 ]; then
        grep -qE '^## [0-9]+\. Protocol' "$skill/SKILL.md" \
          || fail "$category/$name : section Protocol numérotée absente"
        grep -qE '^## [0-9]+\. Interfaces' "$skill/SKILL.md" \
          || fail "$category/$name : section Interfaces absente"
      fi
    fi
  done
done

for f in CLAUDE.md README.md CONTRIBUTING.md LICENSE; do
  [ -f "$ROOT/$f" ] || fail "fichier racine manquant : $f"
done
for d in writing engineering documentation tests \
         writing/resources writing/examples engineering/agents; do
  [ -d "$ROOT/$d" ] || fail "dossier attendu manquant : $d"
done
for f in writing/README.md engineering/README.md; do
  [ -f "$ROOT/$f" ] || fail "index d'arbre manquant : $f"
done
for category in $WRITING_CATEGORIES $ENGINEERING_CATEGORIES; do
  tree="$(tree_of "$category")"
  [ -f "$ROOT/$tree/$category/README.md" ] \
    || fail "index de catégorie manquant : $tree/$category/README.md"
done
for f in architecture.md skills-guide.md writing-rules.md workflow.md engineering-system.md delivery-system.md; do
  [ -f "$ROOT/documentation/$f" ] || fail "documentation manquante : $f"
done

printf '\n%s skills contrôlés, %s erreurs.\n' "$SKILLS" "$ERRORS"
[ "$ERRORS" -eq 0 ] || exit 1
printf 'Structure conforme.\n'
