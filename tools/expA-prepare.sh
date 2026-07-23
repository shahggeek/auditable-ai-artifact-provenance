#!/usr/bin/env bash
# Experiment A: prepare an isolated workspace for one pinned regeneration run.
# Usage: tools/expA-prepare.sh <run-number 1..10>
# Creates /tmp/expA-run-NN containing ONLY the requirements and the pinned skill,
# so a fresh assistant session cannot see the repo, prior runs, or the baseline.
set -euo pipefail
n=$(printf "%02d" "${1:?run number 1..10}")
root="$(git rev-parse --show-toplevel)"
work="/tmp/expA-run-$n"
rm -rf "$work"; mkdir -p "$work"
cp "$root/requirements/pet-store-requirements.md" "$work/"
cp "$root/skills/spec-generator/SKILL.md" "$work/"
ph=$(bash "$root/tools/prompt-hash.sh" "$root/skills/spec-generator/SKILL.md")
cat <<EOF

Workspace ready: $work

NEXT STEPS
1) cd $work
2) Start a BRAND-NEW session:  claude --model claude-fable-5
   (same model for all 10 runs; verify with /status)
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
