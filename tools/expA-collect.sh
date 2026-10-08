#!/usr/bin/env bash
# Experiment A: collect one run's SPEC, measure drift vs baseline, log to results.csv.
# Usage: tools/expA-collect.sh <run-number 1..10>
set -euo pipefail
n=$(printf "%02d" "${1:?run number 1..10}")
root="$(git rev-parse --show-toplevel)"
work="/tmp/expA-run-$n"
dest="$root/experiments/A-pinned/run-$n"
base="$root/artifacts/SPEC_v1.0.md"
[[ -f "$work/SPEC.md" ]] || { echo "ERROR: $work/SPEC.md not found — did the session write it?"; exit 1; }
mkdir -p "$dest"
cp "$work/SPEC.md" "$dest/SPEC.md"
fr=$(grep -c '^FR[0-9]*:' "$dest/SPEC.md" || true)
ifr=$(grep -c '^IFR[0-9]*' "$dest/SPEC.md" || true)
model=$(sed -n 's/^- Model: \(.*\)/\1/p' "$dest/SPEC.md" | head -1)
echo "run-$n: FR=$fr IFR=$ifr model=$model"
# Layer 2: log the generation event. Added after an audit of the harness found that
# runs embedded Layer-1 metadata but were never written to the generation log.
bash "$root/tools/log-generation.sh" spec-generator 1.0.0 "$model" "$model" default \
  "experiments/A-pinned/run-$n/SPEC.md" "requirements/pet-store-requirements.md" >/dev/null
if bash "$root/tools/drift-check.sh" "$base" "$dest/SPEC.md"; then wb_v11="yes"; else wb_v11="no"; fi
missing_source=$(comm -23 \
  <(grep '^FR' "$base" | grep -o 'R[0-9][0-9]*' | sort -u) \
  <(grep '^FR' "$dest/SPEC.md" | grep -o 'R[0-9][0-9]*' | sort -u))
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
  csv_quote "${model:-unknown}"
  printf ',default,instructions/v1.0.0,%s,%s,,,,%s,%s,%s,%s,' \
    "$fr" "$ifr" "$source_cov" "$legacy_fr" "$wb_v10" "$wb_v11"
  csv_quote "future run collected by expA-collect.sh"
  printf '\n'
} >> "$root/experiments/results.csv"
rm -rf "$work"
echo "collected -> $dest/SPEC.md ; results.csv updated ; workspace cleaned"
