# Questions for the owner

1. ¿Can multiple mechanics work on the same bike/job at a time, or is one mechanic is solely responsible for the bikes it takes on as work?
    * The asumption made was that only one mechanic can work on a bike at a time, changing these means removing one entire user story and every repair can have multiple mechanic_ids associated with it, needing to create a separate table for repair_mechanic

2. ¿Is a concurrent customer someone the workers or you decide, or is it a client that has certian number of repairs associated to them?
    * The assumption was made that a concurent costumer is someone that was decided by the owner/workers, so it was their job to change the price if needed, if not the case, there will have to be a counter or state for the costumers that indicates that they are a concurrent customer and there is no way of individualizing that costumers discount, because the program doesnt differentiate

3. ¿Is there a policy for bikes that a costumer doesnt come back to recorver, or they can stay infinitely in a completed state?
    * The assumption was that every bike will be recovered by the costumer, but if not the case and the costumer never appears, there could be a new state for bikes as "Not recoveres" or something else that indicates the owner didnt come back after certain dates and the bike stops being associated with them in the system