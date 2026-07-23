#!/usr/bin/env bash
# Experiments B & C: collect the regenerated pipeline, measure blast radius vs baseline,
# run drift-check v1.1, and log to results.csv.
# Usage: tools/expBC-collect.sh B   |   tools/expBC-collect.sh C
set -euo pipefail
exp="${1:?B or C}"
root="$(git rev-parse --show-toplevel)"
work="/tmp/exp${exp}-run"
case "$exp" in
  B) dest="$root/experiments/B-req-change"; note="pinned regeneration; trigger-expected +2 FR from R11/R12" ;;
  C) dest="$root/experiments/C-unpinned";  note="UNPINNED model; trigger-expected +2 FR from R11/R12" ;;
  *) echo "arg must be B or C"; exit 1 ;;
esac
for f in SPEC.md STORIES.md SCENARIOS.md TESTPLAN.md; do
  [[ -f "$work/$f" ]] || { echo "ERROR: $work/$f missing"; exit 1; }
done
mkdir -p "$dest"
cp "$work"/{SPEC.md,STORIES.md,SCENARIOS.md,TESTPLAN.md} "$work/pet-store-requirements.md" "$dest/"
fr=$(grep -c '^FR[0-9]*:' "$dest/SPEC.md" || true)
ifr=$(grep -c '^IFR[0-9]*' "$dest/SPEC.md" || true)
st=$(grep -c '^Story ' "$dest/STORIES.md" || true)
sc=$(grep -c '^Scenario ' "$dest/SCENARIOS.md" || true)
tc=$(grep -c '^TC[0-9]*' "$dest/TESTPLAN.md" || true)
model=$(sed -n 's/^- Model: \(.*\)/\1/p' "$dest/SPEC.md" | head -1)
echo "$exp: FR=$fr IFR=$ifr stories=$st scenarios=$sc tests=$tc model=$model"
echo ""
echo "=== blast radius vs baseline (changed lines / baseline lines) ==="
for pair in "SPEC.md|artifacts/SPEC_v1.0.md" "STORIES.md|artifacts/stories/STORIES_v1.0.md" \
            "SCENARIOS.md|artifacts/scenarios/SCENARIOS_v1.0.md" "TESTPLAN.md|artifacts/tests/TESTPLAN_v1.0.md"; do
  IFS='|' read -r newf basef <<< "$pair"
  churn=$(diff -U0 "$root/$basef" "$dest/$newf" | grep -c '^[+-][^+-]' || true)
  blines=$(wc -l < "$root/$basef" | tr -d ' ')
  echo "  $newf: $churn changed lines vs $blines baseline lines"
done
echo ""
echo "=== drift-check v1.1 (baseline SPEC vs regenerated SPEC) ==="
if bash "$root/tools/drift-check.sh" "$root/artifacts/SPEC_v1.0.md" "$dest/SPEC.md"; then wb="yes"; else wb="no"; fi
missing_r=$(comm -23 <(grep '^FR' "$root/artifacts/SPEC_v1.0.md" | grep -o 'R[0-9]*' | sort -u) \
                     <(grep '^FR' "$dest/SPEC.md" | grep -o 'R[0-9]*' | sort -u))
[[ -z "$missing_r" ]] && cov="yes" || cov="no"
echo "$exp,01,${model:-unknown},${model:-unknown},default,instructions/v1.0.0,$fr,$ifr,$st,$sc,$tc,$cov,$wb,$note" >> "$root/experiments/results.csv"
rm -rf "$work"
echo ""
echo "collected -> $dest ; results.csv updated ; workspace cleaned"
echo "NOTE: a count 'breach' here may be trigger-caused (+2 expected FRs). The analysis"
echo "separates requested change from unrequested drift — that is the point of the experiment."
