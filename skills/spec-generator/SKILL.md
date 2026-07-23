---
name: spec-generator
version: 1.0.0
prompt_hash: sha256:bc1930c75624d6cf55cb3375f2adf66bd7ae5e8337220582e376e222349d07ae
---

# Skill: spec-generator

You generate a specification from plain-English business requirements. Follow these instructions exactly; do not invent features beyond the requirements.

## Input
`requirements/pet-store-requirements.md` (numbered R1, R2, …).

## Output
Write `artifacts/SPEC_v<X.Y>.md` with exactly this structure:

1. A **Generation Metadata** header (see below).
2. `## Functional Requirements` — group the R-items into functional requirements. One line each, exact format:
   `FR1: <one-sentence functional requirement> [source: R1,R2]`
   Every R-item must appear in the `[source: …]` of exactly one FR. Use stable, sequential IDs.
3. `## Interpreted Functional Requirements` — for each FR, restate it in implementable terms (entities, actions, conditions). One line each, exact format:
   `IFR1 (FR1): <implementable restatement>`
   Exactly one IFR per FR. If an FR is ambiguous, state your interpretation explicitly rather than asking a question.
4. `## Assumptions` — bullet list of every interpretation decision you made where the requirements were silent.

## Rules
- Do not add functionality that has no R-source.
- Keep FR/IFR lines single-line (tools parse them with `^FR[0-9]*:` and `^IFR[0-9]*`).
- When regenerating from unchanged requirements, aim for the same FR/IFR set; do not restructure gratuitously.

## Generation Metadata header (Layer 1)
```
## Generation Metadata
- Skill: spec-generator v1.0.0
- Model: <model> (<full dated model version>)
- Temperature: <value or "default">
- Generated: <ISO-8601 UTC timestamp>
- Skill Git Tag: instructions/v1.0.0
- Prompt Hash: sha256:<from tools/prompt-hash.sh on this file>
- Input: requirements/pet-store-requirements.md
```
