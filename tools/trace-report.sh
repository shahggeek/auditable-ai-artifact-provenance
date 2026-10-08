#!/usr/bin/env bash
# Traceability chain queries: FR -> IFR -> story -> scenario -> test.
# Usage:
#   tools/trace-report.sh coverage             # every FR covered at each downstream stage?
#   tools/trace-report.sh forward FR3          # everything that traces to FR3
#   tools/trace-report.sh backward <file>      # which FRs a file traces to
set -euo pipefail
script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
root="$(cd "$script_dir/.." && pwd)"
spec=$(ls "$root"/artifacts/SPEC_v*.md 2>/dev/null | sort -V | tail -1 || true)
[[ -n "$spec" ]] || { echo "no SPEC found in artifacts/"; exit 1; }
case "${1:-}" in
  coverage)
    fail=0
    echo "SPEC: $(basename "$spec")"
    printf "%-6s %-8s %-10s %-8s\n" "FR" "stories" "scenarios" "tests"
    for fr in $(grep -o '^FR[0-9]*' "$spec"); do
      s=$(grep -rl "\[$fr\]" "$root/artifacts/stories" 2>/dev/null | wc -l | tr -d ' ')
      c=$(grep -rl "\[$fr\]" "$root/artifacts/scenarios" 2>/dev/null | wc -l | tr -d ' ')
      t=$(grep -rl "\[$fr\]" "$root/artifacts/tests" 2>/dev/null | wc -l | tr -d ' ')
      printf "%-6s %-8s %-10s %-8s\n" "$fr" "$s" "$c" "$t"
      [[ "$s" -gt 0 && "$c" -gt 0 && "$t" -gt 0 ]] || fail=1
    done
    [[ $fail -eq 0 ]] && echo "COVERAGE: OK" || { echo "COVERAGE: GAPS FOUND"; exit 1; } ;;
  forward)
    fr="${2:?FR id, e.g. FR3}"
    grep -rn "\[$fr\]\|^$fr:\|($fr)" "$root/artifacts" || echo "nothing traces to $fr" ;;
  backward)
    f="${2:?file}"
    echo "FRs referenced by $f:"
    grep -o '\[FR[0-9]*\]' "$f" | tr -d '[]' | sort -u ;;
  *) grep '^#   ' "$0" | sed 's/^#   //'; exit 1 ;;
esac
