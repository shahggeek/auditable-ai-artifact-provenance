# Artifact guide

## Purpose

This repository is a bounded proof of concept for recording and querying provenance for AI-generated development artifacts. It accompanies a research preview on auditable regeneration, requirements traceability, and drift-aware review.

## Included evidence

| Location | Contents | Evidentiary use |
|---|---|---|
| `requirements/` | Synthetic pet-store requirements | Public experiment input |
| `skills/` | Versioned generation instructions | Reconstructs the recorded instruction files |
| `artifacts/` | Baseline specification, stories, scenarios, and test plan | Demonstrates embedded metadata and trace identifiers |
| `.provenance/generation-log/` | Four baseline JSONL events | Demonstrates event queries for logged artifacts |
| `experiments/A-pinned/` | Ten retained specification regenerations | Describes variation under the same recorded inputs, instruction hash, and model identifier |
| `experiments/B-req-change/` | One requirement-change pipeline requesting the baseline model identifier | Illustrative descriptive comparison |
| `experiments/C-unpinned/` | One pipeline requesting a different model identifier | Illustrative descriptive contrast |
| `experiments/results.csv` | Derived experiment counts | Input to the reported descriptive summaries |
| `tools/` | Logging, query, trace, collection, and drift scripts | Reproduces mechanical checks |
| `schemas/` | AI-BOM JSON Schema and illustrative record | Defines and demonstrates the proposed record shape |

## Quick verification

Run these commands from the repository root:

```bash
tools/generation-report.sh stats
tools/generation-report.sh by-file artifacts/SPEC_v1.0.md
tools/trace-report.sh coverage
tools/drift-check.sh artifacts/SPEC_v1.0.md experiments/A-pinned/run-02/SPEC.md
tools/test-tools.sh
```

The scripts require Bash, Git, Python 3, `sed`, `grep`, `awk`, `sort`, and a SHA-256 implementation available through `shasum` or the platform-equivalent commands used by the scripts.

## Claims this artifact can support

- Four retained baseline artifacts have queryable generation-event records.
- Requirement identifiers are mechanically present across the retained downstream baseline artifacts.
- Retained regeneration outputs vary structurally while reporting the same requested model identifier and instruction-file hash.
- The logging gap demonstrates that developer-controlled provenance is incomplete when capture is not invoked.
- The anonymous snapshot can exercise event queries, but identity-bearing repository and commit fields are redacted and Git history is absent, so the recorded commit cannot be resolved during review.

## Claims this artifact cannot support

- It does not establish semantic correctness merely from identifier presence.
- It does not prove that self-reported model metadata is truthful.
- It does not authenticate the provider-served model weights or revision, or recover a numeric temperature hidden by the tool.
- It does not provide cryptographic attestation, signed events, or tamper-evident storage.
- It does not estimate a general causal effect of model choice; the cross-model comparison has one run per condition.
- It does not demonstrate regulatory compliance or validate the framework in production.
- It contains no participant or confidential field data.

## Known provenance gap

The four baseline pipeline events were logged, but the retained A/B/C experiment outputs were not added to the JSONL event log by the original collection scripts. The omission is preserved and documented. The events must not be backfilled because their contemporaneous metadata cannot now be reconstructed reliably.

## Double-anonymous submission

This repository identifies its maintainer through its account and license. Keep it private during double-anonymous review and do not link it from the manuscript. Use a separate snapshot with author-identifying metadata removed through the venue's supplementary-material mechanism.
