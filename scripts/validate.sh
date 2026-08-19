#!/usr/bin/env bash
set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SKILLS_DIR="$REPO_DIR/skills"
NAME_REGEX='^[a-z0-9]+(-[a-z0-9]+)*$'

if [ ! -d "$SKILLS_DIR" ]; then
  echo "ERROR: no skills/ directory found."
  exit 1
fi

fails=0

while IFS= read -r -d '' skill; do
  name="$(basename "$skill")"
  sk="SKILL.md"
  [ -f "$skill/$sk" ] || { echo "FAIL [$name] missing $sk"; fails=$((fails + 1)); continue; }

  file="$skill/$sk"

  # name field must exist and match the folder name
  if ! grep -qE "^name:\s*${name}\s*$" "$file"; then
    echo "FAIL [$name] frontmatter name does not equal folder name"
    fails=$((fails + 1))
  fi

  if ! echo "$name" | grep -qE "$NAME_REGEX"; then
    echo "FAIL [$name] invalid name (must match $NAME_REGEX)"
    fails=$((fails + 1))
  fi

  # description field required
  if ! grep -qE "^description:" "$file"; then
    echo "FAIL [$name] missing description"
    fails=$((fails + 1))
  fi
done < <(find "$SKILLS_DIR" -mindepth 1 -maxdepth 1 -type d -print0 | sort -z)

if [ "$fails" -gt 0 ]; then
  echo "Validation failed: $fails error(s)."
  exit 1
fi

echo "All skills validated: OK"