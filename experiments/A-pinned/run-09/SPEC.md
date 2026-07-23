# Pet Store — Specification

## Generation Metadata
- Skill: spec-generator v1.0.0
- Model: claude-fable-5 (claude-fable-5)
- Temperature: default (not exposed)
- Generated: 2026-07-23T15:52:41Z
- Skill Git Tag: instructions/v1.0.0
- Prompt Hash: sha256:bc1930c75624d6cf55cb3375f2adf66bd7ae5e8337220582e376e222349d07ae
- Input: requirements/pet-store-requirements.md

## Functional Requirements
FR1: Visitors can browse a list of pets showing each pet's name, species, price, photo, and availability status. [source: R1]
FR2: Visitors can open a pet's detail page showing its full description and quantity available. [source: R2]
FR3: Visitors can add an available pet to a shopping cart. [source: R3]
FR4: Visitors can place an order for the items in their cart, receive an on-screen confirmation that includes an assigned order ID, and the inventory quantity of each ordered pet is reduced accordingly. [source: R4,R5,R9]
FR5: Visitors can search pets by name and filter the pet list by species. [source: R6,R7]
FR6: An admin user can add a new pet and edit an existing pet's details, including its quantity. [source: R8]
FR7: Invalid inputs (e.g., empty required fields, ordering more than available quantity) produce clear validation messages. [source: R10]

## Interpreted Functional Requirements
IFR1 (FR1): The system provides a pet list view that renders, for every pet record, its name, species, price, photo, and a derived availability status (available when quantity > 0, otherwise unavailable).
IFR2 (FR2): Each pet in the list links to a detail view that displays that pet's full description text and its current quantity available, in addition to its base attributes.
IFR3 (FR3): A visitor session holds a shopping cart; an "add to cart" action on a pet whose availability status is available appends that pet (with a requested quantity, defaulting to 1) to the session's cart.
IFR4 (FR4): A "place order" action on a non-empty cart creates an order record from the cart's line items, assigns it a unique order ID, atomically decrements each ordered pet's inventory quantity by the ordered amount, clears the cart, and displays an on-screen confirmation containing the order ID.
IFR5 (FR5): The pet list view accepts a name search term (matching pets whose name contains the term, case-insensitively) and a species filter (restricting the list to the selected species); both may be applied together.
IFR6 (FR6): Authenticated admin users can access forms to create a pet record (name, species, price, photo, description, quantity) and to update any of these fields on an existing pet record.
IFR7 (FR7): All create, edit, cart, and order submissions are validated — required fields must be non-empty and an order line's quantity must not exceed the pet's available quantity — and any violation blocks the action and displays a message identifying the field and the problem.

## Assumptions
- "Availability status" (R1) is derived from inventory quantity: a pet is available when its quantity is greater than 0; the requirements do not define a separate status field.
- Only pets with available status can be added to the cart (R3); the add-to-cart action is absent or disabled for unavailable pets.
- The cart is scoped to the visitor's session; the requirements do not mention user accounts for visitors or cart persistence across sessions.
- Adding a pet to the cart defaults to quantity 1; the requirements are silent on selecting quantities at add time, but R10's over-quantity case implies a quantity can be specified somewhere before ordering.
- Order IDs are unique per order (R9); the requirements do not specify a format, so any unique identifier satisfies the requirement.
- Inventory decrement (R5) happens at order placement time, and an order that would drive any pet's quantity below 0 is rejected with a validation message (R10) rather than partially fulfilled.
- Admin capability (R8) implies some means of distinguishing admin users from visitors (e.g., an authenticated admin role); the requirements do not specify the authentication mechanism.
- Deleting pets is not included, as no R-item mentions it (R8 covers only add and edit).
- Payments are out of scope, per the requirements preamble; placing an order requires no payment step.
- Validation messages (R10) are shown inline on-screen at the point of the invalid action; the requirements do not specify message wording or delivery mechanism.
