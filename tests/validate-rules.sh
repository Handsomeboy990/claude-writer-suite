#!/usr/bin/env bash
# Vérifie les interdits de la constitution sur tous les fichiers Markdown.
# Usage : bash tests/validate-rules.sh
set -u

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
ERRORS=0
WARNINGS=0

files() {
  find "$ROOT" -type f -name '*.md' -not -path '*/.git/*' | sort
}

report_error() {
  printf 'ERREUR  %s\n' "$1"
  ERRORS=$((ERRORS + 1))
}

report_warning() {
  printf 'AVERTIR %s\n' "$1"
  WARNINGS=$((WARNINGS + 1))
}

printf 'Contrôle 1 : tiret cadratin\n'
while IFS= read -r file; do
  hits="$(grep -n $'—' "$file" 2>/dev/null | head -n 3)"
  if [ -n "$hits" ]; then
    report_error "tiret cadratin dans ${file#"$ROOT"/}"
    printf '%s\n' "$hits" | sed 's/^/        /'
  fi
done < <(files)

printf 'Contrôle 2 : emoji et pictogrammes\n'
while IFS= read -r file; do
  hits="$(grep -nP '[\x{1F000}-\x{1FAFF}\x{2190}-\x{21FF}\x{2600}-\x{27BF}\x{2B00}-\x{2BFF}\x{FE0F}]' "$file" 2>/dev/null | head -n 3)"
  if [ -n "$hits" ]; then
    report_error "emoji ou pictogramme dans ${file#"$ROOT"/}"
    printf '%s\n' "$hits" | sed 's/^/        /'
  fi
done < <(files)

printf 'Contrôle 3 : guillemets droits hors contre-exemples\n'
while IFS= read -r file; do
  case "$file" in
    *"/examples/"*|*"/tests/"*) continue ;;
  esac
  hits="$(grep -n '"' "$file" 2>/dev/null | grep -v '^\s*[0-9]*:.*`' | head -n 2)"
  if [ -n "$hits" ]; then
    report_warning "guillemets droits dans ${file#"$ROOT"/}"
  fi
done < <(files)

printf 'Contrôle 4 : points d exclamation multiples\n'
while IFS= read -r file; do
  case "$file" in
    *"/examples/"*) continue ;;
  esac
  if grep -q '!!' "$file" 2>/dev/null; then
    report_warning "exclamations multiples dans ${file#"$ROOT"/}"
  fi
done < <(files)

printf '\n%s erreurs, %s avertissements.\n' "$ERRORS" "$WARNINGS"
[ "$ERRORS" -eq 0 ] || exit 1
printf 'Règles de la constitution respectées.\n'
