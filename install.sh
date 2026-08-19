#!/usr/bin/env bash
set -euo pipefail

SRC_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DEST="$HOME/.claude/skills"

MODE="install"
VERBOSE=0

usage() {
  cat <<EOF
Usage: $0 [--dry-run|--list|--verbose|--help]

Symlinks every skill folder in $SRC_DIR into $DEST so both
opencode and Claude Code can load them from any project.

  --dry-run   show what would be linked without changing anything
  --list      list the skills that would be installed
  --verbose   print each link as it is created
  --help      show this help
EOF
}

for arg in "$@"; do
  case "$arg" in
    --dry-run) MODE="dry-run" ;;
    --list) MODE="list" ;;
    --verbose) VERBOSE=1 ;;
    --help|-h) usage; exit 0 ;;
    *) echo "Unknown option: $arg"; usage; exit 1 ;;
  esac
done

mkdir -p "$DEST"

found=0
while IFS= read -r -d '' skill; do
  dir="$(dirname "$skill")"
  name="$(basename "$dir")"
  link="$DEST/$name"
  found=1

  if [ "$MODE" = "list" ]; then
    echo "$name -> $dir"
    continue
  fi

  if [ "$MODE" = "dry-run" ]; then
    echo "[dry-run] ln -sfn \"$dir\" \"$link\""
    continue
  fi

  if [ -e "$link" ] && [ ! -L "$link" ]; then
    echo "WARN: $link exists and is not a symlink; skipping (no overwrite)."
    continue
  fi

  ln -sfn "$dir" "$link"
  [ "$VERBOSE" = 1 ] && echo "linked $link -> $dir"
done < <(find "$SRC_DIR/skills" -mindepth 2 -maxdepth 2 -name SKILL.md -print0)

if [ "$found" = 0 ]; then
  echo "No skills found in $SRC_DIR/skills (expected skills/<skill-name>/SKILL.md folders)."
  exit 1
fi

if [ "$MODE" = "install" ]; then
  echo "Done. Skills installed into $DEST."
  echo "Restart opencode to load new skills; Claude Code picks them up live."
fi