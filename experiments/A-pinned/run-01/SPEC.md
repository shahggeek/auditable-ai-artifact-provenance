# Pet Store — Specification

## Generation Metadata
- Skill: spec-generator v1.0.0
- Model: Claude Fable 5 (claude-fable-5)
- Temperature: default (not exposed)
- Generated: 2026-07-23T15:36:26Z
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
IFR1 (FR1): The system provides a pet list view that renders, for every Pet entity, its name, species, price, photo, and availability status (derived as available when quantity > 0, otherwise unavailable).
IFR2 (FR2): Selecting a pet from the list navigates to a detail view for that Pet showing its full description and its current quantity available, in addition to its core attributes.
IFR3 (FR3): A visitor can perform an add-to-cart action on a pet whose availability status is available, creating or incrementing a cart line item for that pet in the visitor's session-scoped Cart.
IFR4 (FR4): A visitor can submit their Cart as an Order; on success the system creates an Order record, assigns it a unique order ID, and displays an on-screen confirmation containing that order ID.
IFR5 (FR5): As part of successful order placement, the system decrements each ordered Pet's inventory quantity by the corresponding ordered quantity in the same operation that creates the Order.
IFR6 (FR6): The pet list supports a text search input that filters displayed pets to those whose name matches the entered text (case-insensitive substring match).
IFR7 (FR7): The pet list supports a species filter control that restricts displayed pets to the selected species, and search and species filter can be applied together.
IFR8 (FR8): An authenticated admin user can create a Pet with its attributes (name, species, price, photo, description, quantity) and can edit any of those attributes, including quantity, on an existing Pet.
IFR9 (FR9): On any pet-creation, pet-edit, cart, or order submission, the system validates inputs (required fields present, requested quantity does not exceed available quantity) and, on failure, rejects the action and displays a field- or action-specific validation message.

## Assumptions
- A pet's "availability status" (R1) is derived from its inventory quantity: available when quantity > 0, otherwise unavailable; the requirements do not define a separate status field.
- The shopping cart (R3) is per-visitor and session-scoped; the requirements do not mention visitor accounts or login for shoppers.
- Adding the same pet to the cart multiple times increments a quantity on a single cart line item rather than creating duplicate lines.
- Order placement (R4) requires no payment or checkout details, since payments are declared out of scope; submitting the cart is sufficient to place the order.
- Inventory reduction (R5) happens together with order creation as a single operation, so an order and its inventory decrement succeed or fail together.
- Order IDs (R9) are system-generated and unique; the requirements do not specify a format.
- Name search (R6) is interpreted as a case-insensitive substring match; the requirements do not specify matching semantics.
- Search (R6) and species filtering (R7) are combinable on the same list view, since both operate on the pet list.
- "Admin user" (R8) implies some means of distinguishing admins from visitors (e.g., an authenticated admin role), but no user-management functionality is specified beyond that.
- Validation (R10) applies to both visitor-facing actions (cart/order quantities) and admin forms (required pet fields), as these are the input surfaces implied by R1–R9.
- Commented-out requirements R11 and R12 in the input file are explicitly marked as not part of the baseline and are excluded.
