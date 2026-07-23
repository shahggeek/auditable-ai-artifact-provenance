# Experiments

Protocol for the regeneration-drift experiments. All runs use the pinned instruction package tag `instructions/v1.0.0` unless stated otherwise, and every run records model, full dated model version, and temperature in the artifact header and the generation log.

## A — Pinned regeneration (×10)

Same inputs, same skill tag, same model + model version, same temperature. Regenerate `SPEC` 10 times from `requirements/pet-store-requirements.md` (baseline v1.0 requirements).

- Save each run to `experiments/A-pinned/run-NN/SPEC.md`
- Record per run: FR count, IFR count, FR id set
- Question: does pinned regeneration stay within the drift budget (±10% IFR count, zero FR loss)?

## B — Requirement change under pinned conditions

Uncomment R11 and R12 in the requirements file (sold-out labeling; duplicate-order prevention — mirroring the workshop's mid-session change). Regenerate the full pipeline (SPEC → stories → scenarios → tests) under pinned conditions.

- Save to `experiments/B-req-change/`
- Measure blast radius precisely: artifacts changed, FR/IFR/story/scenario/TC counts before → after, files touched
- Expected drift (the 2 new requirements) is separated from unrequested drift

## C — Unpinned contrast

Same requirement change as B, but unpinned: a different model or model version, no skill tag checkout (current HEAD), temperature unrecorded.

- Save to `experiments/C-unpinned/`
- Compare drift vs. Experiment B: does removing provenance-guided pinning increase drift?

## Results

Append one row per run to `results.csv`. Analysis summary goes here when runs complete.
