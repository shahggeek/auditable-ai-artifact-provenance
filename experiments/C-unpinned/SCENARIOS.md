## Generation Metadata
- Skill: scenario-generator v1.0.0
- Model: Claude Sonnet 5 (claude-sonnet-5)
- Temperature: default (not exposed)
- Generated: 2026-07-23T16:20:18Z
- Skill Git Tag: instructions/v1.0.0
- Prompt Hash: sha256:139aa15dd407aff12dd7b9413f2d7d720e9105fb0eacc6c02edb0781e544e4a6
- Input: STORIES.md

Scenario S-A1-1 [Story A1][FR1]: Given pets exist in the store, when a visitor views the pet list, then each pet's name, species, price, photo, and availability status are shown. (happy)
Scenario S-A1-2 [Story A1][FR1]: Given pets exist, when a visitor searches by a name substring, then only matching pets are shown. (happy)
Scenario S-A1-3 [Story A1][FR1]: Given pets of multiple species exist, when a visitor filters by species, then only pets of that species are shown. (happy)
Scenario S-A1-4 [Story A1][FR1]: Given a search term matches no pet names, when a visitor searches, then an empty result set is shown without error. (edge)

Scenario S-A2-1 [Story A2][FR2]: Given an available pet, when a visitor opens its detail page, then the full description and quantity available are shown. (happy)
Scenario S-A2-2 [Story A2][FR2]: Given a sold-out pet (quantity 0), when a visitor opens its detail page, then the page still loads and shows quantity 0. (edge)
Scenario S-A2-3 [Story A2][FR2]: Given an invalid or non-existent pet ID, when a visitor opens the detail page, then a clear not-found message is shown. (validation)

Scenario S-A3-1 [Story A3][FR3]: Given an available pet, when a visitor adds it to the cart and places an order, then an on-screen confirmation with an order ID is shown. (happy)
Scenario S-A3-2 [Story A3][FR3]: Given a sold-out pet (quantity 0), when a visitor attempts to add it to the cart, then the add-to-cart action is prevented. (validation)
Scenario S-A3-3 [Story A3][FR3]: Given multiple pets in the cart, when a visitor places the order, then the confirmation lists all ordered items under one order ID. (happy)

Scenario S-A4-1 [Story A4][FR4]: Given a pet with quantity 3, when an order for 1 unit is placed, then its quantity becomes 2 and it remains listed as available. (happy)
Scenario S-A4-2 [Story A4][FR4]: Given a pet with quantity 1, when an order for 1 unit is placed, then its quantity becomes 0 and it is labeled "Sold out" instead of being hidden. (edge)
Scenario S-A4-3 [Story A4][FR4]: Given a pet already labeled "Sold out", when a visitor views the pet list, then the pet remains visible with the "Sold out" label. (happy)

Scenario S-A5-1 [Story A5][FR6]: Given a required field is left empty during checkout, when the visitor submits, then a clear validation message is shown and the order is not placed. (validation)
Scenario S-A5-2 [Story A5][FR6]: Given a visitor orders more units than are available, when they submit, then a clear validation message is shown and the order is not placed. (validation)
Scenario S-A5-3 [Story A5][FR6]: Given a visitor has just clicked buy, when the order is still processing, then the buy action is disabled until inventory is updated. (edge)
Scenario S-A5-4 [Story A5][FR6]: Given the buy action is disabled during processing, when a visitor clicks it again quickly, then no duplicate order is created. (edge)

Scenario S-B1-1 [Story B1][FR5]: Given an admin is adding a new pet, when they submit valid details, then the new pet appears in the pet list. (happy)
Scenario S-B1-2 [Story B1][FR5]: Given an admin edits an existing pet's quantity, when they save the change, then the updated quantity is reflected in the list and detail page. (happy)
Scenario S-B1-3 [Story B1][FR5]: Given an admin submits a new pet with a missing required field, when they save, then a clear validation message is shown and the pet is not created. (validation)

## Coverage
A1 -> S-A1-1, S-A1-2, S-A1-3, S-A1-4
A2 -> S-A2-1, S-A2-2, S-A2-3
A3 -> S-A3-1, S-A3-2, S-A3-3
A4 -> S-A4-1, S-A4-2, S-A4-3
A5 -> S-A5-1, S-A5-2, S-A5-3, S-A5-4
B1 -> S-B1-1, S-B1-2, S-B1-3
