#!/usr/bin/env bash
set -euo pipefail

DEST="$HOME/.claude/skills"
SRC="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

removed=0
for link in "$DEST"/*; do
  [ -L "$link" ] || continue
  target="$(readlink "$link")"
  case "$target" in
    "$SRC"/*)
      rm "$link"
      echo "removed $link"
      removed=1
      ;;
  esac
done

[ "$removed" = 0 ] && echo "Nothing to remove: no symlinks point into $SRC."