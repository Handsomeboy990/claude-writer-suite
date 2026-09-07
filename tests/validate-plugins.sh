#!/usr/bin/env bash
# Verifies the plugin bundles under plugins/ are in sync with the canonical
# skill trees, and that the marketplace and manifests are well formed.
#
# The trees are the source of truth. plugins/<domain>/skills is generated from
# them by plugins/build.sh. This check regenerates the expected skill set for
# each domain into a sandbox and compares it to what is committed, so a skill
# added to a tree but not rebuilt into the plugins is caught before release.
#
#   bash tests/validate-plugins.sh
set -u

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
INSTALL="$ROOT/install.sh"
MARKET="$ROOT/.claude-plugin/marketplace.json"
ERRORS=0

fail() { printf 'ERROR   %s\n' "$1"; ERRORS=$((ERRORS + 1)); }

DOMAINS="writing:--writing
documents:--documents
engineering:--dev
security:--security
research:--research
career:--career
opportunity:--opportunity"

printf 'Check 1: marketplace.json and manifests are valid JSON\n'
if command -v python3 >/dev/null; then
  python3 - "$MARKET" <<'PY' || fail "marketplace.json is not valid JSON"
import json, sys
json.load(open(sys.argv[1]))
PY
  for d in writing documents engineering security research career opportunity; do
    m="$ROOT/plugins/$d/.claude-plugin/plugin.json"
    [ -f "$m" ] || { fail "missing manifest: plugins/$d/.claude-plugin/plugin.json"; continue; }
    python3 - "$m" <<'PY' || fail "invalid JSON: plugins/$d/.claude-plugin/plugin.json"
import json, sys
json.load(open(sys.argv[1]))
PY
  done
else
  printf 'WARN    python3 not found, skipping JSON validation\n'
fi

printf 'Check 2: every marketplace source path exists with a manifest\n'
if command -v python3 >/dev/null; then
  while IFS= read -r src; do
    [ -n "$src" ] || continue
    path="$ROOT/${src#./}"
    [ -f "$path/.claude-plugin/plugin.json" ] \
      || fail "marketplace source has no plugin.json: $src"
  done < <(python3 -c "
import json
d = json.load(open('$MARKET'))
for p in d['plugins']:
    print(p['source'])
")
fi

printf 'Check 3: plugin bundles are in sync with the trees\n'
SANDBOX="$(mktemp -d)"
trap 'rm -rf "$SANDBOX"' EXIT
printf '%s\n' "$DOMAINS" | while IFS=: read -r dir scope; do
  [ -n "$dir" ] || continue
  target="$SANDBOX/$dir"
  mkdir -p "$target"
  CLAUDE_SKILLS_DIR="$target" bash "$INSTALL" "$scope" --no-agents >/dev/null 2>&1
  expected="$(cd "$target" && ls -1 2>/dev/null | sort)"
  actual="$(cd "$ROOT/plugins/$dir/skills" 2>/dev/null && ls -1 2>/dev/null | sort)"
  if [ "$expected" != "$actual" ]; then
    printf 'ERROR   plugin %s is out of sync with the trees. Run: bash plugins/build.sh\n' "$dir"
    diff <(printf '%s\n' "$expected") <(printf '%s\n' "$actual") \
      | sed 's/^/        /' | head -n 20
    printf '%s\n' "sync-error" >> "$SANDBOX/errors"
  fi
done
[ -f "$SANDBOX/errors" ] && ERRORS=$((ERRORS + $(wc -l < "$SANDBOX/errors")))

printf 'Check 4: the engineering plugin carries the agents\n'
acount="$(ls "$ROOT/plugins/engineering/agents" 2>/dev/null | grep -c '\.md$' || true)"
[ "$acount" -ge 16 ] \
  || fail "engineering plugin has $acount agent files, expected at least 16. Run: bash plugins/build.sh"

printf '\n%s errors.\n' "$ERRORS"
[ "$ERRORS" -eq 0 ] || exit 1
printf 'Plugins coherent.\n'
