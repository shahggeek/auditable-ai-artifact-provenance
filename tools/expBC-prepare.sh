#!/usr/bin/env bash
# Experiments B & C: prepare an isolated full-pipeline workspace with requirements v1.1
# (R11 sold-out label + R12 duplicate-order prevention uncommented).
# Usage: tools/expBC-prepare.sh B   |   tools/expBC-prepare.sh C
set -euo pipefail
exp="${1:?B or C}"; [[ "$exp" == "B" || "$exp" == "C" ]] || { echo "arg must be B or C"; exit 1; }
root="$(git rev-parse --show-toplevel)"
work="/tmp/exp${exp}-run"
rm -rf "$work"; mkdir -p "$work/skills"
# Build requirements v1.1: baseline R1-R10 plus R11/R12 promoted from the comment block
python3 - "$root/requirements/pet-store-requirements.md" "$work/pet-store-requirements.md" <<'EOF'
import re, sys
src, dst = sys.argv[1], sys.argv[2]
t = open(src).read()
block = re.search(r"<!--.*?-->", t, re.S).group(0)
extras = [l.strip() for l in block.splitlines() if l.strip().startswith("- R1")]
t = re.sub(r"\n*<!--.*?-->\n*", "\n", t, flags=re.S).rstrip()
t = t.replace("Business Requirements v1.0", "Business Requirements v1.1")
t += "\n" + "\n".join(extras) + "\n"
open(dst, "w").write(t)
EOF
for s in spec story scenario test; do cp "$root/skills/${s}-generator/SKILL.md" "$work/skills/${s}-generator-SKILL.md"; done
h() { bash "$root/tools/prompt-hash.sh" "$root/skills/$1-generator/SKILL.md"; }
if [[ "$exp" == "B" ]]; then
  model_line="claude --model claude-fable-5     # PINNED: must match baseline/Experiment A"
else
  model_line="claude --model claude-sonnet-5    # UNPINNED: any model EXCEPT claude-fable-5; keep a note of which"
fi
cat <<EOT

Workspace ready: $work  (requirements v1.1 + the four v1.0.0 skills; nothing else)

NEXT STEPS
1) cd $work
2) Start a BRAND-NEW session:  $model_line
3) Paste this prompt exactly:
--------------------------------------------------------------------
Run a four-stage generation pipeline in this directory. Read ONLY the
files in this directory. At each stage, follow the named skill file
exactly, but write outputs to this directory with the simple names
below (not the artifacts/ paths mentioned inside the skills).

Stage 1: follow skills/spec-generator-SKILL.md against
  pet-store-requirements.md -> write SPEC.md
Stage 2: follow skills/story-generator-SKILL.md against SPEC.md
  -> write STORIES.md
Stage 3: follow skills/scenario-generator-SKILL.md against STORIES.md
  -> write SCENARIOS.md
Stage 4: follow skills/test-generator-SKILL.md against SCENARIOS.md
  -> write TESTPLAN.md

In every Generation Metadata header record: your exact model id on the
Model line; Temperature: default (not exposed); the current UTC time;
Skill Git Tag: instructions/v1.0.0; Input: the file the stage consumed;
and the stage's Prompt Hash from this list:
  spec-generator:     $(h spec)
  story-generator:    $(h story)
  scenario-generator: $(h scenario)
  test-generator:     $(h test)
--------------------------------------------------------------------
4) Wait until all four files exist, then /exit.
5) cd $root && tools/expBC-collect.sh $exp
EOT
