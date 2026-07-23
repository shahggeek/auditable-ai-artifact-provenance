## Generation Metadata
- Skill: spec-generator v1.0.0
- Model: Fable 5 (claude-fable-5)
- Temperature: default (not exposed)
- Generated: 2026-07-23T15:51:43Z
- Skill Git Tag: instructions/v1.0.0
- Prompt Hash: sha256:bc1930c75624d6cf55cb3375f2adf66bd7ae5e8337220582e376e222349d07ae
- Input: requirements/pet-store-requirements.md

## Functional Requirements
FR1: Visitors can browse a catalog of pets, viewing each pet's name, species, price, photo, and availability status in the list and its full description and quantity available on a detail page. [source: R1,R2]
FR2: Visitors can search the pet catalog by name and filter the pet list by species. [source: R6,R7]
FR3: Visitors can add an available pet to a shopping cart. [source: R3]
FR4: Visitors can place an order for the items in their cart and receive an on-screen confirmation that includes an assigned order ID. [source: R4,R9]
FR5: When an order is placed, the inventory quantity of each ordered pet is reduced by the quantity ordered. [source: R5]
FR6: An admin user can add a new pet and edit an existing pet's details, including its quantity. [source: R8]
FR7: Invalid inputs, such as empty required fields or ordering more than the available quantity, produce clear validation messages. [source: R10]

## Interpreted Functional Requirements
IFR1 (FR1): The system stores Pet entities with attributes name, species, price, photo, description, quantity, and a derived availability status (available when quantity > 0); a list view renders name, species, price, photo, and availability for all pets, and selecting a pet opens a detail view that additionally renders its full description and current quantity available.
IFR2 (FR2): The pet list view accepts a text query that matches pets whose name contains the query (case-insensitive substring match) and a species filter that restricts the list to pets of the selected species; search and filter can be applied together.
IFR3 (FR3): From the list or detail view, a visitor can perform an add-to-cart action on a pet whose availability status is available, which appends the pet (or increments its quantity) in a session-scoped Cart entity; the action is rejected for unavailable pets.
IFR4 (FR4): A visitor can submit their non-empty cart as an Order; on success the system creates an Order record containing the ordered items and quantities, assigns it a unique order ID, clears the cart, and displays an on-screen confirmation showing that order ID.
IFR5 (FR5): As part of successful order placement, the system decrements each ordered pet's stored quantity by the quantity ordered, and a pet whose quantity reaches 0 becomes unavailable.
IFR6 (FR6): An authenticated user with the admin role can create a Pet record by supplying name, species, price, photo, description, and quantity, and can update any of those fields, including quantity, on an existing Pet record.
IFR7 (FR7): All create, update, add-to-cart, and order-placement inputs are validated — required fields must be non-empty, and an order line's quantity must not exceed the pet's available quantity — and any violation blocks the action and displays a clear, field-specific validation message to the user.

## Assumptions
- Availability status is not defined in the requirements; it is interpreted as derived from quantity (available when quantity > 0, unavailable when quantity is 0).
- Name search is interpreted as case-insensitive substring matching, and search and species filter are assumed to be combinable.
- The cart is assumed to be session-scoped per visitor, since no visitor accounts or login are required by the requirements.
- Adding the same pet to the cart multiple times is interpreted as incrementing that pet's quantity in the cart.
- Order placement is assumed to clear the cart after successful confirmation.
- Order IDs are assumed to be unique per order; no specific format is prescribed.
- The admin user is assumed to be authenticated and distinct from visitors, though no authentication mechanism is specified in the requirements.
- Required fields for a pet are assumed to be those listed in R1/R2 (name, species, price, photo, description, quantity).
- Payments are out of scope per the requirements preamble, so placing an order requires no payment step.
- The commented-out items R11 and R12 in the requirements file are explicitly marked as not part of the baseline and are excluded.
