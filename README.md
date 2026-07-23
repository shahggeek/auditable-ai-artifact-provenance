# ai-provenance-kit

A reference implementation of a **provenance and traceability framework for AI-generated code**, demonstrated on a pet-store application built with Spec-Driven Development (SDD). Companion artifact to a paper currently under submission.

When AI assistants generate SDLC artifacts (specs, stories, scenarios, tests, code), regulated teams need to answer: *what generated this artifact, under which instructions, which requirement does it satisfy, who approved it — and can you prove it?* This kit implements the four provenance layers, the FR→IFR traceability chain, and machine-checkable **drift budgets** that make those questions answerable.

## The four layers

| Layer | Mechanism | In this repo |
|---|---|---|
| 1 | **Artifact metadata** — every generated file carries a generation-metadata header | `artifacts/*` headers |
| 2 | **Generation log** — machine-readable JSONL record of every generation event | `.claude/generation-log/`, `tools/log-generation.sh` |
| 3 | **Versioned instruction packages** — skills git-tagged as a complete set | `skills/`, tags `instructions/vX.Y.Z` |
| 4 | **Prompt hashing** — skill content hashed; hash stored in artifacts and log | `tools/prompt-hash.sh` |

## Traceability chain

`requirement → FR → IFR → story → scenario → test → code`

The **interpreted functional requirement (IFR)** makes the AI's reading of each requirement an explicit, reviewable artifact. `tools/trace-report.sh` walks the chain (forward coverage / backward impact).

## Drift budget

Regenerating an artifact from the same inputs must stay within budget — default: **±10% IFR-count variation and zero loss of FR coverage**. `tools/drift-check.sh` enforces it; `.github/workflows/drift-gate.yml` runs it as a CI gate on spec changes.

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

## Experiments

See [`experiments/README.md`](experiments/README.md): **A** — pinned regeneration ×10 (drift under identical conditions); **B** — requirement change under pinned conditions (blast radius); **C** — unpinned contrast. Results land in `experiments/results.csv`.

## Status

Scaffold complete; baseline generation and experiments in progress.

## License

MIT — see [LICENSE](LICENSE).
