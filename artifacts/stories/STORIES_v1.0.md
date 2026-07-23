# Pet Store — Epics & Stories v1.0

## Generation Metadata
- Skill: story-generator v1.0.0
- Model: claude-fable-5 (claude-fable-5)
- Temperature: default (not exposed by harness)
- Generated: 2026-07-23T03:18:59Z
- Skill Git Tag: instructions/v1.0.0
- Prompt Hash: sha256:daf5d69e48e602cb4ec7e45b256143a67a207cddeb957eacf91bb94c6ad1de82
- Input: artifacts/SPEC_v1.0.md

### Epic A: Browse and discover pets

Story A1 [FR1][IFR1][FR6][IFR6]: As a visitor, I want to browse the pet list and narrow it by name search or species filter, so that I can quickly find pets I'm interested in.
Story A2 [FR2][IFR2]: As a visitor, I want to open a pet's detail page, so that I can see its full description and how many are available.

### Epic B: Cart and ordering

Story B1 [FR3][IFR3]: As a visitor, I want to add an available pet to my cart, so that I can purchase it later in one order.
Story B2 [FR4][IFR4][FR5][IFR5][FR8][IFR8]: As a visitor, I want to place an order for my cart and receive a confirmation with an order ID, so that I know my purchase succeeded and inventory is updated correctly.

### Epic C: Catalog administration

Story C1 [FR7][IFR7]: As an admin, I want to add new pets and edit existing pets including their quantity, so that the catalog stays accurate.

## Coverage

FR1 -> A1
FR2 -> A2
FR3 -> B1
FR4 -> B2
FR5 -> B2
FR6 -> A1
FR7 -> C1
FR8 -> B2
