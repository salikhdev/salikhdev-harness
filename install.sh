#!/usr/bin/env bash
set -euo pipefail

HARNESS_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CLAUDE_DIR="$HOME/.claude"

echo "Salikhdev harness → $CLAUDE_DIR"

mkdir -p "$CLAUDE_DIR/skills"

# Global CLAUDE.md
if [ -e "$CLAUDE_DIR/CLAUDE.md" ] && [ ! -L "$CLAUDE_DIR/CLAUDE.md" ]; then
  cp "$CLAUDE_DIR/CLAUDE.md" "$CLAUDE_DIR/CLAUDE.md.backup"
  echo "  eski CLAUDE.md → CLAUDE.md.backup"
fi
ln -sfn "$HARNESS_DIR/claude/CLAUDE.md" "$CLAUDE_DIR/CLAUDE.md"
echo "  CLAUDE.md"

# Skills
for skill_dir in "$HARNESS_DIR"/skills/*/; do
  name="$(basename "$skill_dir")"
  ln -sfn "${skill_dir%/}" "$CLAUDE_DIR/skills/$name"
  echo "  skills/$name"
done

echo
echo "Tayyor. Endi loyihangizda: /setup-salikhdev"
