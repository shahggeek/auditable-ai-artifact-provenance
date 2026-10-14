#!/usr/bin/env bash
# Experiments B & C: collect the regenerated pipeline, measure blast radius vs baseline,
# run drift-check v1.1, and log to results.csv.
# Usage: tools/expBC-collect.sh B   |   tools/expBC-collect.sh C
set -euo pipefail
exp="${1:?B or C}"
script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
root="$(cd "$script_dir/.." && pwd)"
work="/tmp/exp${exp}-run"
case "$exp" in
  B) dest="$root/experiments/B-req-change"; note="requested the baseline model identifier; provider-served revision not independently verified" ;;
  C) dest="$root/experiments/C-unpinned";  note="requested a different model identifier; single descriptive comparison" ;;
  *) echo "arg must be B or C"; exit 1 ;;
esac
for f in SPEC.md STORIES.md SCENARIOS.md TESTPLAN.md; do
  [[ -f "$work/$f" ]] || { echo "ERROR: $work/$f missing"; exit 1; }
done
[[ ! -e "$dest" ]] || { echo "ERROR: destination already exists; refusing to overwrite: $dest" >&2; exit 1; }
if awk -F, -v experiment="$exp" '$1 == experiment && $2 == "01" { found=1 } END { exit found ? 0 : 1 }' "$root/experiments/results.csv"; then
  echo "ERROR: results.csv already contains experiment $exp run 01" >&2
  exit 1
fi

metadata_value() { sed -n "s/^- $1: //p" "$2" | head -1; }
expected_skill_hash() {
  if git -C "$root" rev-parse --verify "instructions/v1.0.0^{commit}" >/dev/null 2>&1; then
    git -C "$root" show "instructions/v1.0.0:skills/$1/SKILL.md" | bash "$root/tools/prompt-hash.sh" /dev/stdin
  else
    local file="$root/skills/$1/SKILL.md" declared actual
    declared=$(sed -n 's/^prompt_hash: //p' "$file" | head -1)
    actual=$(bash "$root/tools/prompt-hash.sh" "$file")
    [[ -n "$declared" && "$declared" == "$actual" ]] || return 1
    printf '%s\n' "$actual"
  fi
}
skill_for_file() {
  case "$1" in
    SPEC.md) echo spec-generator ;;
    STORIES.md) echo story-generator ;;
    SCENARIOS.md) echo scenario-generator ;;
    TESTPLAN.md) echo test-generator ;;
  esac
}
for f in SPEC.md STORIES.md SCENARIOS.md TESTPLAN.md; do
  skill=$(skill_for_file "$f")
  tag=$(metadata_value "Skill Git Tag" "$work/$f")
  recorded_hash=$(metadata_value "Prompt Hash" "$work/$f")
  expected_hash=$(expected_skill_hash "$skill")
  [[ "$tag" == "instructions/v1.0.0" ]] || { echo "ERROR: $f has unexpected or missing skill tag: ${tag:-none}" >&2; exit 1; }
  [[ "$recorded_hash" == "$expected_hash" ]] || { echo "ERROR: $f prompt hash does not match instructions/v1.0.0" >&2; exit 1; }
done

mkdir -p "$dest"
cp "$work"/{SPEC.md,STORIES.md,SCENARIOS.md,TESTPLAN.md} "$work/pet-store-requirements.md" "$dest/"
fr=$(grep -c '^FR[0-9]*:' "$dest/SPEC.md" || true)
ifr=$(grep -c '^IFR[0-9]*' "$dest/SPEC.md" || true)
st=$(grep -c '^Story ' "$dest/STORIES.md" || true)
sc=$(grep -c '^Scenario ' "$dest/SCENARIOS.md" || true)
tc=$(grep -c '^TC[0-9]*' "$dest/TESTPLAN.md" || true)
model=$(metadata_value "Model" "$dest/SPEC.md")
echo "$exp: FR=$fr IFR=$ifr stories=$st scenarios=$sc tests=$tc model=$model"
# Layer 2: log all four stage events. Added after an audit of the harness found that
# runs embedded Layer-1 metadata but were never written to the generation log.
reldest="${dest#"$root"/}"
for stage in "spec-generator|SPEC.md|pet-store-requirements.md" \
             "story-generator|STORIES.md|SPEC.md" \
             "scenario-generator|SCENARIOS.md|STORIES.md" \
             "test-generator|TESTPLAN.md|SCENARIOS.md"; do
  IFS='|' read -r sk out inp <<< "$stage"
  stage_model=$(metadata_value "Model" "$dest/$out")
  generated=$(metadata_value "Generated" "$dest/$out")
  temperature=$(metadata_value "Temperature" "$dest/$out")
  [[ -n "$stage_model" && -n "$generated" && -n "$temperature" ]] || { echo "ERROR: incomplete generation metadata in $out" >&2; exit 1; }
  GENERATED_AT="$generated" bash "$root/tools/log-generation.sh" "$sk" 1.0.0 "$stage_model" not-recorded "$temperature" \
    "$reldest/$out" "$reldest/$inp" >/dev/null
done
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
if bash "$root/tools/drift-check.sh" "$root/artifacts/SPEC_v1.0.md" "$dest/SPEC.md"; then wb_v11="yes"; else wb_v11="no"; fi
requirement_ids() { grep -E '^- R[0-9]+:' "$1" | grep -Eo 'R[0-9]+' | sort -u; }
source_tags() { grep -E '^FR[0-9]+:' "$1" | grep -Eo '\[source:[^]]*\]' | grep -Eo 'R[0-9]+' | sort -u; }
missing_r=$(comm -23 <(requirement_ids "$dest/pet-store-requirements.md") <(source_tags "$dest/SPEC.md"))
[[ -z "$missing_r" ]] && source_cov="yes" || source_cov="no"
base_fr=$(grep -c '^FR[0-9]*:' "$root/artifacts/SPEC_v1.0.md" || true)
if [[ "$fr" -eq "$base_fr" ]]; then wb_v10="yes"; else wb_v10="no"; fi
csv_quote() { local value=${1//\"/\"\"}; printf '"%s"' "$value"; }
{
  printf '%s,01,' "$exp"
  csv_quote "${model:-unknown}"
  printf ','
  csv_quote "not-recorded"
  printf ','
  csv_quote "$(metadata_value "Temperature" "$dest/SPEC.md")"
  printf ',instructions/v1.0.0,%s,%s,%s,%s,%s,%s,n/a,%s,%s,' \
    "$fr" "$ifr" "$st" "$sc" "$tc" "$source_cov" "$wb_v10" "$wb_v11"
  csv_quote "$note"
  printf '\n'
} >> "$root/experiments/results.csv"
rm -rf "$work"
echo ""
echo "collected -> $dest ; results.csv updated ; workspace cleaned"
echo "NOTE: the requirements changed, so a count difference cannot be attributed to model identity alone."
