# Experiments

Protocol for the regeneration-drift experiments. All runs use the pinned instruction package tag `instructions/v1.0.0` unless stated otherwise, and every run records in its artifact header the model as reported by the model, the temperature setting (`default`; not exposed by the tool), and the instruction-file (prompt) hash. No dated model version string was available for these runs, so `model_version` in `results.csv` repeats the reported model name; the reported name varies in spelling across runs, while the parenthetical model ID (e.g., `claude-fable-5`) is stable. See Results below for a known gap on the generation-log side of this (the JSONL log, not the per-artifact header).

## A — Pinned regeneration (×10)

Same inputs, same skill tag, same model + model version, same temperature. Regenerate `SPEC` 10 times from `requirements/pet-store-requirements.md` (baseline v1.0 requirements).

- Save each run to `experiments/A-pinned/run-NN/SPEC.md`
- Record per run: FR count, IFR count, FR id set
- Question: does pinned regeneration stay within the drift budget (source-requirement tag coverage, size-normalized count band)?
- **Completed.** 10 runs retained: FR/IFR counts 9, 8, 8, 8, 9, 9, 8, 7, 7, 9 (runs 01 to 10; median 8). Run 08 was repeated once: the run saved under `A-pinned/run-08/` is the retained one, the original attempt was not preserved, and the reason for the rerun was not recorded. The series is therefore ten retained outputs, including this one replacement. See `A-pinned/ANALYSIS.md` for the full write-up.

## B — Requirement change under pinned conditions

Uncomment R11 and R12 in the requirements file (sold-out labeling; duplicate-order prevention). Regenerate the full pipeline (SPEC → stories → scenarios → tests) under pinned conditions.

- Save to `experiments/B-req-change/`
- Measure blast radius precisely: artifacts changed, FR/IFR/story/scenario/TC counts before → after, files touched
- Expected drift (the 2 new requirements) is separated from unrequested drift
- **Completed**, 1 run. See `ANALYSIS-BC.md`.

## C — Unpinned contrast

Same requirement change as B, but unpinned: a different model or model version, no skill tag checkout (current HEAD), temperature unrecorded.

- Save to `experiments/C-unpinned/`
- Compare drift vs. Experiment B: does removing provenance-guided pinning increase drift?
- **Completed**, 1 run, so this is one illustrative comparison, not a general model-effect estimate. See `ANALYSIS-BC.md`.

## Results

Each run is one row in `results.csv`. Full analyses: [`A-pinned/ANALYSIS.md`](A-pinned/ANALYSIS.md) (Experiment A) and [`ANALYSIS-BC.md`](ANALYSIS-BC.md) (Experiments B and C).

**Known gap:** the collection scripts for these experiments did not call the Layer-2 generation logger, so none of these runs are represented in `.provenance/generation-log/`, only in `results.csv` and the saved output files under each experiment's directory. The main [`README.md`](../README.md) Status section has the full explanation; it is not backfilled.
