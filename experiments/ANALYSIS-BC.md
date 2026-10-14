# Experiments B & C — Analysis

**Design.** Starting from requirements v1.1 (baseline R1–R10 **plus** R11 "display sold-out pets with a label" and R12 "prevent duplicate orders"), the full SDD pipeline was regenerated once each:

- **Experiment B:** requested and recorded the baseline model identifier (`claude-fable-5`) and recorded the same instruction-file hashes.
- **Experiment C:** requested and recorded a different model identifier (`claude-sonnet-5`) while recording the same instruction-file hashes and using the same requirements as B.

Both are single runs (n=1); Experiment A (n=10 retained outputs sharing a recorded model identifier) provides a descriptive reference range, not a validated noise floor.

## Results

| Metric | Baseline v1.0 | B: baseline identifier | C: changed identifier |
|---|---|---|---|
| Functional requirements (FR) | 8 | **11** | **6** |
| Interpreted FRs (IFR) | 8 | 11 | 6 |
| Stories | 5 | 6 | 6 |
| Scenarios | 14 | 22 | 20 |
| Test cases | 16 | **32** | **20** |
| **Source-tag requirement coverage** | 10/10 | **12/12** | **12/12** |
| FR per requirement (granularity) | 0.80 | **0.92** | **0.50** |

Across Experiment A's ten retained outputs, the observed descriptive range was **0.70-0.90 FR/requirement**. It is not an established threshold or an independently validated noise floor.

## Findings

1. **Source-tag coverage held across every condition.** Both regenerations retained the source tags of all 12 requirements, including the two new ones (R11, R12 tagged in both). As in Experiment A, divergence was structural, not identifier loss; this checks tag presence, not meaning.

2. **The baseline-identifier run was close to, but outside, Experiment A's observed range.** B decomposed 12 requirements into 11 FRs, or 0.92 FR/requirement, which is 0.02 above the 0.70-0.90 range observed in Experiment A. Because the requirements also changed and B contains only one run, the excess cannot be attributed separately to the requested change, stochastic regeneration, or another uncontrolled difference. The result does not validate the range as a threshold.

3. **The two retained outputs differed substantially.** For the same requirements, B and C contained **11 versus 6 FRs and 32 versus 20 test cases**. C's 0.50 FR/requirement falls outside Experiment A's descriptive 0.70-0.90 range. With one output per requested identifier, the comparison cannot determine whether the difference arose from model identity, stochastic variation, task interaction, or another uncontrolled factor. It motivates recording model identity and repeating the comparison; it does not estimate a model effect.

4. **Both runs triggered escalation, but these data cannot validate the decision rule.** B and C both breached the count budget. Their recorded declarations and source tags make the differences inspectable: B recorded the baseline model identifier and produced 11 FRs, whereas C recorded a different identifier and produced 6. Whether either result should be accepted requires a validated threshold and semantic review; these two single runs do not establish that policy.

## Methodological caution

Raw line-level churn and FR-per-requirement describe different structural properties. Line churn is affected by output length and wording, while FR-per-requirement captures decomposition granularity but not semantic preservation. Neither measure identifies the cause of the B/C difference or validates a semantic-drift conclusion. Source-tag coverage adds an identifier-presence check, not a meaning-preservation check.

## Limitations

- B and C are single runs each. Experiment A provides ten retained observations sharing a recorded model identifier but is too small and includes one unexplained replacement, so its observed range is descriptive rather than a validated noise floor. The different-identifier comparison is a single instance and should not be read as an effect-size estimate. Repeating both conditions across tasks and models is necessary.
- One model pair (`claude-fable-5` vs `claude-sonnet-5`); magnitude will vary by pair.
- The baseline/A/B headers report the model name three ways ("Claude Fable 5", "Fable 5", and "claude-fable-5"). The parenthetical identifier is stable across those retained headers, but it remains a recorded declaration rather than independent verification of provider-served weights or revision. No dated model-version string was available; the historical `model_version` column repeats the recorded model field and must not be interpreted as additional version evidence.
