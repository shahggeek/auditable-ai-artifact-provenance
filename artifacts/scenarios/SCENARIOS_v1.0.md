# Pet Store — Business Scenarios v1.0

## Generation Metadata
- Skill: scenario-generator v1.0.0
- Model: claude-fable-5 (claude-fable-5)
- Temperature: default (not exposed by harness)
- Generated: 2026-07-23T03:18:59Z
- Skill Git Tag: instructions/v1.0.0
- Prompt Hash: sha256:139aa15dd407aff12dd7b9413f2d7d720e9105fb0eacc6c02edb0781e544e4a6
- Input: artifacts/stories/STORIES_v1.0.md

## Scenarios

Scenario S-A1-1 [Story A1][FR1] (happy): Given pets exist in the catalog, when a visitor opens the pet list, then each pet shows name, species, price, photo, and availability status.
Scenario S-A1-2 [Story A1][FR6] (happy): Given pets of several species exist, when the visitor searches a name substring and applies a species filter together, then only pets matching both are shown.
Scenario S-A1-3 [Story A1][FR6] (edge): Given no pet matches the search text, when the visitor searches, then an empty-result state is shown instead of the list.
Scenario S-A2-1 [Story A2][FR2] (happy): Given a pet exists, when the visitor opens its detail page, then the full description and current quantity available are shown.
Scenario S-A2-2 [Story A2][FR2] (edge): Given a pet's quantity is 0, when the visitor opens its detail page, then quantity available is shown as 0 and its availability status reflects that.
Scenario S-B1-1 [Story B1][FR3] (happy): Given a pet with quantity greater than 0, when the visitor adds it to the cart, then the cart contains that pet.
Scenario S-B1-2 [Story B1][FR3] (validation): Given a pet with quantity 0, when the visitor attempts to add it to the cart, then the action is unavailable and the cart is unchanged.
Scenario S-B2-1 [Story B2][FR4] (happy): Given a cart with items, when the visitor places the order, then a confirmation with a generated order ID is shown.
Scenario S-B2-2 [Story B2][FR5] (happy): Given a cart with 2 of a pet whose quantity is 5, when the order is placed, then that pet's quantity becomes 3.
Scenario S-B2-3 [Story B2][FR8] (validation): Given a cart requesting more than the available quantity, when the visitor places the order, then the order is rejected with a clear message and inventory is unchanged.
Scenario S-B2-4 [Story B2][FR4] (edge): Given an empty cart, when the visitor attempts to place an order, then the action is rejected with a message and no order ID is created.
Scenario S-C1-1 [Story C1][FR7] (happy): Given an admin user, when they add a new pet with all details, then the pet appears in the list with those details.
Scenario S-C1-2 [Story C1][FR7] (happy): Given an existing pet, when the admin edits its quantity, then the list and detail views reflect the new quantity.
Scenario S-C1-3 [Story C1][FR7] (validation): Given an admin submits a pet form with a required field empty, when they save, then a field-level validation message is shown and nothing is saved.

## Coverage

A1 -> S-A1-1, S-A1-2, S-A1-3
A2 -> S-A2-1, S-A2-2
B1 -> S-B1-1, S-B1-2
B2 -> S-B2-1, S-B2-2, S-B2-3, S-B2-4
C1 -> S-C1-1, S-C1-2, S-C1-3
