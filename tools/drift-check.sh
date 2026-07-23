#!/usr/bin/env bash
# Drift budget check between two SPEC versions.
# Budget (defaults): IFR count within +/-10%; zero loss of FR coverage.
# Usage: tools/drift-check.sh <old_spec> <new_spec>
# Env:   BUDGET_PCT=10   (allowed IFR-count variation, percent)
set -euo pipefail
old="${1:?old spec}"; new="${2:?new spec}"
pct="${BUDGET_PCT:-10}"
fr_old=$(grep -c '^FR[0-9]*:' "$old" || true); fr_new=$(grep -c '^FR[0-9]*:' "$new" || true)
ifr_old=$(grep -c '^IFR[0-9]*' "$old" || true); ifr_new=$(grep -c '^IFR[0-9]*' "$new" || true)
echo "FR count:  $fr_old -> $fr_new"
echo "IFR count: $ifr_old -> $ifr_new"
fail=0
# 1) zero loss of FR coverage: every old FR id must still exist
missing=$(comm -23 <(grep -o '^FR[0-9]*' "$old" | sort -u) <(grep -o '^FR[0-9]*' "$new" | sort -u))
if [[ -n "$missing" ]]; then
  echo "BUDGET BREACH: FR coverage lost -> $(echo $missing | tr '\n' ' ')"
  fail=1
else
  echo "FR coverage: preserved"
fi
# 2) IFR count within +/- BUDGET_PCT%
diff=$(( ifr_new - ifr_old )); [[ $diff -lt 0 ]] && diff=$(( -diff ))
if [[ $(( diff * 100 )) -gt $(( pct * ifr_old )) ]]; then
  echo "BUDGET BREACH: IFR count drift ${diff} exceeds +/-${pct}% of ${ifr_old}"
  fail=1
else
  echo "IFR drift: within +/-${pct}% budget"
fi
if [[ $fail -eq 1 ]]; then
  echo "RESULT: OUTSIDE DRIFT BUDGET - escalate to human review with both versions' provenance"
  exit 1
fi
echo "RESULT: WITHIN DRIFT BUDGET"
