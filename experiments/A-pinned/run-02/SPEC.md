# Pet Store — Specification v1.0

## Generation Metadata
- Skill: spec-generator v1.0.0
- Model: claude-fable-5 (claude-fable-5)
- Temperature: default (not exposed)
- Generated: 2026-07-23T15:40:57Z
- Skill Git Tag: instructions/v1.0.0
- Prompt Hash: sha256:bc1930c75624d6cf55cb3375f2adf66bd7ae5e8337220582e376e222349d07ae
- Input: requirements/pet-store-requirements.md

## Functional Requirements
FR1: Visitors can browse a list of pets showing each pet's name, species, price, photo, and availability status. [source: R1]
FR2: Visitors can open a pet's detail page showing its full description and quantity available. [source: R2]
FR3: Visitors can add an available pet to a shopping cart. [source: R3]
FR4: Visitors can place an order for the items in their cart, receiving an on-screen confirmation that includes an assigned order ID. [source: R4,R9]
FR5: When an order is placed, the inventory quantity of each ordered pet is reduced accordingly. [source: R5]
FR6: Visitors can search pets by name and filter the pet list by species. [source: R6,R7]
FR7: An admin user can add a new pet and edit an existing pet's details, including its quantity. [source: R8]
FR8: Invalid inputs, such as empty required fields or ordering more than the available quantity, produce clear validation messages. [source: R10]

## Interpreted Functional Requirements
IFR1 (FR1): The system provides a pet list view rendering, for each Pet entity, the attributes name, species, price, photo, and an availability status derived from its quantity (available when quantity > 0, otherwise unavailable).
IFR2 (FR2): Each pet in the list links to a detail view that displays the Pet's full description and its current quantity available in addition to its list attributes.
IFR3 (FR3): A visitor can perform an add-to-cart action on a pet whose availability status is available; the action appends the pet to the visitor's session-scoped Cart, and the action is not offered for unavailable pets.
IFR4 (FR4): A visitor can submit their non-empty Cart as an Order; on success the system creates an Order record, assigns it a unique order ID, and displays an on-screen confirmation containing that order ID.
IFR5 (FR5): When an Order is successfully placed, the system decrements each ordered Pet's inventory quantity by the quantity ordered, and recomputed availability reflects the new quantities.
IFR6 (FR6): The pet list view accepts a name search term matching pets whose name contains the term (case-insensitive) and a species filter restricting results to the selected species; search and filter may be applied together.
IFR7 (FR7): An admin user can create a Pet record with its attributes (name, species, price, photo, description, quantity) and can update any of these attributes, including quantity, on an existing Pet record.
IFR8 (FR8): The system validates inputs on pet create/edit and order placement — rejecting empty required fields and order quantities exceeding available inventory — and, on failure, blocks the action and displays a message identifying the invalid field and the reason.

## Assumptions
- Availability status (R1, R3) is derived from inventory quantity: a pet is "available" when its quantity is greater than 0; the requirements do not define availability explicitly.
- The shopping cart is scoped to the visitor's session; the requirements do not mention visitor accounts or login for shoppers.
- A cart may hold multiple pets, and ordering "more than available quantity" (R10) implies a per-pet quantity can be chosen in the cart or at add-to-cart time.
- Order IDs are unique per order; the requirements do not specify their format.
- Placing an order requires a non-empty cart; ordering from an empty cart is treated as invalid input.
- Name search is case-insensitive substring matching; the requirements do not specify matching semantics.
- Admin capability (R8) implies some distinction between admin users and visitors, but the requirements specify no authentication mechanism, so none is prescribed beyond restricting pet add/edit to admins.
- Required fields for pet creation/editing are taken to be the attributes named in R1 and R2 (name, species, price, photo, description, quantity).
- Payments are out of scope per the requirements preamble, so order placement completes without any payment step.
- The commented-out items R11 and R12 are explicitly marked as not part of this baseline and are excluded.
