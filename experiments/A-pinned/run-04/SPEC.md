# Pet Store — Specification v1.0

## Generation Metadata
- Skill: spec-generator v1.0.0
- Model: Fable 5 (claude-fable-5)
- Temperature: default (not exposed)
- Generated: 2026-07-23T15:43:50Z
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
IFR1 (FR1): The system provides a pet-list view that renders every Pet entity with its name, species, price, photo, and a derived availability status (available when quantity > 0, otherwise unavailable).
IFR2 (FR2): Each pet in the list links to a detail view that displays the Pet entity's full description and its current quantity available.
IFR3 (FR3): The pet-list view accepts a name search term (case-insensitive substring match on pet name) and a species filter (exact match from the set of existing species), applied together when both are provided, and shows the matching pets.
IFR4 (FR4): A visitor-scoped Cart entity holds line items of pet and quantity; the add-to-cart action succeeds only for pets whose availability status is available.
IFR5 (FR5): A place-order action converts the current cart's line items into an Order entity with a unique system-generated order ID, clears the cart, and displays an on-screen confirmation containing that order ID.
IFR6 (FR6): When an Order is successfully placed, the system decrements each ordered pet's inventory quantity by the ordered quantity as part of order creation.
IFR7 (FR7): An authenticated admin user can create a Pet entity and update any field of an existing Pet entity — name, species, price, photo, description, and quantity — via admin-only add and edit actions.
IFR8 (FR8): Pet add/edit and place-order inputs are validated — required fields must be non-empty and an ordered quantity must not exceed the pet's available quantity — and any violation blocks the action and displays a field-specific validation message.

## Assumptions
- Availability status is not defined in the requirements; it is interpreted as derived from inventory quantity (available when quantity > 0).
- Name search is interpreted as case-insensitive substring matching; the requirements do not specify match semantics.
- Search and species filter are assumed to be combinable in a single list view, since both operate on the pet list.
- The cart is assumed to be per-visitor (e.g., session-scoped); no user accounts for visitors are required by the requirements.
- Placing an order is assumed to clear the cart; the requirements are silent on post-order cart state.
- Order IDs are assumed to be unique and system-generated; the requirements specify only that each order is assigned one.
- Inventory decrement is assumed to happen atomically as part of order placement, since R5 ties it to the order being placed.
- Admin authentication/identification is assumed to exist ("an admin user"), but no specific auth mechanism is required by the requirements.
- Validation messages are assumed to appear on both visitor order flows and admin pet forms, since R10 gives examples from both areas (empty required fields, over-quantity orders).
- Payments are out of scope per the requirements preamble, so placing an order involves no payment step.
- The commented-out items R11 and R12 in the requirements file are explicitly marked as not part of the baseline and are excluded from this specification.
