# Pet Store — Specification v1.0

## Generation Metadata
- Skill: spec-generator v1.0.0
- Model: claude-fable-5 (claude-fable-5)
- Temperature: default (not exposed)
- Generated: 2026-07-23T15:47:26Z
- Skill Git Tag: instructions/v1.0.0
- Prompt Hash: sha256:bc1930c75624d6cf55cb3375f2adf66bd7ae5e8337220582e376e222349d07ae
- Input: requirements/pet-store-requirements.md

## Functional Requirements
FR1: Visitors can browse a list of pets showing each pet's name, species, price, photo, and availability status. [source: R1]
FR2: Visitors can open a pet's detail page showing its full description and quantity available. [source: R2]
FR3: Visitors can add an available pet to a shopping cart. [source: R3]
FR4: Visitors can place an order for the items in their cart and receive an on-screen confirmation that includes an assigned order ID. [source: R4,R9]
FR5: When an order is placed, the inventory quantity of each ordered pet is reduced by the quantity ordered. [source: R5]
FR6: Visitors can search pets by name. [source: R6]
FR7: Visitors can filter the pet list by species. [source: R7]
FR8: An admin user can add a new pet and edit an existing pet's details, including its quantity. [source: R8]
FR9: Invalid inputs, such as empty required fields or ordering more than the available quantity, produce clear validation messages. [source: R10]

## Interpreted Functional Requirements
IFR1 (FR1): The system provides a pet list view that renders, for every Pet entity, its name, species, price, photo, and an availability status derived from its quantity (available when quantity > 0, otherwise unavailable).
IFR2 (FR2): Each pet in the list links to a detail view that displays that Pet's full description and its current quantity available, in addition to its basic attributes.
IFR3 (FR3): From the list or detail view, a visitor can perform an add-to-cart action on a pet whose availability status is available; the action appends the pet (with a requested quantity) to a session-scoped Cart, and is not offered for unavailable pets.
IFR4 (FR4): A visitor with a non-empty Cart can submit a place-order action that creates an Order entity from the cart contents, assigns it a unique order ID, clears the cart, and displays an on-screen confirmation containing that order ID.
IFR5 (FR5): When an Order is successfully created, the system decrements each ordered Pet's stored quantity by the quantity ordered for that pet, persisting the new quantities.
IFR6 (FR6): The pet list view accepts a text search term and restricts the displayed pets to those whose name matches the term using case-insensitive substring matching.
IFR7 (FR7): The pet list view accepts a species selection drawn from the species present in the catalog and restricts the displayed pets to that species; search and filter may be applied together.
IFR8 (FR8): An authenticated admin user can create a Pet record (name, species, price, photo, description, quantity) and can edit any of those fields, including quantity, on an existing Pet record.
IFR9 (FR9): The system validates all user-submitted forms (add-to-cart, order placement, admin pet create/edit); when a required field is empty or a requested order quantity exceeds the pet's available quantity, the submission is rejected and a clear, field-specific validation message is shown.

## Assumptions
- Availability status (R1, R3) is derived from inventory quantity: a pet is "available" when its quantity is greater than 0; the requirements do not define availability explicitly.
- The shopping cart is per-visitor and session-scoped; no login is required for visitors, and cart persistence across sessions is not required.
- Adding a pet to the cart includes a requested quantity (defaulting to 1), since orders can consume more than one unit (implied by R5 and R10's over-quantity case).
- Order IDs (R9) are unique across all orders; the requirements do not specify a format, so any unique identifier scheme is acceptable.
- Placing an order (R4) clears the cart after successful submission; the requirements are silent on post-order cart state.
- Inventory is decremented at order placement time (R5); payments are out of scope, so no payment step gates the decrement.
- Search by name (R6) is interpreted as case-insensitive substring matching; the requirements do not specify matching semantics.
- Species filtering (R7) offers the set of species present in the catalog and can be combined with name search; the requirements do not state whether they combine.
- "Admin user" (R8) implies some authentication/authorization distinguishing admins from visitors, but the mechanism is unspecified and left to implementation; no admin user management features are included since none have an R-source.
- Validation (R10) applies to all user-facing forms in scope (cart, order, admin pet forms), with the listed cases (empty required fields, over-quantity orders) as the minimum required checks.
- R11 and R12 appear only inside a comment marked "do NOT include in baseline" and are therefore excluded from this specification.
