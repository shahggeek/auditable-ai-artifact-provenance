# ai-provenance-kit

A proof-of-concept implementation of a **provenance and traceability framework for AI-generated code and development artifacts**, demonstrated on a pet-store application built with Spec-Driven Development (SDD).

When AI assistants generate SDLC artifacts (specs, stories, scenarios, tests), regulated teams need to answer: *what generated this artifact, under which instructions, which requirement does it satisfy, who approved it — and can you prove it?* This kit implements the four provenance layers, the FR→IFR traceability chain, and machine-checkable **drift budgets** that make those questions answerable for the artifacts it does log (see Status below).

## The four layers

| Layer | Mechanism | In this repo |
|---|---|---|
| 1 | **Artifact metadata** — every generated file carries a generation-metadata header | `artifacts/*` headers |
| 2 | **Generation log** — machine-readable JSONL record of generation events | `.claude/generation-log/`, `tools/log-generation.sh` |
| 3 | **Versioned instruction packages** — skills git-tagged as a complete set | `skills/`, tags `instructions/vX.Y.Z` |
| 4 | **Prompt (instruction-file) hashing**: skill content hashed; hash stored in artifacts and log as `prompt_hash` | `tools/prompt-hash.sh` |

Layer 4 hashes the versioned instruction file itself, not the full assembled prompt sent to the model (user input, retrieved context, open files are not covered). Records are not signed or hash-chained; they carry ordinary Git/SCM protection, not cryptographic tamper evidence.

## Traceability chain

`requirement → FR → IFR → story → scenario → test`

The **interpreted functional requirement (IFR)** makes the AI's reading of each requirement an explicit, reviewable artifact. `tools/trace-report.sh` walks the chain (forward coverage / backward impact) by checking `[FRn]`/`[source: Rn]` tag presence, not the semantic correctness of what a stage produced. This pipeline stops at test-case text; it does not generate or execute application code.

## Drift budget

Regenerating an artifact from the same inputs is checked against a drift budget: source-requirement tag coverage (every `[source: Rn]` tag still traced) as an absolute floor, plus a size-normalized count band. This replaced an earlier, naive ±10% IFR-count version that false-flagged legitimate FR regrouping at small counts (see Experiment A below); the current version was calibrated on those same ten runs and is offered for validation, not as a settled threshold. `.github/workflows/drift-gate.yml` runs it as a CI gate on spec changes.

## Pipeline

1. `requirements/pet-store-requirements.md` — plain-English business requirements
2. `skills/spec-generator` → `artifacts/SPEC_v1.0.md` (FRs + IFRs)
3. `skills/story-generator` → epics/stories tagged `[FRn][IFRn]`
4. `skills/scenario-generator` → scenarios per story
5. `skills/test-generator` → test cases per scenario

Run each skill with your AI assistant of choice (the mechanisms are tool-agnostic), then log the event:

```bash
tools/log-generation.sh spec-generator 1.0.0 <model> <model_version> <temperature> artifacts/SPEC_v1.0.md "requirements/pet-store-requirements.md"
```

## Audit queries

```bash
tools/generation-report.sh by-file artifacts/SPEC_v1.0.md   # what generated this file?
tools/generation-report.sh by-skill spec-generator          # everything a skill produced
tools/generation-report.sh by-month 2026-07                 # all events in a month
tools/generation-report.sh stats                            # activity summary
tools/trace-report.sh coverage                              # is every FR covered downstream?
tools/drift-check.sh artifacts/SPEC_v1.0.md artifacts/SPEC_v1.1.md
```

Queries only return records for artifacts that reached the generation log, see Status.

## Experiments

See [`experiments/README.md`](experiments/README.md) and the write-ups in [`experiments/A-pinned/ANALYSIS.md`](experiments/A-pinned/ANALYSIS.md) and [`experiments/ANALYSIS-BC.md`](experiments/ANALYSIS-BC.md): **A** — pinned regeneration ×10 (same-model structural variation); **B** — requirement change under pinned conditions (blast radius); **C** — unpinned contrast. Results in `experiments/results.csv`.

## AI-BOM schema

[`schemas/ai-bom-schema.json`](schemas/ai-bom-schema.json) is an artifact-level provenance schema: an AI Bill of Materials keyed to a generated artifact rather than to a model, complementary to model-centric ML-BOMs.

## Status

Baseline generation and Experiments A, B, and C are complete; results and analyses are in `experiments/`.

**Known gap:** the collection scripts used for Experiments A, B, and C never called the Layer-2 logger, so `.claude/generation-log/` currently holds only the 4 baseline-pipeline events, not the later experiment runs (those are recorded in `experiments/results.csv` and the saved output files instead, just not in the JSONL log). This was found by querying the log itself rather than assumed, is reported rather than backfilled, since reconstructing provenance after the fact isn't honest, and the harness has been fixed going forward (commit `a3515f0`).

## License

MIT — see [LICENSE](LICENSE).
