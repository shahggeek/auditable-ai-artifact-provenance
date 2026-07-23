# Experiments B & C — Analysis

**Design.** Starting from requirements v1.1 (baseline R1–R10 **plus** R11 "display sold-out pets with a label" and R12 "prevent duplicate orders" — the same two changes introduced in the original workshop), the full SDD pipeline was regenerated once each:

- **Experiment B (pinned):** same model as the baseline (`claude-fable-5`), same hashed skills.
- **Experiment C (unpinned):** a *different* model (`claude-sonnet-5`), same hashed skills, same requirements.

Both are single runs (n=1); the same-model noise floor is characterized separately by Experiment A (n=10).

## Results

| Metric | Baseline v1.0 | B — pinned | C — unpinned |
|---|---|---|---|
| Functional requirements (FR) | 8 | **11** | **6** |
| Interpreted FRs (IFR) | 8 | 11 | 6 |
| Stories | 5 | 6 | 6 |
| Scenarios | 14 | 22 | 20 |
| Test cases | 16 | **32** | **20** |
| **Semantic requirement coverage** | 10/10 | **12/12** | **12/12** |
| FR per requirement (granularity) | 0.80 | **0.92** | **0.50** |

Experiment A established the same-model granularity band: **0.70–0.90 FR/requirement**.

## Findings

1. **Meaning held across every condition.** Both regenerations preserved complete semantic coverage of all 12 requirements — including the two new ones (R11, R12 traced in both). As in Experiment A, divergence was structural, not content loss. The behavioral-reproducibility thesis holds even across a model change.

2. **Same-model regeneration stayed within the noise floor.** B decomposed 12 requirements into 11 FRs — 0.92 FR/req, essentially at the ceiling of the same-model band (0.70–0.90) established by Experiment A. The requirement change added its expected content plus roughly the ±1 FR of same-model noise A already characterized. The blast radius was bounded and predictable.

3. **Cross-model regeneration diverged far beyond the noise floor — the headline result.** For *identical* requirements, the unpinned model produced a fundamentally different specification structure: **6 FRs vs. 11 (a ~2:1 difference in decomposition granularity), and 20 test cases vs. 32.** At 0.50 FR/req, C sits far outside the same-model band. **Model choice is thus the dominant controllable source of structural drift — an order of magnitude larger than same-model non-determinism** (±1 FR in A). This is exactly why the framework records model identity (Layer 1, §3.1) and why provenance-guided regeneration pins the model (§5.4).

4. **The drift budget did its job — and the escalation distinguished the two cases.** Both B and C tripped the count budget (any requirement change does; that is expected trigger-caused drift). The point of the budget is escalation to human review. On review, B's overage is within same-model noise and traces entirely to the requested change → accept. C's is a 2:1 structural divergence from what the pinned model produces → exactly the case a reviewer should reject and regenerate under pinned conditions. The budget correctly flagged both; provenance made the *cause* legible.

## Methodological caution (honest measurement note)

Raw line-level churn is **not** a clean drift metric here, and we do not rely on it. Because B produced a larger specification (11 FR, 32 tests) and C a leaner one (6 FR, 20 tests), raw diff size is confounded by output verbosity — by changed-line count B actually differs *more* from the baseline than C, which would invert the real conclusion. The size-normalized metric (FR per requirement, benchmarked against Experiment A's same-model band) is the honest measure of structural drift, and it is what Findings 2–3 rest on. This mirrors the calibration lesson of Experiment A: naive count/percentage metrics mislead; semantic coverage plus normalized structure are the right instruments.

## Limitations

- B and C are single runs each. The same-model noise floor is well-characterized (A, n=10); the cross-model divergence is a single, striking instance and should be read as an illustrative demonstration, not an effect-size estimate. Repeating C across several models would strengthen the claim and is natural future work.
- One model pair (`claude-fable-5` vs `claude-sonnet-5`); magnitude will vary by pair.
- The `claude-fable-5` baseline/A/B model self-reported its name three different ways across headers ("Claude Fable 5" / "Fable 5" / "claude-fable-5"), a live illustration of the threat model's "metadata is self-reported" caveat (§3.4). The parenthetical model id was stable and is the reliable field.
