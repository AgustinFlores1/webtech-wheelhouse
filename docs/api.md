# Wheelhouse API (v1)

A JSON API for the programs that are not a browser:

The shop's website reads the price list, the accounting program reads the repairs, and the owner adds services to the price list.

- **Base URL (development):** `http://127.0.0.1:3000/api/v1`
- **Format:** every response under `/api/v1` is JSON (`Content-Type: application/json`),
  errors included, whatever the request sends in its `Accept` header.

## Authentication

Reading the price list is open. Reading repairs and creating a service need a token, used with the next command on every request:

```http
Authorization: Bearer <token>
```

A token in the query string or in the body is ignored. Without the header, or with another token,
the API answers `401` before the action runs. The token lives in the application's encrypted
credentials (`api_token`); the README explains how to set one.

## Routes

| Verb   | Path                           | Token | Statuses                    |
|--------|--------------------------------|-------|-----------------------------|
| GET    | `/api/v1/services`             | No    | `200`                       |
| GET    | `/api/v1/services/:id`         | No    | `200`, `404`                |
| POST   | `/api/v1/services`             | Yes   | `201`, `400`, `401`, `422`  |
| GET    | `/api/v1/repairs`              | Yes   | `200`, `400`, `401`         |
| GET    | `/api/v1/repairs?state=…`      | Yes   | `200`, `400`, `401`         |
| GET    | `/api/v1/repairs/:id`          | Yes   | `200`, `401`, `404`         |
| any    | any other path under `/api/v1` | No    | `404`                       |

On a private route, the token is checked first: a request without it gets `401`, even for an id
that does not exist.

## Documents

### A service

`GET /api/v1/services/12`

```json
{
  "id": 12,
  "name": "Brake Adjustment",
  "price": 30.0,
  "times_charged": 2
}
```

| Key               | Meaning                                           |
| ----------------- | ---------                                         |
| `id`              | The service's id.                                 |
| `name`            | The name on the price list.                       |
| `price`           | The current price, as a number.                   |
| `times_charged`   | On how many repairs the service has been charged. |

The same shape is used by `index` (as a list), `show` and `create`.

### A collection of services

`GET /api/v1/services`: the **active**services on the price list, ordered by name.

```json
[
  { "id": 31, "name": "Basket/Rack Installation", "price": 18.0, "times_charged": 0 },
  { "id": 25, "name": "Bottom Bracket Service", "price": 45.0, "times_charged": 1 },
  { "id": 12, "name": "Brake Adjustment", "price": 30.0, "times_charged": 2 }
  ...
]
```

An inactive service is not on the price list, so `GET /api/v1/services/:id` answers `404` for it.

### Creating a service

`POST /api/v1/services` with the token and a JSON body. The keys are the ones of the document:

```bash
curl -i -X POST http://127.0.0.1:3000/api/v1/services \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer $TOKEN" \
  -d '{"service": {"name": "Disc Brake Pads", "price": 35}}'
```

| Answer | When |
| -------- | ------ |
| `201 Created` | The service was saved. The body is its document (the shape above) and the `Location` header is its URL in the API, e.g. `http://127.0.0.1:3000/api/v1/services/40`. |
| `422` | A validation refused it. `errors` has the same sentences the form of the application shows. |
| `400` | The body is empty, has none of the attributes of a service, or is not valid JSON. |
| `401` | The token is missing or wrong. |

Only `name` and `price` are read. Any other key (`is_active`, `id`, …) is dropped. A new service is
always active: the script adds services to the price list.

### A repair

`GET /api/v1/repairs/7` with the token.

```json
{
  "id": 7,
  "state": "closed",
  "came_in_on": "2026-09-28",
  "promised_on": "2026-10-02",
  "handed_back_on": "2026-10-04",
  "customer_answer": "approved",
  "bike": {
    "brand": "Trek",
    "model": "Marlin 5",
    "serial_number": "TRK-8827-A"
  },
  "customer": {
    "name": "Scott Cawthon"
  },
  "lines": [
    { "service": "Brake Adjustment", "price": 28.0 },
    { "service": "Tube Replacement", "price": 12.0 }
  ],
  "total": 40.0,
  "overdue": false
}
```

| Key | Meaning |
| ----- | --------- |
| `id` | The repair's id. |
| `state` | One of the states of the lifecycle. |
| `came_in_on` | The day the bike came in. |
| `promised_on` | The day the shop promised to hand it back. |
| `handed_back_on` | The day it was handed back, or `null` while the shop still has it. |
| `customer_answer` | The customer's answer to the quote as `"approved"`, `"declined"`, or `null` while it has not been answered (`arrived`, `pending_approval`). |
| `bike` | The bike with its brand, model and serial number. |
| `customer` | The name of the customer who brought the bike in. |
| `lines` | Each service charged with its name and the price agreed for this repair. |
| `total` | The sum of the prices of the lines. |
| `overdue` | `true` when the promised day has passed and the bike has not been handed back. |

`total`, `overdue` and `customer_answer` are not columns: the server answers them once, so every
client gets the same answer.

### A collection of repairs

`GET /api/v1/repairs` with the token: every repair, newest first, each with the shape above.

```json
[
  {
    "id": 18,
    "state": "pending_approval",
    "came_in_on": "2026-10-18",
    "promised_on": "2026-10-23",
    "handed_back_on": null,
    "customer_answer": null,
    "bike": { "brand": "Cannondale", "model": "Trail 5", "serial_number": "CAN-8865-K" },
    "customer": { "name": "Aiden Caldwell" },
    "lines": [],
    "total": 0.0,
    "overdue": false
  },
  {
    "id": 7,
    "state": "closed",
    "came_in_on": "2026-09-28",
    "promised_on": "2026-10-02",
    "handed_back_on": "2026-10-04",
    "customer_answer": "approved",
    "bike": { "brand": "Trek", "model": "Marlin 5", "serial_number": "TRK-8827-A" },
    "customer": { "name": "Scott Cawthon" },
    "lines": [
      { "service": "Brake Adjustment", "price": 28.0 },
      { "service": "Tube Replacement", "price": 12.0 }
    ],
    "total": 40.0,
    "overdue": false
  },
  ...
]
```

**Filter by state:** `GET /api/v1/repairs?state=closed` answers only the repairs in that state.
A value that is not a state answers `400` with the list of the states that exist.

### An error

Every error of the API, whatever its status, is an object with one key `errors`, whose value is
a list of strings. A client handles every error in one place.

```json
{
  "errors": [
    "Name can't be blank",
    "Current price must be greater than 0",
    ...
  ]
}
```

| Status | When | Example message |
| -------- | ------ | ----------------- |
| `400` | The body has no attributes of a service, or is empty | "param is missing or the value is empty or invalid: service" |
| `400` | The body is not valid JSON | "The body of the request is not valid JSON" |
| `400` | `?state=` has a value that is not a state | ""broken" is not a state. The states are: arrived, pending_approval, approved, declined, in_progress, completed, closed" |
| `401` | The token is missing or wrong, on a route that needs it | "A valid token is required in the Authorization header" |
| `404` | There is no record with that id | "There is no service with `id 999`" |
| `404` | No route of the API answers that path or verb | "There is no route for `DELETE /api/v1/services/1`" |
| `422` | A validation failed | "Name has already been taken" |

## Cross-origin access (CORS)

A browser lets a page read the API only if the API names the page's origin. The API allows exactly
two origins, and only for the price list (`GET /api/v1/services` and `GET /api/v1/services/:id`):

- `https://agustinflores1.github.io`, the published personal page
- `http://127.0.0.1:5500`, the same page locally while developing

The repairs and `POST /api/v1/services` are not opened to any origin. Requests without an `Origin`
header (curl, scripts, the accounting program, etc...) are not affected by CORS.

## Decisions

### How a price travels

**Every price is a JSON number, with up to two decimals.**

- **Why a number:** a client can use it directly, to format it as money or to compare it, without parsing a string first.
- Traveling as a floating number on JSON could lead to floating point problems, but they dont apply here because of the decimal number limit of 2 and a price maximum validation on the model.
- Rails writes a decimal into JSON as a string by default. The controllers convert every price
  explicitly, so this decision holds in every document that carries a price.

### What the document of a repair leaves out, and why

The accounting program needs what was charged, to whom and when. It does not need how the repair
was done or how to reach the customer.

| Left out | Why |
| ---------- | ----- |
| The customer's phone | Private personal data the accounting program has no use for when looking at repairs. |
| Every foreign key that was an id | An id is a detail of the database and not usefull information when comparing different reapirs. |
| The assigned mechanic | Who did the work and its notes are not part of what was charged, just extra information. |
| The intake photos | Files, large, and about the bike's visual condition, not about money or important information. |
| The estimated price | A quote, not a charge. Could be confused with total or the charged prices. |
| `created_at` / `updated_at` as timestamps | The desk doesnt need the update time and the created at is already handled by the attribute `came_in_on`. |

### Other decisions

- **Only active services are on the price list.** The website shows what a customer can ask for
  today. An inactive service answers `404` in the API, but stays in the application and in the
  repairs where it was charged.
- **`times_charged` counts repairs, not lines.** The repair form allows the same service on two
  lines of one repair; that is still one repair.
- **The customer's answer is derived from the state.** There is no column for it: the lifecycle
  records it. `approved`, `in_progress`, `completed` and `closed` mean the customer said yes;
  `declined` means no; `arrived` and `pending_approval` mean there is no answer yet. A declined bike
  keeps the `declined` state when it is handed back (the hand-back day records that), so `closed`
  always means the work was approved and done.
- **Brand and model come from one column.** The shop stores them together in `make_model`
  ("Trek Marlin 5"). The API sends the first word as the brand and the rest as the model, which is
  true for every bike of the shop. A two-word brand ("Santa Cruz") would be split wrongly. The fix
  could be a migration that stores them in two columns.
- **The customer of a repair is the one who brought the bike in**, not the bike's current owner:
  a bike can change owners, and the repair keeps who it belonged to.
- **Unknown routes answer JSON.** The last route catches any other path or verb under `/api/v1` and
  answers a `404` with the error shape, so no response of the API is an HTML page.
