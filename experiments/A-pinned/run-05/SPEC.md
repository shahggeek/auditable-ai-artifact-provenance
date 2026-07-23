# Pet Store — Specification v1.0

## Generation Metadata
- Skill: spec-generator v1.0.0
- Model: claude-fable-5 (claude-fable-5)
- Temperature: default (not exposed)
- Generated: 2026-07-23T15:46:14Z
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
IFR1 (FR1): The system provides a pet list view that renders, for every Pet entity, its name, species, price, photo, and a derived availability status (available when quantity > 0, otherwise unavailable).
IFR2 (FR2): Selecting a pet from the list navigates to a detail view for that Pet entity displaying its full description text and its current quantity available.
IFR3 (FR3): From the list or detail view, a visitor can perform an add-to-cart action on a pet whose availability status is available; the pet is added as a line item in the visitor's session-scoped Cart entity.
IFR4 (FR4): A visitor with a non-empty cart can perform a place-order action that creates an Order entity from the cart's line items, assigns it a unique order ID, and displays an on-screen confirmation containing that order ID.
IFR5 (FR5): On successful order placement, the system decrements each ordered Pet's inventory quantity by the quantity of that pet in the order.
IFR6 (FR6): The pet list view accepts a search term and shows only pets whose name matches the term using case-insensitive substring matching.
IFR7 (FR7): The pet list view accepts a species selection and shows only pets whose species equals the selected species.
IFR8 (FR8): An authenticated admin user can create a Pet entity and update any field of an existing Pet entity (name, species, price, photo, description, quantity) via admin add and edit actions.
IFR9 (FR9): Create, edit, and order submissions are validated — required fields must be non-empty and an ordered quantity must not exceed the pet's available quantity — and any violation blocks the action and displays a message identifying the invalid field and the reason.

## Assumptions
- Availability status is derived from inventory: a pet is "available" when its quantity is greater than 0; the requirements do not define how availability is determined.
- A cart is scoped to the visitor's session; the requirements do not mention visitor accounts or login for shoppers.
- Adding the same pet to the cart multiple times, up to the available quantity, forms a line item with a quantity; the requirements do not specify cart quantity handling.
- Order IDs are unique across all orders; the requirements do not specify the ID format, so no particular format is assumed.
- Search matching (R6) is interpreted as case-insensitive substring matching on the pet name.
- Species filtering (R7) uses a fixed selection (e.g., a dropdown of known species) with exact matching.
- The admin user is distinguished from visitors by some authentication mechanism; the requirements do not specify how admin access is granted, so no specific mechanism is assumed.
- Editable pet fields for the admin (R8) are all pet attributes named elsewhere in the requirements: name, species, price, photo, description, and quantity.
- Validation (R10) applies both to visitor order placement and to admin pet add/edit forms, since both involve user input with required fields.
- Payments are out of scope per the requirements preamble; placing an order requires no payment step.
