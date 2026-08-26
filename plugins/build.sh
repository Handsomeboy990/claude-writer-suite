#!/usr/bin/env bash
# Generate the per-domain plugin bundles from the canonical skill trees.
#
# The trees under writing/, documents/, engineering/, security/, research/,
# career/ and opportunity/ are the single source of truth. Each plugin under
# plugins/<domain>/skills is generated from them by this script, using the same
# installer that populates ~/.claude/skills, so a plugin contains exactly the
# skills that scope would install, dependencies resolved, plus the cross domain
# pair. The engineering plugin also receives the 16 agents.
#
# Run this after adding or changing a skill, so the plugin bundles stay in sync
# with the trees. tests/validate-plugins.sh checks that they are.
#
#   bash plugins/build.sh
set -u

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
INSTALL="$ROOT/install.sh"

# domain directory -> installer scope flag
DOMAINS="writing:--writing
documents:--documents
engineering:--dev
security:--security
research:--research
career:--career
opportunity:--opportunity"

built=0
printf '%s\n' "$DOMAINS" | while IFS=: read -r dir scope; do
  [ -n "$dir" ] || continue
  plugin="$ROOT/plugins/$dir"
  [ -f "$plugin/.claude-plugin/plugin.json" ] || {
    printf 'skip %s: no plugin.json\n' "$dir"; continue; }

  # Clean and repopulate the skills directory for this domain.
  rm -rf "$plugin/skills"
  mkdir -p "$plugin/skills"

  # The engineering plugin also carries the agents.
  if [ "$dir" = "engineering" ]; then
    rm -rf "$plugin/agents"
    mkdir -p "$plugin/agents"
    CLAUDE_SKILLS_DIR="$plugin/skills" \
    CLAUDE_AGENTS_DIR="$plugin/agents" \
      bash "$INSTALL" "$scope" >/dev/null 2>&1
  else
    CLAUDE_SKILLS_DIR="$plugin/skills" \
      bash "$INSTALL" "$scope" --no-agents >/dev/null 2>&1
  fi

  count="$(find "$plugin/skills" -maxdepth 1 -mindepth 1 -type d | wc -l | tr -d ' ')"
  printf 'built %-14s %3s skills\n' "$dir" "$count"
done

printf 'Plugin bundles generated under plugins/.\n'
