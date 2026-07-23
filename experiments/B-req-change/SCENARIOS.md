# Pet Store — Business Scenarios v1.0

## Generation Metadata
- Skill: scenario-generator v1.0.0
- Model: claude-fable-5
- Temperature: default (not exposed)
- Generated: 2026-07-23T16:17:10Z
- Skill Git Tag: instructions/v1.0.0
- Prompt Hash: sha256:139aa15dd407aff12dd7b9413f2d7d720e9105fb0eacc6c02edb0781e544e4a6
- Input: STORIES.md

## Scenarios

### Story A1 — Browse, search, and filter the pet list
Scenario S-A1-1 [Story A1][FR1] (happy): Given the store has pets in stock, when a visitor opens the pet list, then every pet is shown with its name, species, price, photo, and availability status.
Scenario S-A1-2 [Story A1][FR6] (happy): Given a pet named "Bella" exists, when the visitor searches for "bel", then the list shows only pets whose names contain "bel" matched case-insensitively, including "Bella".
Scenario S-A1-3 [Story A1][FR6] (edge): Given no pet name contains "zzz", when the visitor searches for "zzz", then the list shows no pets and an empty-result message instead of an error.
Scenario S-A1-4 [Story A1][FR7] (happy): Given pets of species "Dog" and "Cat" exist, when the visitor filters by species "Dog", then only dogs are shown.
Scenario S-A1-5 [Story A1][FR6][FR7] (edge): Given a species filter for "Cat" is active, when the visitor also searches a name that only matches dogs, then the list is empty because search and filter apply together.

### Story A2 — Pet detail page and sold-out visibility
Scenario S-A2-1 [Story A2][FR2] (happy): Given a pet with a description and quantity 5, when the visitor opens its detail page, then the full description and "5 available" are shown.
Scenario S-A2-2 [Story A2][FR10] (edge): Given a pet's quantity is 0, when the visitor views the pet list, then the pet is still listed and labeled "Sold out" instead of showing an available status.
Scenario S-A2-3 [Story A2][FR2][FR10] (edge): Given a pet's quantity is 0, when the visitor opens its detail page, then the page shows quantity 0 with a "Sold out" label and offers no add-to-cart action.

### Story B1 — Add to cart
Scenario S-B1-1 [Story B1][FR3] (happy): Given a pet has quantity 3, when the visitor adds it to the cart, then the cart contains one line for that pet with quantity 1.
Scenario S-B1-2 [Story B1][FR3] (validation): Given a pet is sold out, when the visitor attempts to add it to the cart, then no add-to-cart control is available and the cart is unchanged.
Scenario S-B1-3 [Story B1][FR3] (edge): Given a pet is already in the cart, when the visitor adds the same pet again, then the existing cart line's quantity increments rather than creating a duplicate line.

### Story B2 — Place order, confirmation, inventory, duplicate prevention
Scenario S-B2-1 [Story B2][FR4] (happy): Given a cart with one pet, when the visitor places the order, then an on-screen confirmation is shown containing a unique order ID and the cart is emptied.
Scenario S-B2-2 [Story B2][FR5] (happy): Given a pet has quantity 5 and the cart orders 2 of it, when the order is placed, then the pet's inventory quantity becomes 3.
Scenario S-B2-3 [Story B2][FR5][FR10] (edge): Given a pet has quantity 1, when the visitor orders that last unit, then the order succeeds and the pet immediately appears in the list labeled "Sold out".
Scenario S-B2-4 [Story B2][FR11] (edge): Given the visitor submits an order, when they click the buy action again before processing completes, then the control is disabled, the repeat submission is rejected server-side, and exactly one order with one order ID exists.

### Story B3 — Validation messages
Scenario S-B3-1 [Story B3][FR9] (validation): Given a form with a required field left empty, when the visitor submits it, then a clear field-specific message identifies the empty field and other entered values are preserved.
Scenario S-B3-2 [Story B3][FR9] (validation): Given a pet has quantity 2, when the visitor tries to order 5 of it, then the order is rejected with a message stating the requested quantity exceeds the 2 available.
Scenario S-B3-3 [Story B3][FR9] (edge): Given the cart is empty, when the visitor attempts to place an order, then no order is created and a message explains the cart is empty.

### Story C1 — Admin add and edit pets
Scenario S-C1-1 [Story C1][FR8] (happy): Given an admin fills in name, species, price, photo, description, and quantity, when they save the new pet, then the pet appears in the visitor pet list with those details.
Scenario S-C1-2 [Story C1][FR8] (happy): Given an existing pet with quantity 2, when the admin edits its quantity to 10, then the detail page shows 10 available.
Scenario S-C1-3 [Story C1][FR8] (validation): Given the admin leaves the name field empty on the add-pet form, when they save, then the pet is not created and a validation message identifies the missing name.
Scenario S-C1-4 [Story C1][FR8][FR10] (edge): Given the admin edits a pet's quantity to 0, when the change is saved, then the pet remains in the visitor list labeled "Sold out".

## Coverage
A1 -> S-A1-1, S-A1-2, S-A1-3, S-A1-4, S-A1-5
A2 -> S-A2-1, S-A2-2, S-A2-3
B1 -> S-B1-1, S-B1-2, S-B1-3
B2 -> S-B2-1, S-B2-2, S-B2-3, S-B2-4
B3 -> S-B3-1, S-B3-2, S-B3-3
C1 -> S-C1-1, S-C1-2, S-C1-3, S-C1-4
