---
name: authorization-design
description: Designs and audits what an authenticated identity may do: the model (roles, attributes, ownership), object-level access so one user cannot reach another's data, enforcement at a server-side choke point, and the privilege-escalation paths that bypass it. Object-level authorization is the single most common serious web defect, and this skill exists to close it. Use when building or reviewing any permission, role, ownership or access-control decision.
license: MIT
metadata:
  category: secure-development
  version: 1.0.0
  depends_on: [security-core]
  outputs: [authorization-model, access-findings, enforcement-plan, applied-fixes]
---

# Authorization Design

Authentication established who the user is. Authorization decides what they may
do, and it is where the expensive breaches happen: not a broken login, but a
working login that then reaches data it should never touch.

The single most common serious defect in web applications is object-level
authorization: a request supplies an identifier, and the system returns the row
without checking that the row belongs to the caller. This skill exists to close
that, and the rest.

## 1. Choose the model, and keep it small

```
ownership       the row has an owner; the caller must be it. The most common
                need, and the most commonly missed.
role-based      a fixed set of roles, each with a fixed set of permissions.
                Enough for most applications.
attribute-based   the decision depends on attributes of the user, the resource
                and the context. Powerful, and easy to make unauditable. Use it
                only where roles genuinely cannot express the rule.
relationship    the decision depends on a graph: team membership, sharing,
                delegation. Model it explicitly, not as scattered checks.
```

Pick the simplest model that expresses the real rules. A model nobody can audit
is a model that hides a bug.

## 2. Object-level authorization, everywhere it applies

For every operation that takes an identifier from the request, the row it
addresses must be scoped to the caller before it is read, updated or deleted.

```
enumerate   list every query, mutation and route that accepts an id, a slug,
            a filename or any resource reference from the request
scope       each one filters by the caller's ownership or membership, in the
            query, not after the fetch
verify      GET /orders/1002 as user A, where 1002 belongs to user B, returns
            not-found or forbidden, never the order
indirect    the same for a nested reference: the comment id whose parent post
            belongs to another user; the file id inside another tenant
```

Returning not-found rather than forbidden also avoids confirming the resource
exists, closing an enumeration path at the same time.

## 3. Enforce at a choke point, server side

```
server side   every decision is made on the server; a hidden UI control is not
              a control. The client is convenience, never enforcement.
one place     authorization lives in a module every protected path passes
              through, not copied into each handler where copies drift
close to data   the ownership filter is on the query; a route guard that admits
              the request does not protect the row it then fetches unscoped
default deny  an operation with no explicit grant is refused, per security-core
```

## 4. Privilege escalation: the paths around the check

The check can be correct and still bypassed. Walk the paths that reach a
capability without passing the guard.

```
mass assignment   can the client set a field it should not: role, plan, owner,
                  isAdmin, tenantId, in a create or update body?
horizontal        can user A act as user B by changing an id, not a role?
vertical          can a user reach an admin operation by a second route: an API
                  the UI hides, a legacy endpoint, an export, a webhook?
indirect          can a lower privilege trigger a higher one: a job that runs
                  as a service account, a callback that skips the guard?
inconsistent      is the rule enforced on read but not on write, on the API but
                  not on the GraphQL resolver, on one field but not its sibling?
```

## 5. Auditability

An authorization model is only safe if a reviewer can read it and say what any
user may do.

```
express   the rules in one readable place, not inferred from forty handlers
test      a matrix: for each role and each protected operation, allowed or not,
          asserted by a test that fails when the rule breaks
log       a denied high-value operation is recorded, so escalation attempts are
          visible
review    a new route is a new authorization decision; it does not inherit
          protection by being near a protected one
```

## 6. Prohibitions

- Never return a resource addressed by a request id without scoping it to the
  caller.
- Never enforce authorization in the client alone.
- Never let a create or update body set a privilege field.
- Never assume a new route inherits the protection of its neighbours.
- Never build an attribute or relationship model more complex than the rules
  require; complexity hides bypasses.
- Never enforce a rule on read and forget it on write, or on one interface and
  not another.

## 7. Protocol

1. Establish the model the real rules need, and no more.
2. Enumerate every operation that takes a resource reference from the request.
3. Scope each to the caller in the query; verify with a cross-user request.
4. Move enforcement to a server-side choke point close to the data.
5. Walk the escalation paths in section 4: mass assignment, horizontal,
   vertical, indirect, inconsistent.
6. Build the role-by-operation test matrix and assert it.
7. Rank findings on the `security-core` scale; fix and verify each.
8. Record the model where the architecture lives.

## 8. Auto-critique

Score from 0 to 5: model no more complex than the rules, every request-supplied
id scoped to the caller in the query, enforcement server side at one choke
point, mass assignment closed, horizontal and vertical escalation walked,
consistency across read/write and across interfaces, a role-by-operation test
matrix exists.

Threshold: no axis below 3, average at least 4. A single unscoped object access
reachable by an authenticated user is a high or critical finding and caps the
score until fixed. Object-level authorization is checked first and weighted
heaviest, because it is the defect most likely to be present and most damaging
when it is.

## 9. Interfaces

- Upstream: `security-core`, `authentication-security` establishes the identity
  this skill acts on, `security-architecture` for the choke-point decision.
- Downstream: `security-audit` verifies object-level access in the code,
  `backend-engineering` implements the scoped queries, `api-design` reflects the
  rules in the contract.
- Lateral: `session-security` for the identity the decision reads,
  `data-privacy` when access controls personal data, `bug-hunting` for the
  cross-user probing.
