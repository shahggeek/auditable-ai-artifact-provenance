# Pet Store — Specification v1.0

## Generation Metadata
- Skill: spec-generator v1.0.0
- Model: claude-fable-5 (claude-fable-5)
- Temperature: default (not exposed)
- Generated: 2026-07-23T15:48:33Z
- Skill Git Tag: instructions/v1.0.0
- Prompt Hash: sha256:bc1930c75624d6cf55cb3375f2adf66bd7ae5e8337220582e376e222349d07ae
- Input: requirements/pet-store-requirements.md

## Functional Requirements
FR1: Visitors can browse a list of pets showing each pet's name, species, price, photo, and availability status. [source: R1]
FR2: Visitors can open a pet's detail page showing its full description and quantity available. [source: R2]
FR3: Visitors can add an available pet to a shopping cart. [source: R3]
FR4: Visitors can place an order for the items in their cart and receive an on-screen confirmation that includes an assigned order ID. [source: R4,R9]
FR5: When an order is placed, the inventory quantity of each ordered pet is reduced by the quantity ordered. [source: R5]
FR6: Visitors can search pets by name and filter the pet list by species. [source: R6,R7]
FR7: An admin user can add a new pet and edit an existing pet's details, including its quantity. [source: R8]
FR8: Invalid inputs, such as empty required fields or ordering more than the available quantity, produce clear validation messages. [source: R10]

## Interpreted Functional Requirements
IFR1 (FR1): The system provides a pet list view rendering, for every Pet entity, its name, species, price, photo, and a derived availability status (available when quantity > 0, otherwise unavailable). [source: FR1]
IFR2 (FR2): Each pet in the list links to a detail view for that Pet entity displaying its full description text and its current quantity available. [source: FR2]
IFR3 (FR3): A visitor session has a Cart entity holding cart items; an "add to cart" action on a pet adds it as a cart item, and the action is only permitted when the pet's availability status is available. [source: FR3]
IFR4 (FR4): A "place order" action converts the current cart's items into an Order entity, assigns the order a unique order ID at creation, and displays an on-screen confirmation containing that order ID. [source: FR4]
IFR5 (FR5): When an Order is created, for each ordered pet the system decrements that pet's stored quantity by the quantity ordered, and the placement is rejected if any ordered quantity exceeds the pet's current quantity. [source: FR5]
IFR6 (FR6): The pet list view accepts a name search term (matching pets whose name contains the term, case-insensitively) and a species filter (matching pets of the selected species); both can be applied to narrow the displayed list. [source: FR6]
IFR7 (FR7): An admin-only interface provides create and update operations on Pet entities covering all pet fields — name, species, price, photo, description, and quantity. [source: FR7]
IFR8 (FR8): All user-submitted forms (cart/order placement and admin pet create/edit) validate inputs server-side — required fields non-empty, ordered quantity not exceeding available quantity — and on failure display a clear, field-specific validation message without completing the action. [source: FR8]

## Assumptions
- Availability status (R1, R3) is not defined explicitly; it is interpreted as derived from inventory: a pet is "available" when its quantity is greater than 0.
- The cart is scoped to the visitor's session; the requirements do not mention user accounts or login for visitors, so no visitor authentication is assumed.
- Adding a pet to the cart adds one unit; the requirements are silent on choosing quantities in the cart, so quantity selection beyond repeated adds is not specified.
- Search by name (R6) is interpreted as case-insensitive substring matching; search and species filter (R7) are assumed combinable on the same list view.
- Order ID (R9) is assumed to be unique and system-generated at order creation; its format is unspecified and left to implementation.
- "Ordering more than available quantity" (R10) is interpreted to mean order placement must be rejected with a validation message when requested quantity exceeds current inventory, implying the check in IFR5.
- Admin capability (R8) implies some means of distinguishing an admin user from visitors; the mechanism (authentication) is not specified in the requirements and is left to implementation.
- Payments are explicitly out of scope per the requirements preamble, so order placement completes without any payment step.
- The commented-out items R11 and R12 in the requirements file are marked "do NOT include in baseline" and are therefore excluded from this specification.
