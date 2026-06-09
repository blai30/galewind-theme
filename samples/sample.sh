#!/usr/bin/env bash
# Bash sample for syntax highlighting
set -euo pipefail

readonly ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
declare -A COLORS=(
  ["rose"]="#fb7185"
  ["sky"]="#38bdf8"
)

log() {
  local level="$1"
  shift
  printf '[%s] %s\n' "${level^^}" "$*" >&2
}

count_lines() {
  local pattern="${1:-*.json}"
  local total=0
  while IFS= read -r -d '' file; do
    local lines
    lines=$(wc -l <"$file")
    total=$(( total + lines ))
  done < <(find "$ROOT_DIR" -name "$pattern" -print0)
  echo "$total"
}

main() {
  if [[ $# -lt 1 ]]; then
    log warn "no variant supplied, defaulting to sky"
    set -- "sky"
  fi

  local variant="$1"
  if [[ -n "${COLORS[$variant]:-}" ]]; then
    log info "variant ${variant} -> ${COLORS[$variant]}"
  else
    log error "unknown variant: ${variant}"
    exit 1
  fi

  local json_lines
  json_lines=$(count_lines "*.json")
  log info "counted ${json_lines} json lines"
}

main "$@"
