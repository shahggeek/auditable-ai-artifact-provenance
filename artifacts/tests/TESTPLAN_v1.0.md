# Pet Store — Test Plan v1.0

## Generation Metadata
- Skill: test-generator v1.0.0
- Model: claude-fable-5 (claude-fable-5)
- Temperature: default (not exposed by harness)
- Generated: 2026-07-23T03:18:59Z
- Skill Git Tag: instructions/v1.0.0
- Prompt Hash: sha256:5aff7a5f87878dc4f1ce9f089c618432be7bf243bd53b8bd158a2d0082c6810c
- Input: artifacts/scenarios/SCENARIOS_v1.0.md

## Test Cases

TC1 [S-A1-1][FR1] (happy): Seed 3 pets of 2 species; open the pet list -> all 3 render with name, species, price, photo, and availability status.
TC2 [S-A1-1][FR1] (happy): Seed a pet with quantity 0 and one with quantity 5; open the list -> statuses differ and match each pet's quantity-derived availability.
TC3 [S-A1-2][FR6] (happy): Seed "Bella" (dog) and "Bello" (cat); search "Bell" and filter species=dog -> only "Bella" is shown.
TC4 [S-A1-3][FR6] (edge): Search "zzz" with no matching pet -> empty-result state shown, no pet cards render.
TC5 [S-A2-1][FR2] (happy): Open detail page for a seeded pet -> full description and quantity available render correctly.
TC6 [S-A2-2][FR2] (edge): Open detail page for a pet with quantity 0 -> quantity shows 0 and availability status reflects unavailability.
TC7 [S-B1-1][FR3] (happy): For a pet with quantity 3, click add-to-cart -> cart count increments and cart contains the pet.
TC8 [S-B1-2][FR3] (validation): For a pet with quantity 0 -> add-to-cart control is disabled/absent; cart remains empty.
TC9 [S-B2-1][FR4] (happy): Place an order for a 1-item cart -> confirmation view renders with a non-empty order ID.
TC10 [S-B2-1][FR4] (happy): Place two separate orders -> the two confirmations carry different order IDs.
TC11 [S-B2-2][FR5] (happy): Cart holds 2 of a pet with quantity 5; place order -> pet quantity becomes 3 on list and detail views.
TC12 [S-B2-3][FR8] (validation): Cart requests 6 of a pet with quantity 5; place order -> rejection message shown, order not created, quantity remains 5.
TC13 [S-B2-4][FR4] (edge): With an empty cart, attempt to place an order -> action rejected with message, no order ID generated.
TC14 [S-C1-1][FR7] (happy): As admin, add a pet with all fields -> pet appears in list with the entered details.
TC15 [S-C1-2][FR7] (happy): As admin, edit an existing pet's quantity from 5 to 8 -> list and detail views show 8.
TC16 [S-C1-3][FR7] (validation): As admin, submit the pet form with name empty -> field-level message shown, catalog unchanged.

## Coverage

S-A1-1 -> TC1, TC2
S-A1-2 -> TC3
S-A1-3 -> TC4
S-A2-1 -> TC5
S-A2-2 -> TC6
S-B1-1 -> TC7
S-B1-2 -> TC8
S-B2-1 -> TC9, TC10
S-B2-2 -> TC11
S-B2-3 -> TC12
S-B2-4 -> TC13
S-C1-1 -> TC14
S-C1-2 -> TC15
S-C1-3 -> TC16
