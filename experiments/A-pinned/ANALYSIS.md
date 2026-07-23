# Experiment A — Analysis

**Protocol:** 10 independent regenerations of the specification from identical inputs — same requirements (R1–R10), same skill (`spec-generator` v1.0.0, prompt hash `bc1930c7…`), same model (`claude-fable-5`), default temperature — each in a fresh session with an isolated two-file workspace (no access to prior outputs). Baseline: `artifacts/SPEC_v1.0.md` (8 FR / 8 IFR).

## Results

| Metric | Value |
|---|---|
| FR/IFR count distribution | **8 → ×4 runs · 9 → ×4 runs · 7 → ×2 runs** (baseline 8) |
| Range / median / mean | 7–9 / 8 / 8.2 |
| Distinct structural variants | 3 |
| **Semantic requirement coverage** (all 10 R-items traceable to an FR) | **10/10 runs — no run lost a requirement** |
| Within ±10% count budget (v1.0 check) | 4/10 runs |
| Flagged as FR-coverage loss by ID-based check (v1.0) | 2/10 runs — **both false alarms** (regrouping, not loss) |

## Findings

1. **Same-model non-determinism is real under fully pinned conditions.** Ten independent runs with identical inputs produced three distinct structural outcomes (7, 8, or 9 FRs). This reproduces, publicly and under tighter controls, the same phenomenon observed in the original 110-participant workshop (6/8/9 clarifying questions in its same-model cohort).
2. **The semantic core was stable in every run.** All 10 runs preserved complete requirement coverage — every R-item remained traceable to a functional requirement. The drift was *structural regrouping* (splitting or merging FRs), not content loss. This is direct evidence that behavioral stability is the right target: structure varies, meaning held.
3. **The v1.0 drift budget was miscalibrated — in two instructive ways.**
   - A ±10% *percentage* budget at a count of 8 allows zero integer variation, so any structural difference breached it (6/10 runs). Percentage budgets need an absolute floor at small artifact counts.
   - The *ID-based* FR-coverage check flagged the two 7-FR runs as coverage loss when both had merely regrouped requirements. Coverage must be checked *semantically* — via the `[source: Rn]` tags — not by FR ID continuity.

## Instrument calibration (v1.1)

Based on these findings, `tools/drift-check.sh` v1.1:
- checks **semantic requirement coverage** (source-tag sets) as the absolute criterion; FR-ID continuity is reported as informational only;
- applies the count budget as `max(±1 absolute, ±BUDGET_PCT%)` so small artifacts get an integer-honest band.

Re-scored under v1.1: **10/10 runs within budget** — all counts fall in the ±1 band and all runs pass the semantic-coverage criterion. Two transparency notes: (a) v1.0 verdicts are retained unchanged in `results.csv`; (b) the v1.1 band is a *post-hoc* calibration derived from this data, so it must be treated as a proposed setting to be validated on subsequent regenerations (Experiments B/C and beyond), not as a result of this experiment.
