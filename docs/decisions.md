# Questions for the owner

1. ¿Can multiple mechanics work on the same bike/job at a time, or is one mechanic is solely responsible for the bikes it takes on as work?
    * The asumption made was that only one mechanic can work on a bike at a time, changing these means removing one entire user story and every repair can have multiple mechanic_ids associated with it, needing to create a separate table for repair_mechanic

2. ¿Is a concurrent customer someone the workers or you decide, or is it a client that has certian number of repairs associated to them?
    * The assumption was made that a concurent costumer is someone that was decided by the owner/workers, so it was their job to change the price if needed, if not the case, there will have to be a counter or state for the costumers that indicates that they are a concurrent customer and there is no way of individualizing that costumers discount, because the program doesnt differentiate

3. ¿Is there a policy for bikes that a costumer doesnt come back to recorver, or they can stay infinitely in a completed state?
    * The assumption was that every bike will be recovered by the costumer, but if not the case and the costumer never appears, there could be a new state for bikes as "Not recoveres" or something else that indicates the owner didnt come back after certain dates and the bike stops being associated with them in the system

4. ¿Does the person that goes in for a repair matter or that the bike has a repair?
    * The assumption was that we store the person that did the repair to associate it with them, then that customer owns that reapir rather than the current owner of the bike

## Accounts (Lab 11)

### Default role: mechanic

Anyone can create an account from the public sign-up page, so the default role is the one
that does the least damage in the hands of a stranger.

* **owner** manages the whole workshop: staff, prices of the catalogue, every repair.
* **counter** registers customers with their phone numbers, takes bikes in, sets the
  estimated price and records the customer's approval: personal data and money.
* **mechanic** works on the repairs assigned to them: diagnosis and the stages of the repair.

The mechanic touches the fewest records and no customer data or prices, so it is the default.
The owner promotes an account from the seed or the console.

## Accounts (Lab 12)

### Actions that do not ask a policy

Every action of every controller calls Pundit (`authorize`, and `policy_scope` on every index),
and `ApplicationController` verifies it after each action. These are the exceptions, skipped
with `skip_after_action :verify_authorized`:

| Controller | Actions | Why no policy |
| --- | --- | --- |
| `SessionsController` | `new`, `create`, `destroy` | Signing in happens before there is an account to ask about; signing out only ends your own session. |
| `RegistrationsController` | `new`, `create` | Signing up happens before there is an account. The role is never taken from the form. |
| `PasswordsController` | `new`, `create`, `edit`, `update` | A person who forgot their password has no session. The token in the link identifies the account. |
| `PagesController` | `home`, `workshop`, `about` | Open to every signed-in account; they show fixed information and no record, so there is no rule to ask. |

### Another mechanic's repair answers 404

A repair is looked up inside the policy scope (`policy_scope(Repair).find`). A mechanic who
changes the id in the URL gets 404, the same as for an id that does not exist, so they cannot
learn that the repair exists. A repair they can see but may not change (a handed-back one)
answers 403.
