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
if bash "$root/tools/drift-check.sh" "$base" "$dest/SPEC.md"; then wb="yes"; else wb="no"; fi
missing=$(comm -23 <(grep -o '^FR[0-9]*' "$base" | sort -u) <(grep -o '^FR[0-9]*' "$dest/SPEC.md" | sort -u))
[[ -z "$missing" ]] && cov="yes" || cov="no"
echo "A,$n,${model:-unknown},${model:-unknown},default,instructions/v1.0.0,$fr,$ifr,,,,$cov,$wb," >> "$root/experiments/results.csv"
rm -rf "$work"
echo "collected -> $dest/SPEC.md ; results.csv updated ; workspace cleaned"
