# Experiments

Protocol for the regeneration-drift experiments. All retained runs record the instruction package tag `instructions/v1.0.0`, an instruction-file hash, a model declaration, and the tool's unexposed `default` temperature in the artifact header. The historical files do not independently authenticate that the tagged instruction checkout was used at execution time or which provider-side model revision was served. Current preparation scripts now extract instruction files directly from the recorded tag and collectors verify their hashes before accepting future outputs. No dated model-version string was available for the retained runs, so the historical `model_version` column repeats the reported model field and is not separate version evidence.

## A — Pinned regeneration (×10)

Same declared inputs, same recorded instruction-file hash, same requested and recorded model identifier, and the tool's unexposed default temperature. Regenerate `SPEC` 10 times from `requirements/pet-store-requirements.md` (baseline v1.0 requirements).

- Save each run to `experiments/A-pinned/run-NN/SPEC.md`
- Record per run: FR count, IFR count, FR id set
- Question: what structural variation appears across runs sharing the same recorded conditions, and how does the proposed drift check classify it?
- **Completed.** 10 runs retained: FR/IFR counts 9, 8, 8, 8, 9, 9, 8, 7, 7, 9 (runs 01 to 10; median 8). Run 08 was repeated once: the run saved under `A-pinned/run-08/` is the retained one, the original attempt was not preserved, and the reason for the rerun was not recorded. The series is therefore ten retained outputs, including this one replacement. See `A-pinned/ANALYSIS.md` for the full write-up.

## B: Requirement change with the baseline model identifier

Uncomment R11 and R12 in the requirements file (sold-out labeling; duplicate-order prevention). Regenerate the full pipeline (SPEC → stories → scenarios → tests) while requesting the baseline model identifier and using the recorded instruction files.

- Save to `experiments/B-req-change/`
- Measure blast radius precisely: artifacts changed, FR/IFR/story/scenario/TC counts before → after, files touched
- Expected drift (the 2 new requirements) is separated from unrequested drift
- **Completed**, 1 run. See `ANALYSIS-BC.md`.

## C: Changed model-identifier contrast

Same requirement change as B, but with a different requested and recorded model identifier. The retained headers record the same instruction-file hashes and `default` temperature. Historical execution did not independently authenticate the provider-served model revision or tagged checkout.

- Save to `experiments/C-unpinned/`
- Descriptively compare the retained structures with Experiment B; one run per identifier cannot estimate a causal model effect.
- **Completed**, 1 run, so this is one illustrative comparison, not a general model-effect estimate. See `ANALYSIS-BC.md`.

## Results

Each run is one valid CSV row in `results.csv`. The file distinguishes source-tag coverage from the legacy FR-number-continuity check that produced false alarms for runs A08 and A09. It also keeps the original v1.0 drift-budget verdict separate from the post-hoc v1.1 verdict; v1.1 was calibrated on Experiment A and therefore is not independent validation. Full analyses: [`A-pinned/ANALYSIS.md`](A-pinned/ANALYSIS.md) (Experiment A) and [`ANALYSIS-BC.md`](ANALYSIS-BC.md) (Experiments B and C).

**Known gap:** the collection scripts for these experiments did not call the Layer-2 generation logger, so none of these runs are represented in `.provenance/generation-log/`, only in `results.csv` and the saved output files under each experiment's directory. The main [`README.md`](../README.md) Status section has the full explanation; it is not backfilled.
