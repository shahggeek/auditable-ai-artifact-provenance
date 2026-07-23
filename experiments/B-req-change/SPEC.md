# Pet Store — Specification v1.0

## Generation Metadata
- Skill: spec-generator v1.0.0
- Model: claude-fable-5
- Temperature: default (not exposed)
- Generated: 2026-07-23T16:15:40Z
- Skill Git Tag: instructions/v1.0.0
- Prompt Hash: sha256:bc1930c75624d6cf55cb3375f2adf66bd7ae5e8337220582e376e222349d07ae
- Input: pet-store-requirements.md

## Functional Requirements
FR1: Visitors can browse a list of pets showing each pet's name, species, price, photo, and availability status. [source: R1]
FR2: Visitors can open a pet's detail page showing its full description and quantity available. [source: R2]
FR3: Visitors can add an available pet to a shopping cart. [source: R3]
FR4: Visitors can place an order for the items in their cart and receive an on-screen confirmation that includes a unique order ID. [source: R4,R9]
FR5: When an order is placed, the inventory quantity of each ordered pet is reduced by the quantity ordered. [source: R5]
FR6: Visitors can search pets by name. [source: R6]
FR7: Visitors can filter the pet list by species. [source: R7]
FR8: An admin user can add a new pet and edit an existing pet's details, including its quantity. [source: R8]
FR9: Invalid inputs (e.g., empty required fields, ordering more than available quantity) produce clear validation messages. [source: R10]
FR10: Pets with quantity 0 remain visible in the pet list and are labeled "Sold out" instead of being hidden. [source: R11]
FR11: The buy action is disabled from the moment an order is submitted until processing completes and inventory is updated, preventing duplicate orders. [source: R12]

## Interpreted Functional Requirements
IFR1 (FR1): The system renders a pet list view where each Pet entity displays its name, species, price, photo URL, and an availability status derived from quantity (available if quantity > 0, otherwise sold out).
IFR2 (FR2): Selecting a pet from the list navigates to a detail view for that Pet showing its full description text and its current quantity available.
IFR3 (FR3): From the list or detail view, a visitor can add a Pet with quantity > 0 to a session-scoped Cart as a cart line item with a requested quantity (default 1).
IFR4 (FR4): Submitting the cart creates an Order entity from the cart line items, assigns it a system-generated unique order ID, empties the cart, and displays an on-screen confirmation containing that order ID.
IFR5 (FR5): Order placement atomically decrements each ordered Pet's quantity by the ordered amount, rejecting the order if any requested quantity exceeds the pet's current quantity.
IFR6 (FR6): The pet list accepts a search term and shows only pets whose name contains the term, matched case-insensitively.
IFR7 (FR7): The pet list accepts a species filter and shows only pets of the selected species; search and filter can be applied together.
IFR8 (FR8): An authenticated admin user can create a Pet with name, species, price, photo, description, and quantity, and can edit any of those fields on an existing Pet.
IFR9 (FR9): Form submissions (add to cart, place order, admin add/edit pet) validate inputs — required fields non-empty, quantities positive integers not exceeding available stock — and display a field-specific validation message on failure without discarding the user's other input.
IFR10 (FR10): The pet list query includes pets with quantity = 0 and renders a "Sold out" label in place of their available status; add-to-cart is not offered for them.
IFR11 (FR11): On order submission the buy/place-order control is immediately disabled (client-side) and repeat submissions of the same cart are rejected (server-side) until order processing completes and inventory is updated, after which the control is re-enabled.

## Assumptions
- Availability status (R1) is derived from quantity: quantity > 0 means available; quantity 0 means "Sold out". No separate availability field exists.
- The cart is session-scoped and requires no visitor account or login; only the admin role (R8) requires authentication, and how the admin authenticates is out of scope.
- Adding a pet to the cart defaults to quantity 1; the visitor may request a higher quantity, which is validated against available stock at order time.
- Order IDs (R9) are system-generated and unique across all orders; the format (numeric or string) is unspecified and left to implementation.
- Inventory decrement (R5) happens atomically at order placement, not at add-to-cart time; the order is rejected as a whole if any line exceeds available stock.
- Search (R6) is a case-insensitive substring match on pet name; search and species filter (R7) can be combined.
- The species filter offers a single species selection at a time.
- "Clear validation messages" (R10) are interpreted as field-specific messages shown next to or near the offending input, preserving other entered values.
- Duplicate-order prevention (R12) is enforced both client-side (disabled control) and server-side (repeat submission of the same cart rejected), since a disabled button alone cannot prevent duplicates.
- Payments, shipping, taxes, and order history/lookup after confirmation are out of scope, per the requirements preamble.
