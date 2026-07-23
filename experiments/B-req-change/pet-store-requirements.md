# Pet Store — Business Requirements v1.1

Plain-English business requirements for a simple online pet store. Payments and complex business logic are deliberately out of scope.

- R1: Visitors can browse a list of pets showing each pet's name, species, price, photo, and availability status.
- R2: Visitors can open a pet's detail page showing its full description and quantity available.
- R3: Visitors can add an available pet to a shopping cart.
- R4: Visitors can place an order for the items in their cart and receive an on-screen confirmation.
- R5: When an order is placed, the inventory quantity of each ordered pet is reduced accordingly.
- R6: Visitors can search pets by name.
- R7: Visitors can filter the pet list by species.
- R8: An admin user can add a new pet and edit an existing pet's details, including its quantity.
- R9: Each placed order is assigned an order ID that is shown in the confirmation.
- R10: Invalid inputs (e.g., empty required fields, ordering more than available quantity) produce clear validation messages.
- R11: Pets with quantity 0 remain visible in the list and are labeled "Sold out" instead of being hidden.
- R12: The buy action is disabled from the moment an order is submitted until processing completes and inventory is updated, preventing duplicate orders.
