# Pet Store — Specification v1.0

## Generation Metadata
- Skill: spec-generator v1.0.0
- Model: claude-fable-5 (claude-fable-5)
- Temperature: default (not exposed by harness)
- Generated: 2026-07-23T03:18:59Z
- Skill Git Tag: instructions/v1.0.0
- Prompt Hash: sha256:bc1930c75624d6cf55cb3375f2adf66bd7ae5e8337220582e376e222349d07ae
- Input: requirements/pet-store-requirements.md

## Functional Requirements

FR1: The system displays a browsable list of pets showing each pet's name, species, price, photo, and availability status. [source: R1]
FR2: The system provides a detail page per pet showing its full description and quantity available. [source: R2]
FR3: The system lets a visitor add an available pet to a shopping cart. [source: R3]
FR4: The system lets a visitor place an order for the cart contents and shows an on-screen confirmation carrying a generated order ID. [source: R4,R9]
FR5: The system reduces the inventory quantity of each ordered pet when an order is placed. [source: R5]
FR6: The system lets a visitor search pets by name and filter the pet list by species. [source: R6,R7]
FR7: The system lets an admin user add a new pet and edit an existing pet's details, including its quantity. [source: R8]
FR8: The system shows a clear validation message for each invalid input, including ordering more than the available quantity. [source: R10]

## Interpreted Functional Requirements

IFR1 (FR1): Render a pet-list view backed by the pet catalog; each row/card shows name, species, formatted price, photo thumbnail, and a computed availability status derived from quantity.
IFR2 (FR2): Route from a list item to a pet-detail view that loads one pet record and renders description and current quantity available.
IFR3 (FR3): Provide an add-to-cart action, enabled only when the pet's quantity is greater than zero, that appends the pet to a session-scoped cart.
IFR4 (FR4): Provide a place-order action that submits the cart, creates an order record with a server-generated order ID, empties the cart, and renders a confirmation view showing that ID.
IFR5 (FR5): On order creation, atomically decrement each ordered pet's quantity by the quantity ordered.
IFR6 (FR6): Provide a name search input (substring match) and a species filter control that both narrow the pet-list view; they compose when used together.
IFR7 (FR7): Provide admin-only create and edit forms for pet records covering name, species, price, photo, description, and quantity.
IFR8 (FR8): Validate inputs on submission; on failure, block the action and render a field-level message, including rejecting order quantities exceeding available quantity.

## Assumptions

- The requirements do not specify how a pet with quantity 0 appears in the list; interpretation: the pet remains listed with availability status shown as "Unavailable" (IFR1, IFR3).
- The requirements do not address duplicate submission of the same order; no protection beyond IFR8's quantity validation is specified, so none is included.
- The cart is session-scoped; no persistence across sessions is required.
- A single currency is assumed for price display.
- Admin identity is assumed to be established outside these requirements; no login flow is specified.
