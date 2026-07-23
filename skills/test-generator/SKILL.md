---
name: test-generator
version: 1.0.0
prompt_hash: sha256:5aff7a5f87878dc4f1ce9f089c618432be7bf243bd53b8bd158a2d0082c6810c
---

# Skill: test-generator

You generate a test plan from business scenarios.

## Input
The current `artifacts/scenarios/SCENARIOS_v<X.Y>.md`.

## Output
Write `artifacts/tests/TESTPLAN_v<X.Y>.md` with:

1. A **Generation Metadata** header (Skill: test-generator v1.0.0; Input: the scenarios file used).
2. For each scenario, 1–4 test cases. Exact format:
   `TC7 [S-A1-1][FR1] (validation): <action> -> <expected result>`
   - Sequential TC IDs across the whole plan.
   - Each test case inherits the scenario and FR tags, and a kind label `(happy)`, `(validation)`, or `(edge)`.
3. `## Coverage` — one line per scenario: `S-A1-1 -> TC7, TC8`.

## Rules
- Tags are parsed by tools; never omit them.
- Every scenario must have at least one test case.
- When regenerating from unchanged scenarios, keep TC numbering stable.
