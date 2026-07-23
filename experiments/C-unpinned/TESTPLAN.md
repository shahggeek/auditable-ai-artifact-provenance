## Generation Metadata
- Skill: test-generator v1.0.0
- Model: Claude Sonnet 5 (claude-sonnet-5)
- Temperature: default (not exposed)
- Generated: 2026-07-23T16:20:18Z
- Skill Git Tag: instructions/v1.0.0
- Prompt Hash: sha256:5aff7a5f87878dc4f1ce9f089c618432be7bf243bd53b8bd158a2d0082c6810c
- Input: SCENARIOS.md

TC1 [S-A1-1][FR1] (happy): Load the pet list page with seeded pets -> each pet row displays name, species, price, photo, and availability status.
TC2 [S-A1-2][FR1] (happy): Enter a name substring in the search box -> only pets whose name contains the substring are displayed.
TC3 [S-A1-3][FR1] (happy): Select a species filter -> only pets of the selected species are displayed.
TC4 [S-A1-4][FR1] (edge): Search for a term matching no pet -> the list renders empty with no error thrown.
TC5 [S-A2-1][FR2] (happy): Open the detail page of an available pet -> full description and quantity available are displayed.
TC6 [S-A2-2][FR2] (edge): Open the detail page of a pet with quantity 0 -> page loads and shows quantity 0.
TC7 [S-A2-3][FR2] (validation): Open the detail page with an invalid pet ID -> a clear not-found message is displayed.
TC8 [S-A3-1][FR3] (happy): Add an available pet to the cart and submit the order -> an on-screen confirmation with an order ID is shown.
TC9 [S-A3-2][FR3] (validation): Attempt to add a sold-out (quantity 0) pet to the cart -> the add-to-cart action is prevented.
TC10 [S-A3-3][FR3] (happy): Add multiple pets to the cart and place the order -> the confirmation lists all ordered items under one order ID.
TC11 [S-A4-1][FR4] (happy): Place an order for 1 unit of a pet with quantity 3 -> quantity updates to 2 and the pet remains listed as available.
TC12 [S-A4-2][FR4] (edge): Place an order for 1 unit of a pet with quantity 1 -> quantity updates to 0 and the pet is labeled "Sold out".
TC13 [S-A4-3][FR4] (happy): View the pet list containing a "Sold out" pet -> the pet remains visible with the "Sold out" label.
TC14 [S-A5-1][FR6] (validation): Submit checkout with a required field left empty -> a clear validation message is shown and no order is created.
TC15 [S-A5-2][FR6] (validation): Submit an order quantity greater than available stock -> a clear validation message is shown and no order is created.
TC16 [S-A5-3][FR6] (edge): Click buy and inspect UI state while the order is processing -> the buy action is disabled until inventory is updated.
TC17 [S-A5-4][FR6] (edge): Rapidly click buy twice during processing -> only one order is created, with no duplicate.
TC18 [S-B1-1][FR5] (happy): As admin, submit valid details for a new pet -> the new pet appears in the pet list.
TC19 [S-B1-2][FR5] (happy): As admin, edit an existing pet's quantity and save -> the updated quantity is reflected in the list and detail page.
TC20 [S-B1-3][FR5] (validation): As admin, submit a new pet with a missing required field -> a clear validation message is shown and the pet is not created.

## Coverage
S-A1-1 -> TC1
S-A1-2 -> TC2
S-A1-3 -> TC3
S-A1-4 -> TC4
S-A2-1 -> TC5
S-A2-2 -> TC6
S-A2-3 -> TC7
S-A3-1 -> TC8
S-A3-2 -> TC9
S-A3-3 -> TC10
S-A4-1 -> TC11
S-A4-2 -> TC12
S-A4-3 -> TC13
S-A5-1 -> TC14
S-A5-2 -> TC15
S-A5-3 -> TC16
S-A5-4 -> TC17
S-B1-1 -> TC18
S-B1-2 -> TC19
S-B1-3 -> TC20
