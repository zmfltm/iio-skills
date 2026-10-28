#!/usr/bin/env bash
# Links every skill in this repo into Claude Code and Codex.
# Existing skills with the same name are left alone.
set -euo pipefail
repo="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
for target in "$HOME/.claude/skills" "$HOME/.agents/skills"; do
  mkdir -p "$target"
  for skill in "$repo"/skills/*/; do
    name="$(basename "$skill")"
    if [ -e "$target/$name" ] || [ -L "$target/$name" ]; then
      echo "skip   $target/$name (already there)"
    else
      ln -s "${skill%/}" "$target/$name"
      echo "linked $target/$name"
    fi
  done
done
