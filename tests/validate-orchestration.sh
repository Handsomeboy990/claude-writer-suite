#!/usr/bin/env bash
# Vérifie la cohérence du système de skills d'ingénierie : plans d'exécution,
# références croisées, portes obligatoires et scénarios de routage.
# Usage : bash tests/validate-orchestration.sh
set -u

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
DEV="$ROOT/dev-skills"
ORCH="$DEV/engineering-orchestrator"
PLANS="$ORCH/resources/execution-plans.md"
ERRORS=0

CATEGORIES="EXPLORATION ARCHITECTURE FRONTEND BACKEND FULLSTACK DATABASE API
AUTHENTICATION SECURITY VALIDATION DEBUGGING PERFORMANCE UI_UX TESTING
BROWSER_AUTOMATION DOCUMENTATION GIT RELEASE REFACTORING DEPENDENCY"

fail() {
  printf 'ERREUR  %s\n' "$1"
  ERRORS=$((ERRORS + 1))
}

plan_of() {
  awk -v cat="category: $1" '
    $0 == cat { found = 1; next }
    found && /^plan: / { sub(/^plan: /, ""); print; exit }
  ' "$PLANS"
}

# Étapes d un plan, une par ligne.
steps_of() {
  printf '%s\n' "$1" | sed 's/->/\n/g' | sed 's/^[[:space:]]*//; s/[[:space:]]*$//' \
    | grep -v '^$'
}

# Position d une étape dans un plan, vide si absente.
position_in() {
  steps_of "$1" | grep -n "^$2$" | head -n 1 | cut -d: -f1
}

# Présence d une étape dans un plan.
contains() {
  steps_of "$1" | grep -qx "$2"
}

# Vérifie que les étapes passées sont présentes et dans cet ordre.
ordered() {
  category="$1"; scenario="$2"; shift 2
  plan="$(plan_of "$category")"
  previous=0
  for step in "$@"; do
    index="$(position_in "$plan" "$step")"
    if [ -z "$index" ]; then
      fail "$scenario : étape absente du plan $category : $step"
      return
    fi
    if [ "$index" -le "$previous" ]; then
      fail "$scenario : ordre incorrect dans $category, $step arrive trop tôt"
      return
    fi
    previous="$index"
  done
}

printf 'Contrôle 1 : présence des fichiers du système\n'
[ -d "$DEV" ] || { fail "dossier dev-skills absent"; exit 1; }
[ -f "$DEV/README.md" ] || fail "dev-skills/README.md absent"
[ -f "$ORCH/SKILL.md" ] || fail "engineering-orchestrator/SKILL.md absent"
[ -f "$PLANS" ] || { fail "execution-plans.md absent"; exit 1; }
[ -f "$ORCH/resources/routing-table.md" ] || fail "routing-table.md absent"
[ -f "$DEV/engineering-core/SKILL.md" ] || fail "engineering-core/SKILL.md absent"

printf 'Contrôle 2 : une classification et un plan par catégorie\n'
for category in $CATEGORIES; do
  grep -q "^| $category |" "$ORCH/SKILL.md" \
    || fail "catégorie absente du tableau de classification : $category"
  count="$(grep -c "^category: $category$" "$PLANS" || true)"
  [ "$count" -eq 1 ] \
    || fail "catégorie $category : $count déclarations de plan au lieu de 1"
  [ -n "$(plan_of "$category")" ] \
    || fail "catégorie $category : ligne plan absente"
done

printf 'Contrôle 3 : chaque étape de plan désigne un skill réel\n'
for category in $CATEGORIES; do
  plan="$(plan_of "$category")"
  [ -n "$plan" ] || continue
  while IFS= read -r step; do
    [ -n "$step" ] || continue
    [ -d "$DEV/$step" ] || fail "plan $category : skill inconnu, $step"
    case "$step" in
      engineering-core|engineering-orchestrator)
        fail "plan $category : $step ne doit pas figurer dans un plan"
        ;;
    esac
  done < <(steps_of "$plan")
done

printf 'Contrôle 4 : portes obligatoires\n'
for category in $CATEGORIES; do
  plan="$(plan_of "$category")"
  [ -n "$plan" ] || continue
  case "$(steps_of "$plan" | head -n 1)" in
    project-exploration) ;;
    *) fail "plan $category : ne commence pas par project-exploration" ;;
  esac

  implements=0
  for skill in backend-engineering frontend-engineering fullstack-engineering; do
    contains "$plan" "$skill" && implements=1
  done

  if [ "$implements" -eq 1 ]; then
    for gate in testing-quality code-review-protocol project-continuity git-workflow; do
      contains "$plan" "$gate" \
        || fail "plan $category : porte obligatoire absente, $gate"
    done
  fi

  if contains "$plan" "ui-ux-engineering" && contains "$plan" "frontend-engineering"; then
    a="$(position_in "$plan" ui-ux-engineering)"
    b="$(position_in "$plan" frontend-engineering)"
    [ "$a" -lt "$b" ] \
      || fail "plan $category : ui-ux-engineering doit précéder frontend-engineering"
  fi

  if contains "$plan" "project-continuity" && contains "$plan" "git-workflow"; then
    a="$(position_in "$plan" project-continuity)"
    b="$(position_in "$plan" git-workflow)"
    [ "$a" -lt "$b" ] \
      || fail "plan $category : project-continuity doit précéder git-workflow"
  fi

  if contains "$plan" "release-readiness"; then
    last="$(steps_of "$plan" | tail -n 1)"
    [ "$last" = "release-readiness" ] \
      || fail "plan $category : release-readiness doit être la dernière étape"
  fi
done

for category in SECURITY AUTHENTICATION; do
  contains "$(plan_of "$category")" "security-audit" \
    || fail "plan $category : security-audit obligatoire"
done
contains "$(plan_of API)" "technical-documentation" \
  || fail "plan API : technical-documentation obligatoire sur un changement de contrat"
contains "$(plan_of DEPENDENCY)" "dependency-selection" \
  || fail "plan DEPENDENCY : dependency-selection obligatoire"

printf 'Contrôle 5 : scénarios de routage de référence\n'
ordered DEBUGGING "scénario A, bug dans une API" \
  project-exploration debugging backend-engineering testing-quality \
  code-review-protocol
ordered FRONTEND "scénario B, nouvelle page de tableau de bord" \
  project-exploration ui-ux-engineering frontend-engineering input-validation \
  testing-quality playwright-automation performance-engineering \
  code-review-protocol
ordered BACKEND "scénario C, endpoint de paiement" \
  project-exploration architecture-design backend-engineering input-validation \
  security-audit testing-quality code-review-protocol
ordered SECURITY "scénario D, revue de l authentification" \
  project-exploration security-audit code-review-protocol \
  technical-documentation
contains "$(plan_of SECURITY)" "testing-quality" \
  || fail "scénario D : testing-quality absent du plan SECURITY"
ordered FULLSTACK "scénario E, fonctionnalité complète" \
  project-exploration architecture-design fullstack-engineering \
  input-validation security-audit testing-quality playwright-automation \
  code-review-protocol technical-documentation project-continuity \
  git-workflow release-readiness

printf 'Contrôle 6 : aucun skill orphelin\n'
for skill in "$DEV"/*/; do
  name="$(basename "$skill")"
  case "$name" in
    engineering-core|engineering-orchestrator) continue ;;
  esac
  grep -q "$name" "$PLANS" || fail "skill absent de tout plan : $name"
done

printf 'Contrôle 7 : dépendances déclarées existantes\n'
for skill in "$DEV"/*/; do
  name="$(basename "$skill")"
  deps="$(grep -m1 '^  depends_on:' "$skill/SKILL.md" \
    | sed 's/^  depends_on: *\[//; s/\]$//; s/,/ /g')"
  for dep in $deps; do
    [ -n "$dep" ] || continue
    [ -d "$DEV/$dep" ] || fail "$name : depends_on inconnu, $dep"
  done
done

printf 'Contrôle 8 : références croisées de la section Interfaces\n'
for skill in "$DEV"/*/; do
  name="$(basename "$skill")"
  refs="$(awk '/^## [0-9]+\. Interfaces/ { on = 1; next }
               on && /^## / { on = 0 }
               on { print }' "$skill/SKILL.md" \
    | grep -o '`[a-z][a-z0-9-]*`' | tr -d '`' | sort -u)"
  for ref in $refs; do
    case "$ref" in
      dev-skills) continue ;;
    esac
    [ -d "$DEV/$ref" ] || fail "$name : référence Interfaces inconnue, $ref"
  done
done

printf 'Contrôle 9 : README de skill présent et cohérent\n'
for skill in "$DEV"/*/; do
  name="$(basename "$skill")"
  head -n 1 "$skill/README.md" | grep -q "^# $name$" \
    || fail "$name : le titre du README ne correspond pas au dossier"
done

printf '\n%s erreurs.\n' "$ERRORS"
[ "$ERRORS" -eq 0 ] || exit 1
printf 'Système de skills d ingénierie cohérent.\n'
