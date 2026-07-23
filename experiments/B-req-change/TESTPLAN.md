# Pet Store — Test Plan v1.0

## Generation Metadata
- Skill: test-generator v1.0.0
- Model: claude-fable-5
- Temperature: default (not exposed)
- Generated: 2026-07-23T16:17:38Z
- Skill Git Tag: instructions/v1.0.0
- Prompt Hash: sha256:5aff7a5f87878dc4f1ce9f089c618432be7bf243bd53b8bd158a2d0082c6810c
- Input: SCENARIOS.md

## Test Cases

### S-A1-1 — Pet list shows all fields
TC1 [S-A1-1][FR1] (happy): Seed three in-stock pets and open the pet list -> each pet row shows name, species, price, photo, and availability status.
TC2 [S-A1-1][FR1] (happy): Seed one pet with quantity 4 and open the pet list -> its availability status displays as available (not "Sold out").

### S-A1-2 — Search by name matches
TC3 [S-A1-2][FR6] (happy): With a pet named "Bella", search for "BEL" -> "Bella" appears, confirming case-insensitive matching.
TC4 [S-A1-2][FR6] (happy): With pets "Bella" and "Rex", search for "bel" -> only "Bella" is listed; "Rex" is excluded.

### S-A1-3 — Search with no matches
TC5 [S-A1-3][FR6] (edge): Search for "zzz" when no pet name contains it -> the list is empty and an empty-result message is shown, with no error.

### S-A1-4 — Filter by species
TC6 [S-A1-4][FR7] (happy): With dogs and cats seeded, filter by species "Dog" -> only dogs are listed.
TC7 [S-A1-4][FR7] (happy): After filtering by "Dog", clear the species filter -> the full pet list is shown again.

### S-A1-5 — Search and filter combined
TC8 [S-A1-5][FR6][FR7] (edge): With the "Cat" filter active, search for a name that only matches dogs -> the list is empty because both criteria apply together.

### S-A2-1 — Detail page content
TC9 [S-A2-1][FR2] (happy): Open the detail page of a pet with a description and quantity 5 -> the full description and "5 available" are displayed.

### S-A2-2 — Sold-out pet stays listed
TC10 [S-A2-2][FR10] (edge): Set a pet's quantity to 0 and open the pet list -> the pet is still listed and labeled "Sold out".

### S-A2-3 — Sold-out pet detail page
TC11 [S-A2-3][FR2][FR10] (edge): Open the detail page of a quantity-0 pet -> quantity 0 and a "Sold out" label are shown.
TC12 [S-A2-3][FR2][FR10] (edge): On that same detail page, look for an add-to-cart action -> none is offered.

### S-B1-1 — Add available pet to cart
TC13 [S-B1-1][FR3] (happy): From the pet list, add a pet with quantity 3 to the cart -> the cart contains one line for that pet with quantity 1.
TC14 [S-B1-1][FR3] (happy): From a pet's detail page, add it to the cart -> the same cart line result as adding from the list.

### S-B1-2 — Cannot add sold-out pet
TC15 [S-B1-2][FR3] (validation): Attempt to add a sold-out pet -> no add-to-cart control is available for it and the cart remains unchanged.

### S-B1-3 — Adding the same pet twice
TC16 [S-B1-3][FR3] (edge): Add the same pet to the cart twice -> the cart holds a single line for that pet with quantity 2, not two lines.

### S-B2-1 — Order confirmation with order ID
TC17 [S-B2-1][FR4] (happy): Place an order for a one-pet cart -> an on-screen confirmation appears containing an order ID.
TC18 [S-B2-1][FR4] (happy): After the confirmation is shown, open the cart -> the cart is empty.
TC19 [S-B2-1][FR4] (happy): Place two separate orders -> each confirmation shows a different order ID.

### S-B2-2 — Inventory reduced on order
TC20 [S-B2-2][FR5] (happy): With a pet at quantity 5, order 2 of it -> the pet's quantity becomes 3 on its detail page.

### S-B2-3 — Ordering the last unit
TC21 [S-B2-3][FR5] (edge): With a pet at quantity 1, order that unit -> the order succeeds and confirmation is shown.
TC22 [S-B2-3][FR5][FR10] (edge): After that order, open the pet list -> the pet is labeled "Sold out" but still visible.

### S-B2-4 — Duplicate order prevention
TC23 [S-B2-4][FR11] (edge): Submit an order and immediately inspect the buy control -> it is disabled until processing completes and inventory is updated.
TC24 [S-B2-4][FR11] (edge): Replay the same order submission (e.g., double-click or repeated request) before processing completes -> the repeat is rejected and exactly one order with one order ID exists.

### S-B3-1 — Empty required field
TC25 [S-B3-1][FR9] (validation): Submit a form with a required field left empty -> a clear message identifies the empty field and no submission occurs.
TC26 [S-B3-1][FR9] (validation): After the validation failure, inspect the form -> the other entered values are preserved.

### S-B3-2 — Order exceeds available quantity
TC27 [S-B3-2][FR9] (validation): With a pet at quantity 2, attempt to order 5 -> the order is rejected with a message stating only 2 are available, and inventory is unchanged.

### S-B3-3 — Ordering with an empty cart
TC28 [S-B3-3][FR9] (edge): Attempt to place an order with an empty cart -> no order is created and a message explains the cart is empty.

### S-C1-1 — Admin adds a new pet
TC29 [S-C1-1][FR8] (happy): As admin, create a pet with name, species, price, photo, description, and quantity -> the pet appears in the visitor pet list with those details.

### S-C1-2 — Admin edits quantity
TC30 [S-C1-2][FR8] (happy): As admin, change an existing pet's quantity from 2 to 10 -> the pet's detail page shows 10 available.

### S-C1-3 — Admin add-pet validation
TC31 [S-C1-3][FR8] (validation): As admin, save the add-pet form with the name field empty -> the pet is not created and a validation message identifies the missing name.

### S-C1-4 — Admin sets quantity to 0
TC32 [S-C1-4][FR8][FR10] (edge): As admin, edit a pet's quantity to 0 and save -> the pet remains in the visitor list labeled "Sold out".

## Coverage
S-A1-1 -> TC1, TC2
S-A1-2 -> TC3, TC4
S-A1-3 -> TC5
S-A1-4 -> TC6, TC7
S-A1-5 -> TC8
S-A2-1 -> TC9
S-A2-2 -> TC10
S-A2-3 -> TC11, TC12
S-B1-1 -> TC13, TC14
S-B1-2 -> TC15
S-B1-3 -> TC16
S-B2-1 -> TC17, TC18, TC19
S-B2-2 -> TC20
S-B2-3 -> TC21, TC22
S-B2-4 -> TC23, TC24
S-B3-1 -> TC25, TC26
S-B3-2 -> TC27
S-B3-3 -> TC28
S-C1-1 -> TC29
S-C1-2 -> TC30
S-C1-3 -> TC31
S-C1-4 -> TC32
