# Example: finding and fixing broken object-level authorization

A REST API for an invoicing app, audited for object-level access. The model is
ownership: an invoice belongs to an organisation, a user belongs to an
organisation, a user may see their organisation's invoices only.

## Enumerating the request-supplied ids

```
GET    /invoices/:id        reads by id
PUT    /invoices/:id        updates by id
DELETE /invoices/:id        deletes by id
GET    /invoices/:id/pdf    exports by id
POST   /invoices/:id/pay    triggers payment by id
GET    /invoices?org=:org   lists by an org id from the query
```

## The cross-user probe

As user A (org 1), request an invoice belonging to org 2:

```
GET /invoices/8842        200, returns org 2's invoice   <- finding
GET /invoices/8842/pdf    200, returns org 2's PDF        <- finding
POST /invoices/8842/pay   202, pays org 2's invoice       <- finding, critical
GET /invoices?org=2       200, lists org 2's invoices     <- finding
```

The route guard checks that the caller is authenticated. It never checks that
the invoice belongs to the caller's organisation. Five endpoints, one missing
scope.

## Findings

```
object-level authorization absent on invoice access
severity critical: /pay lets any authenticated user pay from another org's
account; the rest expose and mutate another org's financial data
files: src/invoices/controller.js:22-71 (all five handlers)
root cause: the query is findById(id), not findOne({ id, orgId: caller.orgId })
```

## Fix

Move the scope into the query, in one place every handler uses:

```
before   const inv = await Invoice.findById(req.params.id)
after    const inv = await Invoice.findOne({ _id: req.params.id, orgId: req.user.orgId })
         if (!inv) return res.status(404).end()   // not-found, not forbidden:
                                                   // does not confirm existence
```

The list endpoint ignores the client's `org` parameter entirely and scopes to
`req.user.orgId`. The parameter is removed from the contract.

## Verification

```
GET /invoices/8842 as user A (org 1)   404, was 200
POST /invoices/8842/pay as user A      404, was 202
GET /invoices as user A                returns only org 1, ignores ?org
GET /invoices/8842 as a user in org 2  200, still works for the owner
```

The reproduction that found the defect now fails to exploit, and the legitimate
owner is unaffected. A test matrix asserts owner-allowed and non-owner-denied
for all five operations, so a regression fails the suite.
