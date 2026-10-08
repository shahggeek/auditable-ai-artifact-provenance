#!/usr/bin/env bash
# Audit query model over the Layer-2 generation log.
# Usage:
#   tools/generation-report.sh by-file <path>     # what generated this file?
#   tools/generation-report.sh by-skill <skill>   # all artifacts a skill produced
#   tools/generation-report.sh by-month <YYYY-MM> # all events in a month
#   tools/generation-report.sh stats              # activity summary
set -euo pipefail
root="$(git rev-parse --show-toplevel)"
logs="$root/.provenance/generation-log"
all() { cat "$logs"/*/generation.jsonl 2>/dev/null || true; }
case "${1:-}" in
  by-file)  all | grep -F "\"output_file\":\"${2:?path}\"" || echo "no events for $2" ;;
  by-skill) all | grep -F "\"skill\":\"${2:?skill}\"" || echo "no events for $2" ;;
  by-month) cat "$logs/${2:?YYYY-MM}/generation.jsonl" 2>/dev/null || echo "no events in $2" ;;
  stats)
    n=$(all | wc -l | tr -d ' ')
    echo "total generation events: $n"
    echo "by skill:"
    all | sed -n 's/.*"skill":"\([^"]*\)".*/\1/p' | sort | uniq -c | sort -rn
    echo "by model:"
    all | sed -n 's/.*"model":"\([^"]*\)".*/\1/p' | sort | uniq -c | sort -rn ;;
  *) grep '^#   ' "$0" | sed 's/^#   //'; exit 1 ;;
esac
