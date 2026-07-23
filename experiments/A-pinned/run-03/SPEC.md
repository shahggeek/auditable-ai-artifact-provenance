# Pet Store — Specification

## Generation Metadata
- Skill: spec-generator v1.0.0
- Model: claude-fable-5 (claude-fable-5)
- Temperature: default (not exposed)
- Generated: 2026-07-23T15:42:18Z
- Skill Git Tag: instructions/v1.0.0
- Prompt Hash: sha256:bc1930c75624d6cf55cb3375f2adf66bd7ae5e8337220582e376e222349d07ae
- Input: requirements/pet-store-requirements.md

## Functional Requirements
FR1: Visitors can browse a list of pets showing each pet's name, species, price, photo, and availability status. [source: R1]
FR2: Visitors can open a pet's detail page showing its full description and quantity available. [source: R2]
FR3: Visitors can search pets by name and filter the pet list by species. [source: R6,R7]
FR4: Visitors can add an available pet to a shopping cart. [source: R3]
FR5: Visitors can place an order for the items in their cart and receive an on-screen confirmation that includes an assigned order ID. [source: R4,R9]
FR6: When an order is placed, the inventory quantity of each ordered pet is reduced by the quantity ordered. [source: R5]
FR7: An admin user can add a new pet and edit an existing pet's details, including its quantity. [source: R8]
FR8: Invalid inputs, such as empty required fields or ordering more than the available quantity, produce clear validation messages. [source: R10]

## Interpreted Functional Requirements
IFR1 (FR1): The system provides a pet list view rendering, for each Pet entity, its name, species, price, photo, and an availability status derived from its quantity (available when quantity > 0, otherwise unavailable).
IFR2 (FR2): Selecting a pet from the list navigates to a detail view for that Pet showing its full description text and its current quantity available.
IFR3 (FR3): The pet list view accepts a name search term matched case-insensitively as a substring against pet names, and a species filter selecting a single species; search and filter may be applied together and both operate on the same list view.
IFR4 (FR4): A visitor can add a Pet with quantity > 0 to a session-scoped Cart; the cart holds line items of pet and requested quantity, and adding the same pet again increments that line item's quantity.
IFR5 (FR5): Submitting the cart creates an Order entity from the cart's line items, assigns it a unique order ID, displays an on-screen confirmation containing that order ID, and clears the cart.
IFR6 (FR6): On successful order placement, the system decrements each ordered Pet's stored quantity by the quantity ordered in that order, and a pet whose quantity reaches 0 becomes unavailable.
IFR7 (FR7): An authenticated admin user can create a Pet record with name, species, price, photo, description, and quantity, and can update any of those fields on an existing Pet record.
IFR8 (FR8): Create, edit, add-to-cart, and order submissions are validated — required fields must be non-empty, quantity and price must be valid non-negative numbers, and an order line's quantity must not exceed the pet's available quantity — and each failed validation displays a message identifying the field and the problem without completing the action.

## Assumptions
- Availability status (R1) is derived from inventory quantity rather than being an independently managed flag: quantity > 0 means available.
- Name search (R6) is case-insensitive substring matching; the requirements do not specify a matching rule.
- Search by name and filter by species (R6, R7) can be combined on the same list view.
- The cart (R3) is scoped to the visitor's session; no user account or login is required for visitors, and no cart persistence across sessions is specified.
- Adding the same pet to the cart multiple times increments a single line item's quantity rather than creating duplicate lines.
- Placing an order (R4) clears the cart after the confirmation is shown.
- Order IDs (R9) are unique per order; the requirements do not specify a format, so any unique identifier scheme satisfies R9.
- Inventory reduction (R5) happens at order placement time; payments are out of scope per the requirements preamble, so no payment step gates the order.
- Admin (R8) is a distinct authenticated role; how admins authenticate is unspecified and left to implementation. Deleting pets is not included, as no R-item requests it.
- Validation (R10) applies to all user-submitted forms in scope: admin pet create/edit, add-to-cart, and order placement.
- R11 and R12 appear only inside a comment marked "do NOT include in baseline" and are therefore excluded from this specification.
