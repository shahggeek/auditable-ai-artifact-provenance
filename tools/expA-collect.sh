#!/usr/bin/env bash
# Experiment A: collect one run's SPEC, measure drift vs baseline, log to results.csv.
# Usage: tools/expA-collect.sh <run-number 1..10>
set -euo pipefail
raw_n="${1:?run number 1..10}"
[[ "$raw_n" =~ ^([1-9]|10)$ ]] || { echo "ERROR: run number must be 1..10" >&2; exit 1; }
n=$(printf "%02d" "$((10#$raw_n))")
script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
root="$(cd "$script_dir/.." && pwd)"
work="/tmp/expA-run-$n"
dest="$root/experiments/A-pinned/run-$n"
base="$root/artifacts/SPEC_v1.0.md"
[[ -f "$work/SPEC.md" ]] || { echo "ERROR: $work/SPEC.md not found — did the session write it?"; exit 1; }
[[ ! -e "$dest" ]] || { echo "ERROR: destination already exists; refusing to overwrite: $dest" >&2; exit 1; }
if awk -F, -v run="$n" '$1 == "A" && $2 == run { found=1 } END { exit found ? 0 : 1 }' "$root/experiments/results.csv"; then
  echo "ERROR: results.csv already contains experiment A run $n" >&2
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
tag=$(metadata_value "Skill Git Tag" "$work/SPEC.md")
recorded_hash=$(metadata_value "Prompt Hash" "$work/SPEC.md")
expected_hash=$(expected_skill_hash spec-generator)
[[ "$tag" == "instructions/v1.0.0" ]] || { echo "ERROR: unexpected or missing skill tag: ${tag:-none}" >&2; exit 1; }
[[ "$recorded_hash" == "$expected_hash" ]] || { echo "ERROR: recorded prompt hash does not match instructions/v1.0.0" >&2; exit 1; }

mkdir -p "$dest"
cp "$work/SPEC.md" "$dest/SPEC.md"
fr=$(grep -c '^FR[0-9]*:' "$dest/SPEC.md" || true)
ifr=$(grep -c '^IFR[0-9]*' "$dest/SPEC.md" || true)
model=$(metadata_value "Model" "$dest/SPEC.md")
generated=$(metadata_value "Generated" "$dest/SPEC.md")
temperature=$(metadata_value "Temperature" "$dest/SPEC.md")
[[ -n "$model" && -n "$generated" && -n "$temperature" ]] || { echo "ERROR: incomplete generation metadata" >&2; exit 1; }
echo "run-$n: FR=$fr IFR=$ifr model=$model"
# Layer 2: log the generation event. Added after an audit of the harness found that
# runs embedded Layer-1 metadata but were never written to the generation log.
GENERATED_AT="$generated" bash "$root/tools/log-generation.sh" spec-generator 1.0.0 "$model" not-recorded "$temperature" \
  "experiments/A-pinned/run-$n/SPEC.md" "requirements/pet-store-requirements.md" >/dev/null
if bash "$root/tools/drift-check.sh" "$base" "$dest/SPEC.md"; then wb_v11="yes"; else wb_v11="no"; fi
source_tags() { grep -E '^FR[0-9]+:' "$1" | grep -Eo '\[source:[^]]*\]' | grep -Eo 'R[0-9]+' | sort -u; }
missing_source=$(comm -23 \
  <(source_tags "$base") \
  <(source_tags "$dest/SPEC.md"))
[[ -z "$missing_source" ]] && source_cov="yes" || source_cov="no"
missing_fr=$(comm -23 \
  <(grep -o '^FR[0-9]*' "$base" | sort -u) \
  <(grep -o '^FR[0-9]*' "$dest/SPEC.md" | sort -u))
[[ -z "$missing_fr" ]] && legacy_fr="yes" || legacy_fr="no"
base_fr=$(grep -c '^FR[0-9]*:' "$base" || true)
if [[ "$fr" -eq "$base_fr" && "$legacy_fr" == "yes" ]]; then wb_v10="yes"; else wb_v10="no"; fi
csv_quote() { local value=${1//\"/\"\"}; printf '"%s"' "$value"; }
{
  printf 'A,%s,' "$n"
  csv_quote "${model:-unknown}"
  printf ','
  csv_quote "not-recorded"
  printf ','
  csv_quote "$temperature"
  printf ',instructions/v1.0.0,%s,%s,,,,%s,%s,%s,%s,' \
    "$fr" "$ifr" "$source_cov" "$legacy_fr" "$wb_v10" "$wb_v11"
  csv_quote "future run; requested and recorded model identifier; provider-served revision not independently verified"
  printf '\n'
} >> "$root/experiments/results.csv"
rm -rf "$work"
echo "collected -> $dest/SPEC.md ; results.csv updated ; workspace cleaned"
