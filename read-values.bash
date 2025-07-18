#!/usr/bin/env bash
set -euo pipefail
shopt -s extglob

FILES=()
while IFS= read -r line; do
  [[ -z "$line" ]] && continue
  FILES+=("$line")
done
if [ ${#FILES[@]} -eq 0 ]; then
  echo "Error: No values files provided" >&2
  exit 1
fi

MERGED=$(yq eval '.' "${FILES[0]}")

# Merge each subsequent file
for ((i=1; i<${#FILES[@]}; i++)); do
  MERGED=$(echo "$MERGED" | yq eval-all 'select(fileIndex == 0) * select(fileIndex == 1)' - "${FILES[i]}")
done


# Each argument format:
#   key = .yq.expression (spaces around '=' are optional)

for out in "$@"; do
  [[ -z "$out" ]] && continue

  IFS='=' read -r KEY EXPR <<< "$out"

  # trim surronding whitespace
  KEY="${KEY##+([[:space:]])}"
  KEY="${KEY%%+([[:space:]])}"
  EXPR="${EXPR##+([[:space:]])}"
  EXPR="${EXPR%%+([[:space:]])}"

  VALUE=$(echo "$MERGED" | yq eval "$EXPR" -)
  echo "${KEY}=${VALUE}"
done
