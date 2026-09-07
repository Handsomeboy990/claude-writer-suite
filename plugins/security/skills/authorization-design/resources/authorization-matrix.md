# The role-by-operation matrix

An authorization model is auditable only when a reviewer can read, in one place,
what each role may do to each resource. Build the matrix, then assert it in
tests so a broken rule fails the suite instead of shipping.

## The matrix

Rows are roles (and the special row "owner" for ownership models). Columns are
protected operations. Each cell is allow or deny.

```
                 view own  view any  edit own  edit any  delete any  admin panel
anonymous          -         -         -         -          -           -
user               allow     -         allow     -          -           -
org admin          allow     allow*    allow     allow*     allow*      -
platform admin     allow     allow     allow     allow      allow       allow

* scoped to the admin's own organisation, not globally
```

The asterisk is where the serious bugs live: "any" that should mean "any within
my org" but is implemented as "any at all". Make the scope explicit in the cell.

## Turning the matrix into tests

For every allow cell, a test that the operation succeeds for that role.
For every deny cell, a test that the operation is refused for that role.
For every scoped allow, a test that it succeeds in-scope and is refused
out-of-scope.

```
test('org admin cannot edit another org's record', ...)  // the scoped-deny case
test('user cannot reach the admin panel', ...)            // the vertical-escalation case
test('user cannot view another user's record by id', ...) // the horizontal-escalation case
```

## Reading the matrix for escalation

- A deny that is only enforced in the UI: the row is a lie. Enforce server side.
- A scoped allow implemented without the scope: the asterisk is missing in code.
- A new operation with no column: it inherited nothing; it is a new decision.
- A "deny" that a second interface (GraphQL, export, webhook) turns into "allow":
  the matrix must cover every interface, not just the REST API.

A matrix with no scoped cells in a multi-tenant system is not simpler; it is
incomplete.
