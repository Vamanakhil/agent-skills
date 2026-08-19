#!/usr/bin/env bash
# One-liner installer for agent-skills.
#
# Usage:
#   curl -fsSL https://raw.githubusercontent.com/Vamanakhil/agent-skills/main/install-remote.sh | bash
#
# Clones the repo (or updates it if already present) and installs every skill
# into ~/.claude/skills so both opencode and Claude Code load them globally.
#
# Optional: AGENT_SKILLS_DIR=/custom/path to choose the install location.
set -euo pipefail

INSTALL_DIR="${AGENT_SKILLS_DIR:-$HOME/Projects/Skills}"
REPO_URL="https://github.com/Vamanakhil/agent-skills.git"

if [ -d "$INSTALL_DIR/.git" ]; then
  echo "agent-skills already present at $INSTALL_DIR — updating..."
  git -C "$INSTALL_DIR" pull --ff-only
else
  echo "Cloning agent-skills into $INSTALL_DIR..."
  git clone "$REPO_URL" "$INSTALL_DIR"
fi

echo
bash "$INSTALL_DIR/install.sh"