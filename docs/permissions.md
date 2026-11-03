# Permissions

Who may do what in Wheelhouse. Each table is one policy in `app/policies/`, and each row is one
method of that policy. A refused request answers `403` with the "not allowed" page, except where a
row says `404`.

- **Owner**, **Counter**, **Mechanic** are the three roles of an account (`users.role`).
- A **visitor** (no session) is sent to sign in on every page except the price list. Visitors are
  only mentioned where a page is open to them.
- **A mechanic's own repairs** are the repairs whose mechanic is the member of the staff joined to
  their account. An account with the role `mechanic` and no member of the staff (every account
  created from the sign-up page, since `mechanic` is the default role) has no repairs of its own.
- **Handed back** means a repair in the final state of the lifecycle, `closed`.
- `new` asks the same question as `create`, and `edit` the same as `update`.
- Signing in, signing out, signing up, a forgotten password and the pages home, workshop and about
  do not ask a policy. They are listed, with the reason, in `docs/decisions.md`.

## Services (`ServiceCatalogPolicy`)

| Action | Owner | Counter | Mechanic |
| --- | --- | --- | --- |
| `index` — list of services | Yes | Yes | Yes |
| `show` — one service | Yes | Yes | Yes |
| `new`, `create` | Yes | No | No |
| `edit`, `update` | Yes | No | No |
| `destroy` | Yes | No | No |

The list and the page of a service are also open to visitors, without a session.

## Staff (`StaffMemberPolicy`)

| Action | Owner | Counter | Mechanic |
| --- | --- | --- | --- |
| `index` | Yes | Yes | Yes |
| `show` | Yes | Yes | Yes |
| `new`, `create` | Yes | No | No |
| `edit`, `update` | Yes | No | No |
| `destroy` | Yes | No | No |

## Customers (`CustomerPolicy`)

| Action | Owner | Counter | Mechanic |
| --- | --- | --- | --- |
| `index` | Yes, every customer | Yes, every customer | No |
| `show` | Yes | Yes | No |
| `new`, `create` | Yes | Yes | No |
| `edit`, `update` | Yes | Yes | No |
| `destroy` | Yes | No | No |

## Bikes (`BikePolicy`)

| Action | Owner | Counter | Mechanic |
| --- | --- | --- | --- |
| `index` | Yes, every bike | Yes, every bike | No |
| `show` | Yes | Yes | No |
| `new`, `create` | Yes | Yes | No |
| `edit`, `update` | Yes | Yes | No |
| `destroy` | Yes | No | No |

## Repairs (`RepairPolicy`)

| Action | Owner | Counter | Mechanic |
| --- | --- | --- | --- |
| `index` | Yes, every repair | Yes, every repair | Yes, **only their own repairs** |
| `show` | Yes | Yes | Only their own repairs; another repair answers `404` |
| `new`, `create` | Yes | Yes | No |
| `edit`, `update` | Yes, every repair | Only a repair **not handed back** | Only their own repairs **not handed back**; another repair answers `404` |
| `destroy` | Yes | No | No; another repair answers `404` |
| Remove an intake photo | Yes | Only on a repair **not handed back** | No; another repair answers `404` |

Every list of repairs (the index and the repairs on a bike's page) uses the same scope as the
index: a mechanic sees only their own, in every list.

A repair is looked up inside that scope, so a repair the person may not read answers `404`, the
same as an id that does not exist. A repair they may read but not change answers `403`.

### Fields of the repair's form

| Field | Owner | Counter | Mechanic |
| --- | --- | --- | --- |
| State | Yes | Yes | Yes |
| Diagnosis | Yes | Yes | Yes |
| Intake photos | Yes | Yes | Yes (adds them) |
| Bike | Yes | Yes | No |
| Customer | Yes | Yes | No |
| Mechanic | Yes | Yes | No |
| Reported issue | Yes | Yes | No |
| Promised day | Yes | Yes | No |
| Estimated price | Yes | Yes | No |
| Handed back at | Yes | Yes | No |
| Services charged and their prices | Yes | Yes | No |

The form shows each person only these fields, and a field outside their list sent by hand is
dropped. The account that took a repair in is never a field: it is read from the session when the
repair is created.
