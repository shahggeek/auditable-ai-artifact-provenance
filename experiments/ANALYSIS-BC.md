# Experiments B & C — Analysis

**Design.** Starting from requirements v1.1 (baseline R1–R10 **plus** R11 "display sold-out pets with a label" and R12 "prevent duplicate orders"), the full SDD pipeline was regenerated once each:

- **Experiment B (pinned):** same model as the baseline (`claude-fable-5`), same hashed skills.
- **Experiment C (unpinned):** a *different* model (`claude-sonnet-5`), same hashed skills, same requirements.

Both are single runs (n=1); Experiment A (n=10 retained outputs) provides a descriptive same-model reference range, not a validated noise floor.

## Results

| Metric | Baseline v1.0 | B — pinned | C — unpinned |
|---|---|---|---|
| Functional requirements (FR) | 8 | **11** | **6** |
| Interpreted FRs (IFR) | 8 | 11 | 6 |
| Stories | 5 | 6 | 6 |
| Scenarios | 14 | 22 | 20 |
| Test cases | 16 | **32** | **20** |
| **Source-tag requirement coverage** | 10/10 | **12/12** | **12/12** |
| FR per requirement (granularity) | 0.80 | **0.92** | **0.50** |

Experiment A established the same-model granularity band: **0.70–0.90 FR/requirement**.

## Findings

1. **Source-tag coverage held across every condition.** Both regenerations retained the source tags of all 12 requirements, including the two new ones (R11, R12 tagged in both). As in Experiment A, divergence was structural, not identifier loss; this checks tag presence, not meaning.

2. **The pinned run was close to, but outside, the observed same-model band.** B decomposed 12 requirements into 11 FRs — 0.92 FR/req, which is 0.02 above the 0.70–0.90 band observed in Experiment A. Because the requirements also changed and B contains only one run, the excess cannot be attributed separately to the requested change or regeneration variation. The result does not validate the band as a threshold.

3. **Cross-model regeneration diverged well beyond the same-model band.** For the same requirements, the unpinned model produced a different specification structure: **6 FRs vs. 11 (about 2:1 in decomposition granularity), and 20 test cases vs. 32.** At 0.50 FR/req, C sits far outside the same-model band (0.70 to 0.90). In this single comparison, the cross-model gap (0.42 FR/req) was about twice the width of the same-model band (0.20): model choice *can* dominate structural drift, though one comparison cannot show that it generally does. This is why the framework records model identity in the artifact metadata (Layer 1) and why provenance-guided regeneration pins the model.

4. **Both runs triggered escalation, but these data cannot validate the decision rule.** B and C both breached the count budget, as a requirement change may be expected to do. Their recorded conditions and source tags make the differences inspectable: B used the pinned model and produced 11 FRs, whereas C used a different model and produced 6. Whether either result should be accepted requires a validated threshold and semantic review; these two single runs do not establish that policy.

## Methodological caution (honest measurement note)

Raw line-level churn is **not** a clean drift metric here, and we do not rely on it. Because B produced a larger specification (11 FR, 32 tests) and C a leaner one (6 FR, 20 tests), raw diff size is confounded by output verbosity — by changed-line count B actually differs *more* from the baseline than C, which would invert the real conclusion. The size-normalized metric (FR per requirement, benchmarked against Experiment A's same-model band) is the honest measure of structural drift, and it is what Findings 2–3 rest on. This mirrors the calibration lesson of Experiment A: naive count/percentage metrics mislead; source-tag coverage plus normalized structure are the instruments used here.

## Limitations

- B and C are single runs each. Experiment A provides ten retained same-model observations but is too small and includes one unexplained replacement, so its observed range is descriptive rather than a validated noise floor. The cross-model divergence is a single instance and should not be read as an effect-size estimate. Repeating both conditions across tasks and models is necessary.
- One model pair (`claude-fable-5` vs `claude-sonnet-5`); magnitude will vary by pair.
- The `claude-fable-5` baseline/A/B model self-reported its name three different ways across headers ("Claude Fable 5" / "Fable 5" / "claude-fable-5"), a live illustration that this metadata is self-reported. The parenthetical model ID was stable and is the reliable field. No dated model version string was available, so `model_version` in `results.csv` repeats the reported model name.
