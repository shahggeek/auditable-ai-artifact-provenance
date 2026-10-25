# Experiment A — Analysis

**Protocol:** 10 retained regenerations of the specification from identical declared inputs: the same requirements (R1-R10), the same recorded instruction-body hash (`bc1930c7...`), the same requested and recorded model identifier (`claude-fable-5`), and the tool's unexposed default temperature. Each retained run came from a fresh session with an isolated two-file workspace and no access to prior outputs. The provider-served model revision and numeric temperature were not independently verifiable. Baseline: `artifacts/SPEC_v1.0.md` (8 FR / 8 IFR).

## Results

| Metric | Value |
|---|---|
| FR/IFR count distribution | **8 → ×4 runs · 9 → ×4 runs · 7 → ×2 runs** (baseline 8) |
| Range / median / mean | 7–9 / 8 / 8.2 |
| Distinct FR-count values | 3 |
| Distinct source-grouping patterns | 5 ordered patterns; 4 partitions if FR order is ignored |
| **Source-tag requirement coverage** (all 10 R-items' `[source: Rn]` tags present in some FR) | **10/10 runs: no run lost a requirement tag** |
| Within ±10% count budget (v1.0 check) | 4/10 runs |
| Flagged as FR-coverage loss by ID-based check (v1.0) | 2/10 runs — **both false alarms** (regrouping, not loss) |

## Findings

1. **Structural variation under the same recorded conditions.** Ten retained runs with identical declared inputs, the same recorded instruction-body hash, and the same requested and recorded model identifier produced three distinct FR counts (7, 8, or 9), five ordered source-grouping patterns, and four grouping partitions when FR order is ignored. These records do not authenticate the provider-served model revision.
2. **Source-tag coverage was stable in every run.** All 10 runs retained every R-item's `[source: Rn]` tag in some functional requirement. The drift was *structural regrouping* (splitting or merging FRs), not identifier loss. This checks tag presence, not meaning: whether each regrouping preserved the requirement's meaning was not adjudicated.
3. **The v1.0 drift budget was miscalibrated — in two instructive ways.**
   - A ±10% *percentage* budget at a count of 8 allows zero integer variation, so any structural difference breached it (6/10 runs). Percentage budgets need an absolute floor at small artifact counts.
   - The *ID-based* FR-coverage check flagged the two 7-FR runs as coverage loss when both had merely regrouped requirements. Coverage must be checked via the `[source: Rn]` tags (source-tag coverage), not by FR ID continuity.

## Instrument calibration (v1.1)

Based on these findings, `tools/drift-check.sh` v1.1:
- checks **source-tag requirement coverage** (source-tag sets) as the absolute criterion; FR-ID continuity is reported as informational only;
- applies the count budget as `max(±1 absolute, ±BUDGET_PCT%)` so small artifacts get an integer-honest band.

Re-scored under v1.1: **10/10 runs within budget**: all counts fall in the ±1 band and all runs pass the source-tag coverage criterion. Three transparency notes: (a) v1.0 verdicts are retained unchanged in `results.csv`; (b) the v1.1 band is a *post-hoc* calibration derived from this data, so it must be treated as a proposed setting to be validated on subsequent regenerations (Experiments B/C and beyond), not as a result of this experiment; (c) run 08 was repeated once, the original attempt was not preserved, and the reason for the rerun was not recorded. The ten runs above are the ten retained outputs, including this one replacement; the retained run 08 is one of the two 7-FR runs flagged by the v1.0 ID-based check.
