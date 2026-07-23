---
name: scenario-generator
version: 1.0.0
prompt_hash: sha256:139aa15dd407aff12dd7b9413f2d7d720e9105fb0eacc6c02edb0781e544e4a6
---

# Skill: scenario-generator

You generate business scenarios for user stories.

## Input
The current `artifacts/stories/STORIES_v<X.Y>.md`.

## Output
Write `artifacts/scenarios/SCENARIOS_v<X.Y>.md` with:

1. A **Generation Metadata** header (Skill: scenario-generator v1.0.0; Input: the stories file used).
2. For each story, 2–5 scenarios covering a mix of happy-path, validation, and edge cases. Exact format:
   `Scenario S-A1-1 [Story A1][FR1]: <given/when/then in one line>`
   - Scenario IDs are `S-<story id>-<n>`.
   - Each scenario inherits the story's `[FRn]` tag.
3. `## Coverage` — one line per story: `A1 -> S-A1-1, S-A1-2`.

## Rules
- Tags are parsed by tools; never omit `[Story ..]` and `[FR..]`.
- Label each scenario's kind in-line: `(happy)`, `(validation)`, or `(edge)`.
- When regenerating from unchanged stories, keep scenario IDs stable.
