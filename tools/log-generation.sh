#!/usr/bin/env bash
# Layer 2: append a generation event to the JSONL log.
# Usage: tools/log-generation.sh <skill> <skill_version> <model> <model_version> <temperature> <output_file> <input>
# Optional environment variable: GENERATED_AT=<UTC timestamp recorded by the generator>
set -euo pipefail
skill="${1:?skill}"; ver="${2:?version}"; model="${3:?model}"; model_ver="${4:?model_version}"
temp="${5:?temperature}"; out="${6:?output_file}"; input="${7:?input}"
script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
root="$(cd "$script_dir/.." && pwd)"
[[ -f "$root/$out" ]] || { echo "ERROR: output file not found: $out" >&2; exit 1; }
[[ -f "$root/skills/$skill/SKILL.md" ]] || { echo "ERROR: skill file not found: skills/$skill/SKILL.md" >&2; exit 1; }
ph=$("$root/tools/prompt-hash.sh" "$root/skills/$skill/SKILL.md")
oh="sha256:$(shasum -a 256 "$root/$out" | cut -d' ' -f1)"
logged_at="$(date -u +%Y-%m-%dT%H:%M:%SZ)"
generated_at="${GENERATED_AT:-$logged_at}"
[[ "$generated_at" =~ ^[0-9]{4}-[0-9]{2}-[0-9]{2}T[0-9]{2}:[0-9]{2}:[0-9]{2}Z$ ]] || {
  echo "ERROR: GENERATED_AT must use UTC YYYY-MM-DDTHH:MM:SSZ format" >&2
  exit 1
}
dir="$root/.provenance/generation-log/${generated_at:0:7}"
mkdir -p "$dir"
skill_commit="$(git -C "$root" rev-parse --short HEAD 2>/dev/null || printf 'not-recorded')"
branch="$(git -C "$root" rev-parse --abbrev-ref HEAD 2>/dev/null || printf 'not-recorded')"
user_name="$(git -C "$root" config user.name 2>/dev/null || true)"
python3 - "$dir/generation.jsonl" "$generated_at" "$logged_at" "$skill" "$ver" \
  "$skill_commit" "$ph" "$model" "$model_ver" "$temp" "$out" "$oh" \
  "$user_name" "$(basename "$root")" "$branch" "$input" <<'PY'
import json
import sys
import uuid

(path, generated_at, logged_at, skill, version, commit, prompt_hash, model,
 model_version, temperature, output_file, output_hash, user, repo, branch,
 input_value) = sys.argv[1:]
event = {
    "event_id": str(uuid.uuid4()),
    "timestamp": generated_at,
    "generated_at": generated_at,
    "logged_at": logged_at,
    "skill": skill,
    "skill_version": version,
    "skill_commit": commit,
    "prompt_hash": prompt_hash,
    "model": model,
    "model_version": model_version,
    "temperature": temperature,
    "output_file": output_file,
    "output_hash": output_hash,
    "user": user,
    "repo": repo,
    "branch": branch,
    "input": input_value,
}
line = json.dumps(event, ensure_ascii=True, separators=(",", ":"))
json.loads(line)
with open(path, "a", encoding="utf-8") as stream:
    stream.write(line + "\n")
PY
echo "logged: $skill v$ver -> $out"
