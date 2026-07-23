#!/usr/bin/env bash
# Layer 4: hash a skill's instruction content, excluding YAML frontmatter.
# Usage: tools/prompt-hash.sh skills/spec-generator/SKILL.md [--update]
#   --update  writes the hash back into the file's frontmatter (prompt_hash: field)
set -euo pipefail
f="${1:?usage: prompt-hash.sh <SKILL.md> [--update]}"
hash=$(awk '/^---$/{++n; next} n>=2' "$f" | shasum -a 256 | cut -d' ' -f1)
echo "sha256:$hash"
if [[ "${2:-}" == "--update" ]]; then
  tmp=$(mktemp)
  sed "s/^prompt_hash: .*/prompt_hash: sha256:$hash/" "$f" > "$tmp" && mv "$tmp" "$f"
  echo "updated frontmatter in $f"
fi
