#!/usr/bin/env bash
# Regression checks for the artifact's mechanical validation and logging tools.
set -euo pipefail

root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
tmp="$(mktemp -d)"
trap 'rm -rf "$tmp"' EXIT

pass() { printf 'PASS: %s\n' "$1"; }
expect_fail() {
  local label="$1"; shift
  if "$@" >"$tmp/out" 2>"$tmp/err"; then
    echo "FAIL: $label unexpectedly succeeded" >&2
    exit 1
  fi
  pass "$label"
}

touch "$tmp/empty.md"
expect_fail "empty specifications are rejected" \
  bash "$root/tools/drift-check.sh" "$tmp/empty.md" "$tmp/empty.md"

cat >"$tmp/malformed.md" <<'EOF'
FR1: Text without a source tag.
IFR1 (FR1): Interpretation.
EOF
expect_fail "malformed source tags are rejected" \
  bash "$root/tools/drift-check.sh" "$tmp/malformed.md" "$tmp/malformed.md"

cat >"$tmp/old.md" <<'EOF'
FR1: Text containing R99 in prose. [source: R2]
IFR1 (FR1): Interpretation.
EOF
cat >"$tmp/new.md" <<'EOF'
FR1: Text containing R2 in prose. [source: R3]
IFR1 (FR1): Interpretation.
EOF
expect_fail "only bracketed source tags count as requirement coverage" \
  bash "$root/tools/drift-check.sh" "$tmp/old.md" "$tmp/new.md"

repo="$tmp/logger-repo"
mkdir -p "$repo/tools" "$repo/skills/spec-generator" "$repo/artifacts"
cp "$root/tools/log-generation.sh" "$root/tools/prompt-hash.sh" "$repo/tools/"
cp "$root/skills/spec-generator/SKILL.md" "$repo/skills/spec-generator/SKILL.md"
printf 'output with a quote: " and a backslash: \\\n' >"$repo/artifacts/output.md"
git -C "$repo" init -q
git -C "$repo" config user.name 'Regression "User"'
git -C "$repo" config user.email regression@example.invalid
git -C "$repo" add .
git -C "$repo" commit -qm initial
GENERATED_AT=2026-10-13T12:00:00Z bash "$repo/tools/log-generation.sh" \
  spec-generator 1.0.0 'model "quoted"' not-recorded default \
  artifacts/output.md 'input with "quotes" and \\slashes' >/dev/null
python3 - "$repo/.provenance/generation-log/2026-10/generation.jsonl" <<'PY'
import json
import sys
with open(sys.argv[1], encoding="utf-8") as stream:
    rows = [json.loads(line) for line in stream]
assert len(rows) == 1
assert rows[0]["model"] == 'model "quoted"'
assert rows[0]["input"] == 'input with "quotes" and \\\\slashes'
assert rows[0]["generated_at"] == "2026-10-13T12:00:00Z"
assert rows[0]["logged_at"]
assert rows[0]["event_id"]
PY
pass "generation events remain valid JSON with quoted values"

expect_fail "invalid generation timestamps are rejected" \
  env GENERATED_AT=not-a-time bash "$repo/tools/log-generation.sh" \
    spec-generator 1.0.0 model not-recorded default artifacts/output.md input

echo "All tool regression checks passed."
