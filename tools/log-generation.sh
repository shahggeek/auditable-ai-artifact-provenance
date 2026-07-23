#!/usr/bin/env bash
# Layer 2: append a generation event to the JSONL log.
# Usage: tools/log-generation.sh <skill> <skill_version> <model> <model_version> <temperature> <output_file> <input>
set -euo pipefail
skill="${1:?skill}"; ver="${2:?version}"; model="${3:?model}"; model_ver="${4:?model_version}"
temp="${5:?temperature}"; out="${6:?output_file}"; input="${7:?input}"
root="$(git rev-parse --show-toplevel)"
ph=$("$root/tools/prompt-hash.sh" "$root/skills/$skill/SKILL.md")
oh="sha256:$(shasum -a 256 "$root/$out" | cut -d' ' -f1)"
dir="$root/.claude/generation-log/$(date -u +%Y-%m)"
mkdir -p "$dir"
printf '{"timestamp":"%s","skill":"%s","skill_version":"%s","skill_commit":"%s","prompt_hash":"%s","model":"%s","model_version":"%s","temperature":"%s","output_file":"%s","output_hash":"%s","user":"%s","repo":"%s","branch":"%s","input":"%s"}\n' \
  "$(date -u +%Y-%m-%dT%H:%M:%SZ)" "$skill" "$ver" "$(git rev-parse --short HEAD)" "$ph" \
  "$model" "$model_ver" "$temp" "$out" "$oh" "$(git config user.name)" \
  "$(basename "$root")" "$(git rev-parse --abbrev-ref HEAD)" "$input" \
  >> "$dir/generation.jsonl"
echo "logged: $skill v$ver -> $out"
