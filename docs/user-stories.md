# User Stories

## [User Story to Big]

***"As a counter clerk, i want to register the customers contact information, the bikes identifying information, the reported issues by the customer, a photo of the bike's initial state and a target return date promised to the customer before taking the bike in, <u>so that</u> the bike is fully identified, ready to be worked on and have a way to contact the owner of it"***

* As a counter clerk, i want to register a bikes model, serial number, reported issue and the customers contact information, **so that** we dont mix up two or more identical bikes and can contact the owner

* As a counter clerk, i want to attach to a bike photos of its initial state, **so that** we can have them as proof of pre-exixting damage when a customer comes to complain

* As a counter clerk, i want to log the date of return that was promised to the customer, **so that** any worker has access to it in case we are late and a customer calls about it

---

## Rest of User Stories

1. As a customer, i want to be able to see the different list of prices for the repairs the shop offers, **so that** i dont have to call the store or go directly to it

2. As a mechanic, i want to log what problems i found with the bike and an estimated price for repair after inspection, **so that** staff have complete price justification ready when presenting the quote to the customer

3. As a shop worker, i want to select the repair services from a predefined price list that a bike needs, **so that** we can quickly get the total price for a full repair of the bike without checking the physical list.

4. As a shop worker, i want to be able to adjust the price of any service we gave, **so that** we can offer discounts to regular customers or easy repairs

5. As a counter clerk, i want to be able to record wether a repair has been aproved or not by a client, **so that** the mechanics know if they need to work on it

6. As a mechanic, i want to select a approved bike for me to work on, **so that** the rest of the team knows what are the bikes im working on and avoid double handling the same bike
   
7. As a mechanic, i want to update a bikes repair progress notes, and if its finished or not, **so that** any shop worker has access to that bikes information in case a customer calls about it

8. As a counter clerk, i want to be able to mark a bike as "closed" upon the customer comes to pick it up, **so that** that any worker knows the bike has been returned to its owner and the job was finished
   
9. As a shop worker, i want to be able to see a bikes history of repairs, **so that** we know if we have worked on a bike or not and notify the a new or returning customer of it

10. As a counter clerk, i want to be able to reassing an existing bike to another customer's contact details, **so that** a bike keeps its full history with its second-hand owner

11. As a bussiness owner, i want to update the service priceses list at any time while keeping past invoices unchanged, **so that** i can charge different prices for the repairs without the prices from past repairs changing to automatically



# Acceptance Criteria

### Story 2
"As a mechanic, i want to log what problems i found with the bike and an estimated price for repair after inspection, **so that** staff have complete price justification ready when presenting the quote to the customer"

* There is a notes box where the user can write multiline paragraphs and bulleted lists
* The system only allows the update when both the notes and the estimated price are filled out
* When successfully logging the information, all it is visible for the counter clerk

### Story 3
"As a shop worker, i want to select the repair services from a predefined price list that a bike needs, **so that** we can quickly get the total price for a full repair of the bike without checking the physical list."

* The screen displays a full list of all the repair services and their respective price
* Checking a an item in the list automatically updates the total price of the job
* Uncheking an item updates and reduces the  total price of the job

### Story 9
"As a shop worker, i want to be able to see a bikes history of repairs, so that we know if we have worked on a bike or not and notify the a new or returning customer of it"

* Searching a bikes serial number displays a list of prior and/current repairs of said bike
* All history tabs have the dates and services performed to the bike at te moment of repair
* Clicking a any past repair displays a detailed view of the repair

### Story 11
"As a bussiness owner, i want to update the service priceses list at any time while keeping past invoices unchanged, **so that** i can charge different prices for the repairs without the prices from past repairs changing to automatically"

* Any item in the list can be updated separately
* Items can be added or removed to the list 
* When the list is updated, the total price of past repairs on the bikes doesnt change