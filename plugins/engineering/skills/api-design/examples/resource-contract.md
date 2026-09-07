# Example: designing one resource properly

Requirement: partners must be able to create, list and cancel shipments.

## What the first draft looked like

```
POST /createShipment
GET  /getShipments?all=true
POST /shipmentCancel
GET  /shipment?id=12
```

Four endpoints, four naming conventions, one verb in a path, one boolean mode
flag, and a numeric identifier exposed as a query parameter. It works. It also
tells every partner that this surface will be inconsistent for years.

## Consumers first

```
who        three logistics partners, integrating once and then rarely changing
needs      create a shipment, list shipments they created, cancel one before
           it is picked up, receive status changes
constraint their integrations are hard to change, so a breaking change costs
           weeks of coordination
```

That last line decides everything below: this is a public contract, not an
internal one, and it is versioned from day one.

## The contract

```
POST   /v1/shipments              create
GET    /v1/shipments              list, cursor paginated
GET    /v1/shipments/{id}         read
POST   /v1/shipments/{id}/cancel  action, not a resource
```

Cancellation is an action with rules, not a field update. Modelling it as
`PATCH { "status": "cancelled" }` would invite partners to set any status.

## Shapes

```json
POST /v1/shipments
Idempotency-Key: 9f1c...
{
  "reference": "PARTNER-4471",
  "pickupAt": "2026-08-14T09:00:00+02:00",
  "origin":      { "postcode": "75011", "country": "FR" },
  "destination": { "postcode": "69003", "country": "FR" },
  "parcels": [ { "weightGrams": 2400, "lengthMm": 300,
                 "widthMm": 200, "heightMm": 150 } ],
  "declaredValue": { "amount": 12500, "currency": "EUR" }
}

201 Created
Location: /v1/shipments/shp_01J8ZC
{
  "id": "shp_01J8ZC",
  "status": "pending_pickup",
  "reference": "PARTNER-4471",
  "trackingCode": "AB123456789FR",
  "createdAt": "2026-08-12T14:03:11+02:00",
  "pickupAt": "2026-08-14T09:00:00+02:00",
  "price": { "amount": 890, "currency": "EUR" }
}
```

Decisions visible in those twenty lines:

```
weights and dimensions as integers in explicit units, no floats, no ambiguity
money as integer minor units with a currency, never 8.90
an opaque prefixed identifier, so a partner cannot enumerate and a log line
  says what the identifier is
status as a documented enumeration, and the partner never sets it
the partner's own reference stored and returned, because they need to
  reconcile against their system
no internal carrier identifier, no cost price, no routing detail
```

## Errors, one shape

```json
422
{ "error": {
    "code": "validation_failed",
    "message": "The request contains invalid fields.",
    "details": [
      { "field": "parcels[0].weightGrams", "code": "out_of_range",
        "message": "weightGrams must be between 1 and 30000" },
      { "field": "pickupAt", "code": "too_soon",
        "message": "pickupAt must be at least 4 hours from now" }
    ],
    "requestId": "req_01J8ZC" } }
```

Both faults are returned together. Returning the first one only guarantees
three round trips for a partner filling a form.

## The cancel action, where the design earns its keep

```
POST /v1/shipments/shp_01J8ZC/cancel

200  { "id": "shp_01J8ZC", "status": "cancelled",
       "cancelledAt": "2026-08-12T15:00:00+02:00" }

409  { "error": { "code": "already_picked_up",
       "message": "This shipment was picked up and can no longer be cancelled.",
       "requestId": "..." } }

404  for a shipment belonging to another partner. Not 403, which would
     confirm that the identifier exists.
```

Cancelling twice returns 200 with the same body: the operation is idempotent
by nature, so no key is needed. Creating is not, so it accepts one.

## Collections

```
GET /v1/shipments?status=pending_pickup&limit=50&sort=-createdAt

{ "data": [ ... ], "nextCursor": "eyJ..." }

status      one of the documented values, 400 on anything else
sort        createdAt and pickupAt only, tiebroken by id
limit       capped at 200 server side, whatever the caller asks
no total    the partner does not need it and it costs a second query
scope       only shipments created by the calling partner, enforced in the
            loader, not in the handler
```

## What was written down before implementation

```
the four operations, with their authorization rule each
every field, its type, its unit and whether it is required
the enumeration values of status, and the transitions between them
the error codes this surface can return
pagination, sorting and filtering rules
the versioning policy, and the list of changes that would be breaking
```

Implementation took two days. The contract took three hours and is the part
that will still be true in five years.
