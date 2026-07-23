#!/usr/bin/env bash
# Drift budget check between two SPEC versions.  v1.1
# Budget: (1) zero loss of SEMANTIC requirement coverage — every R-item traced
#             in the old spec's [source: ...] tags must still be traced in the new;
#         (2) IFR count within max(+/-BUDGET_ABS, +/-BUDGET_PCT%) of the old count.
# FR-ID continuity is reported as informational only (regrouping is not loss).
# v1.1 calibration derives from Experiment A (see experiments/A-pinned/ANALYSIS.md).
# Usage: tools/drift-check.sh <old_spec> <new_spec>
# Env:   BUDGET_PCT=10  BUDGET_ABS=1
set -euo pipefail
old="${1:?old spec}"; new="${2:?new spec}"
pct="${BUDGET_PCT:-10}"; abs="${BUDGET_ABS:-1}"
fr_old=$(grep -c '^FR[0-9]*:' "$old" || true); fr_new=$(grep -c '^FR[0-9]*:' "$new" || true)
ifr_old=$(grep -c '^IFR[0-9]*' "$old" || true); ifr_new=$(grep -c '^IFR[0-9]*' "$new" || true)
echo "FR count:  $fr_old -> $fr_new"
echo "IFR count: $ifr_old -> $ifr_new"
fail=0
# (1) semantic requirement coverage via [source: Rn] tags
rtags() { grep '^FR[0-9]*:' "$1" | grep -o '\[source:[^]]*\]' | grep -o 'R[0-9]*' | sort -u; }
missing_r=$(comm -23 <(rtags "$old") <(rtags "$new"))
if [[ -n "$missing_r" ]]; then
  echo "BUDGET BREACH: semantic requirement coverage lost -> $(echo $missing_r | tr '\n' ' ')"
  fail=1
else
  echo "semantic requirement coverage: preserved (all source R-items still traced)"
fi
# informational: FR-ID continuity (regrouping detection, not a failure)
missing_id=$(comm -23 <(grep -o '^FR[0-9]*' "$old" | sort -u) <(grep -o '^FR[0-9]*' "$new" | sort -u))
[[ -n "$missing_id" ]] && echo "note: FR IDs regrouped (absent IDs: $(echo $missing_id | tr '\n' ' ')) — check coverage above"
# (2) IFR count within max(abs, pct%) band
diff=$(( ifr_new - ifr_old )); [[ $diff -lt 0 ]] && diff=$(( -diff ))
band_pct=$(( pct * ifr_old / 100 )); band=$abs; [[ $band_pct -gt $band ]] && band=$band_pct
if [[ $diff -gt $band ]]; then
  echo "BUDGET BREACH: IFR count drift ${diff} exceeds band +/-${band} (max of ${abs} absolute, ${pct}%)"
  fail=1
else
  echo "IFR drift: ${diff} within band +/-${band}"
fi
if [[ $fail -eq 1 ]]; then
  echo "RESULT: OUTSIDE DRIFT BUDGET - escalate to human review with both versions' provenance"
  exit 1
fi
echo "RESULT: WITHIN DRIFT BUDGET"
