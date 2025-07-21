#!/usr/bin/env bash

work_dir="$1"
values="$2"
outputs="$3"

[[ ! -z "$work_dir" ]] && cd "$work_dir"

EXPRS=()
while IFS= read -r line; do
  [[ -z "$line" ]] && continue
  EXPRS+=("$line")
done <<< "$outputs"

/read-values.sh "${EXPRS[@]}" <<< "$values" >> "$GITHUB_OUTPUT"
