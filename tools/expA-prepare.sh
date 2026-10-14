#!/usr/bin/env bash
# Experiment A: prepare an isolated workspace for one same-recorded-conditions run.
# Usage: tools/expA-prepare.sh <run-number 1..10>
# Creates /tmp/expA-run-NN containing only the requirements and the skill extracted from the recorded tag,
# so a fresh assistant session cannot see the repo, prior runs, or the baseline.
set -euo pipefail
raw_n="${1:?run number 1..10}"
[[ "$raw_n" =~ ^([1-9]|10)$ ]] || { echo "ERROR: run number must be 1..10" >&2; exit 1; }
n=$(printf "%02d" "$((10#$raw_n))")
script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
root="$(cd "$script_dir/.." && pwd)"
work="/tmp/expA-run-$n"
tag="instructions/v1.0.0"
rm -rf "$work"; mkdir -p "$work"
cp "$root/requirements/pet-store-requirements.md" "$work/"
if git -C "$root" rev-parse --verify "$tag^{commit}" >/dev/null 2>&1; then
  git -C "$root" show "$tag:skills/spec-generator/SKILL.md" > "$work/SKILL.md"
else
  cp "$root/skills/spec-generator/SKILL.md" "$work/SKILL.md"
  declared=$(sed -n 's/^prompt_hash: //p' "$work/SKILL.md" | head -1)
  actual=$(bash "$root/tools/prompt-hash.sh" "$work/SKILL.md")
  [[ -n "$declared" && "$declared" == "$actual" ]] || {
    echo "ERROR: packaged spec-generator instruction file does not match its declared hash" >&2
    exit 1
  }
  echo "NOTE: Git tag history is unavailable; using the packaged instruction file after hash verification." >&2
fi
ph=$(bash "$root/tools/prompt-hash.sh" "$work/SKILL.md")
cat <<EOF

Workspace ready: $work

NEXT STEPS
1) cd $work
2) Start a BRAND-NEW session:  claude --model claude-fable-5
   (request the same model identifier for all 10 runs; verify the displayed identifier with /status)
3) Paste this prompt exactly:

--------------------------------------------------------------------
Read SKILL.md in this directory and follow it exactly to generate a
specification from pet-store-requirements.md. Write the result to
SPEC.md in this directory (instead of the artifacts/ path the skill
mentions). Do not read or search for any other files. Do not ask me
any questions. In the Generation Metadata header use:
- Skill Git Tag: instructions/v1.0.0
- Prompt Hash: $ph
- Input: requirements/pet-store-requirements.md
- Model: your exact model id
- Temperature: default (not exposed)
- Generated: current UTC time
--------------------------------------------------------------------

4) When SPEC.md is written, exit the session (/exit).
5) cd $root && tools/expA-collect.sh ${1}
EOF
