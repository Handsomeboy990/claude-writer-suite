#!/usr/bin/env bash
# Vérifie la cohérence du système d'ingénierie : plans d'exécution, phases de
# livraison, références croisées, portes obligatoires, scénarios de routage et
# définitions d'agents.
# Usage : bash tests/validate-orchestration.sh
set -u

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
DEV="$ROOT/dev-skills"
DELIVERY="$ROOT/delivery-skills"
DEVOPS="$ROOT/devops-skills"
AGENTS="$ROOT/agents"
ORCH="$DEV/engineering-orchestrator"
PLANS="$ORCH/resources/execution-plans.md"
PHASES="$DELIVERY/delivery-orchestrator/resources/delivery-phases.md"
ENGINEERING_CATEGORIES="dev-skills delivery-skills devops-skills"
ERRORS=0

CATEGORIES="EXPLORATION ARCHITECTURE FRONTEND BACKEND FULLSTACK DATABASE API
AUTHENTICATION SECURITY VALIDATION DEBUGGING PERFORMANCE UI_UX TESTING
BROWSER_AUTOMATION DOCUMENTATION GIT RELEASE REFACTORING DEPENDENCY"

AGENT_NAMES="delivery-orchestrator requirements-analyst software-architect
frontend-engineer backend-engineer database-engineer security-engineer
qa-engineer playwright-engineer ui-ux-engineer devops-engineer
performance-engineer documentation-engineer release-engineer"

fail() {
  printf 'ERREUR  %s\n' "$1"
  ERRORS=$((ERRORS + 1))
}

# Chemin d'un skill, quelle que soit sa catégorie d'ingénierie.
skill_dir() {
  for category in $ENGINEERING_CATEGORIES; do
    if [ -d "$ROOT/$category/$1" ]; then
      printf '%s\n' "$ROOT/$category/$1"
      return 0
    fi
  done
  return 1
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
for d in "$DEV" "$DELIVERY" "$DEVOPS" "$AGENTS"; do
  [ -d "$d" ] || { fail "dossier absent : ${d#"$ROOT"/}"; exit 1; }
done
for f in "$DEV/README.md" "$DELIVERY/README.md" "$DEVOPS/README.md" \
         "$AGENTS/README.md" "$AGENTS/handoff-protocol.md" \
         "$ORCH/SKILL.md" "$ORCH/resources/routing-table.md" \
         "$DEV/engineering-core/SKILL.md" "$DEVOPS/devops-core/SKILL.md"; do
  [ -f "$f" ] || fail "fichier absent : ${f#"$ROOT"/}"
done
[ -f "$PLANS" ] || { fail "execution-plans.md absent"; exit 1; }
[ -f "$PHASES" ] || { fail "delivery-phases.md absent"; exit 1; }

printf 'Contrôle 2 : une classification et un plan par catégorie de tâche\n'
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
    skill_dir "$step" >/dev/null || fail "plan $category : skill inconnu, $step"
    case "$step" in
      engineering-core|engineering-orchestrator)
        fail "plan $category : $step ne doit pas figurer dans un plan"
        ;;
    esac
  done < <(steps_of "$plan")
done

printf 'Contrôle 4 : portes obligatoires des plans\n'
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

printf 'Contrôle 6 : phases de livraison\n'
expected_phase=1
while IFS= read -r number; do
  actual=$((10#$number))
  [ "$actual" -eq "$expected_phase" ] \
    || fail "phase $number : numérotation non séquentielle, attendu $expected_phase"
  expected_phase=$((expected_phase + 1))
done < <(grep '^phase: ' "$PHASES" | awk '{print $2}')
[ "$expected_phase" -eq 15 ] \
  || fail "delivery-phases.md : $((expected_phase - 1)) phases au lieu de 14"

while IFS= read -r line; do
  for skill in $(printf '%s' "$line" | sed 's/^skills: //; s/,/ /g'); do
    skill_dir "$skill" >/dev/null \
      || fail "delivery-phases.md : skill inconnu dans une phase, $skill"
  done
done < <(grep '^skills: ' "$PHASES")

for phase in 02 05 10 14; do
  gate="$(awk -v p="phase: $phase" '
    $0 == p { found = 1; next }
    found && /^gate: / { print $2; exit }
  ' "$PHASES")"
  [ "$gate" = "approval" ] \
    || fail "phase $phase : porte attendue approval, trouvée ${gate:-aucune}"
done

grep -q '^skills: .*validation-gate' "$PHASES" \
  || fail "delivery-phases.md : validation-gate absent des phases"
grep -q '^skills: .*requirements-analysis' "$PHASES" \
  || fail "delivery-phases.md : requirements-analysis absent des phases"
grep -q '^skills: .*production-verification' "$PHASES" \
  || fail "delivery-phases.md : production-verification absent des phases"

printf 'Contrôle 7 : aucun skill orphelin\n'
for category in $ENGINEERING_CATEGORIES; do
  for skill in "$ROOT/$category"/*/; do
    name="$(basename "$skill")"
    case "$name" in
      engineering-core|engineering-orchestrator|devops-core|delivery-orchestrator)
        continue ;;
    esac
    if ! grep -q "$name" "$PLANS" && ! grep -q "$name" "$PHASES"; then
      fail "skill absent de tout plan et de toute phase : $category/$name"
    fi
  done
done

printf 'Contrôle 8 : dépendances déclarées existantes\n'
for category in $ENGINEERING_CATEGORIES; do
  for skill in "$ROOT/$category"/*/; do
    name="$(basename "$skill")"
    deps="$(grep -m1 '^  depends_on:' "$skill/SKILL.md" \
      | sed 's/^  depends_on: *\[//; s/\]$//; s/,/ /g')"
    for dep in $deps; do
      [ -n "$dep" ] || continue
      skill_dir "$dep" >/dev/null || fail "$name : depends_on inconnu, $dep"
    done
  done
done

printf 'Contrôle 9 : références croisées de la section Interfaces\n'
for category in $ENGINEERING_CATEGORIES; do
  for skill in "$ROOT/$category"/*/; do
    name="$(basename "$skill")"
    refs="$(awk '/^## [0-9]+\. Interfaces/ { on = 1; next }
                 on && /^## / { on = 0 }
                 on { print }' "$skill/SKILL.md" \
      | grep -o '`[a-z][a-z0-9-]*`' | tr -d '`' | sort -u)"
    for ref in $refs; do
      case "$ref" in
        dev-skills|delivery-skills|devops-skills) continue ;;
      esac
      skill_dir "$ref" >/dev/null \
        || fail "$name : référence Interfaces inconnue, $ref"
    done
  done
done

printf 'Contrôle 10 : README de skill présent et cohérent\n'
for category in $ENGINEERING_CATEGORIES; do
  for skill in "$ROOT/$category"/*/; do
    name="$(basename "$skill")"
    head -n 1 "$skill/README.md" | grep -q "^# $name$" \
      || fail "$name : le titre du README ne correspond pas au dossier"
  done
done

printf 'Contrôle 11 : définitions d agents\n'
for agent in $AGENT_NAMES; do
  file="$AGENTS/$agent.md"
  if [ ! -f "$file" ]; then
    fail "agent absent : $agent"
    continue
  fi
  head -n 1 "$file" | grep -q '^---$' \
    || fail "$agent : bloc de métadonnées absent"
  grep -q "^name: $agent$" "$file" \
    || fail "$agent : le champ name ne correspond pas au fichier"
  desc="$(grep -m1 '^description:' "$file" | cut -c14-)"
  [ "${#desc}" -ge 40 ] \
    || fail "$agent : description trop courte pour être découverte"
  for section in Role Mission Responsibilities Inputs Outputs Boundaries \
                 Verification Handoff; do
    grep -q "^## $section" "$file" \
      || fail "$agent : section $section absente"
  done
  grep -q "$agent" "$AGENTS/README.md" \
    || fail "$agent : absent de agents/README.md"
done

for file in "$AGENTS"/*.md; do
  name="$(basename "$file" .md)"
  case "$name" in
    README|handoff-protocol) continue ;;
  esac
  printf '%s\n' $AGENT_NAMES | grep -qx "$name" \
    || fail "agent non déclaré dans la liste attendue : $name"
done

printf 'Contrôle 12 : les agents citent des skills réels\n'
for agent in $AGENT_NAMES; do
  file="$AGENTS/$agent.md"
  [ -f "$file" ] || continue
  refs="$(awk '/^## Skills/ { on = 1; next }
               on && /^## / { on = 0 }
               on { print }' "$file" \
    | grep -o '`[a-z][a-z0-9-]*`' | tr -d '`' | sort -u)"
  for ref in $refs; do
    skill_dir "$ref" >/dev/null \
      || fail "$agent : skill inconnu dans la section Skills, $ref"
  done
done

printf '\n%s erreurs.\n' "$ERRORS"
[ "$ERRORS" -eq 0 ] || exit 1
printf 'Système de livraison et d ingénierie cohérent.\n'
