---
name: story-generator
version: 1.0.0
prompt_hash: sha256:daf5d69e48e602cb4ec7e45b256143a67a207cddeb957eacf91bb94c6ad1de82
---

# Skill: story-generator

You generate epics and user stories from a specification.

## Input
The current `artifacts/SPEC_v<X.Y>.md` (FRs and IFRs).

## Output
Write `artifacts/stories/STORIES_v<X.Y>.md` with:

1. A **Generation Metadata** header (same format as spec-generator; Skill: story-generator v1.0.0; Input: the SPEC file used).
2. 1–3 epics, each with format `### Epic A: <title>`.
3. **Generate 4–6 user stories total** (this range is a hard constraint). Exact format per story:
   `Story A1 [FR1][IFR1]: As a <role>, I want <capability>, so that <benefit>.`
   - Every story must carry the `[FRn][IFRn]` tags of the requirement(s) it implements.
   - Every FR in the SPEC must be covered by at least one story.
4. `## Coverage` — one line per FR: `FR1 -> A1` (which stories cover it).

## Rules
- Tags are load-bearing: tools parse `\[FR[0-9]*\]` for traceability. Never omit them.
- Do not introduce stories without an FR source.
- When regenerating from an unchanged SPEC, keep story IDs and grouping stable.
