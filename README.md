# Auditable AI Artifact Provenance

A research prototype and supplementary artifact for studying **provenance, traceability, and controlled regeneration of AI-generated software-development artifacts**. The proof of concept uses a synthetic pet-store example and a specification-driven development pipeline.

When AI assistants generate SDLC artifacts (specifications, stories, scenarios, and tests), reviewers may need to answer: *what generated this artifact, under which recorded instructions, which requirement does it address, and who reviewed it?* This prototype implements four provenance mechanisms, an FR-to-IFR traceability chain, and experimental drift checks. It demonstrates what can be queried from recorded evidence; it does not prove that the records are complete, truthful, or tamper-resistant.

## Scope and evidence boundaries

- The repository contains synthetic requirements, generated artifacts, retained experiment outputs, and analysis scripts.
- It contains no proprietary artifacts, participant data, or confidential field data.
- Model names in the retained files are experimental metadata and are preserved as recorded.
- The small experiments motivate a larger evaluation; they do not establish general model effects, regulatory compliance, or production readiness.
- This repository identifies its maintainer. Keep it private during double-anonymous review and do not link it from the manuscript; use a separately anonymized submission snapshot.

## The four layers

| Layer | Mechanism | In this repo |
|---|---|---|
| 1 | **Artifact metadata** — every generated file carries a generation-metadata header | `artifacts/*` headers |
| 2 | **Generation log** — machine-readable JSONL record of generation events | `.provenance/generation-log/`, `tools/log-generation.sh` |
| 3 | **Versioned instruction packages** — skills git-tagged as a complete set | `skills/`, tags `instructions/vX.Y.Z` |
| 4 | **Prompt (instruction-file) hashing**: skill content hashed; hash stored in artifacts and log as `prompt_hash` | `tools/prompt-hash.sh` |

Layer 4 hashes the versioned instruction file itself, not the full assembled prompt sent to the model (user input, retrieved context, open files are not covered). Records are not signed or hash-chained; they carry ordinary Git/SCM protection, not cryptographic tamper evidence.

The prototype implements only part of the candidate record. Artifact headers contain the declared model, instruction version, timestamp, input path, and instruction-file hash. The JSONL event log additionally records the output hash and repository context. Human-review status is proposed but is not recorded in the retained prototype artifacts.

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

## AI-BOM schema and example

[`schemas/ai-bom-schema.json`](schemas/ai-bom-schema.json) is a formal JSON Schema for a proposed artifact-level AI Bill of Materials. [`schemas/ai-bom-example.json`](schemas/ai-bom-example.json) is an illustrative record with placeholder values; it is not an experimental observation.

## Status

Baseline generation and Experiments A, B, and C are complete; results and analyses are in `experiments/`.

**Known gap:** the collection scripts used for Experiments A, B, and C never called the Layer-2 logger, so `.provenance/generation-log/` currently holds only the four baseline-pipeline events, not the later experiment runs. Those runs are recorded in `experiments/results.csv` and the retained output files. The missing events are reported rather than reconstructed after the fact; the collection harness now invokes the logger for future runs.

## Verify the retained artifact

The scripts require Bash, Git, and common POSIX command-line utilities. From the repository root:

```bash
tools/generation-report.sh stats
tools/generation-report.sh by-file artifacts/SPEC_v1.0.md
tools/trace-report.sh coverage
tools/drift-check.sh artifacts/SPEC_v1.0.md experiments/A-pinned/run-02/SPEC.md
```

Expected high-level results are four logged baseline events, full identifier presence across the retained baseline chain, and a passing drift check for the selected pinned-regeneration example. See [ARTIFACT.md](ARTIFACT.md) for the evidence inventory and limitations.

## Citation

Citation metadata is provided in [CITATION.cff](CITATION.cff). The associated research-preview citation will be added after publication.

## License

MIT — see [LICENSE](LICENSE).
