# Example: a proposal that fits on one page

Project: the support lookup tool from the delivery orchestrator example. Small
by every measure. Here is the entire proposal.

````markdown
# Architecture: support customer lookup

Revision: 2026-08-10
Specification: docs/specs/support-lookup.md
Status: proposed

## 1. Executive summary

A read only page inside the existing internal application. A support agent
enters a customer email, sees the customer and their last ten orders. No new
service, no new database, no new deployment target.

Stack: the existing Next.js application, the existing PostgreSQL database, the
existing session authentication.

Shaping decision: this is a feature of the existing internal app rather than a
new tool, because it needs the same authentication and the same data, and a
second deployable would double the operational surface for one page.

## 2. Requirements mapping

| Requirement | Component | Notes |
|---|---|---|
| R1 look up a customer by email | GET /api/support/customers | exact match, per answer to Q2 |
| R2 see the last ten orders | same endpoint, one join | order headers only, per answer to Q1 |
| R3 support role only | existing role check, `support` | new role value, one migration |
| R4 behind the VPN | inherited from the existing deployment | no change |

Uncovered requirements: none.
Components serving no requirement: none.

## 3. System architecture

| Piece | Choice | Why | If it fails |
|---|---|---|---|
| Frontend | existing app, one route | no reason for a second surface | existing error page |
| Backend | existing app, one handler | same | 500 with the existing contract |
| Database | existing PostgreSQL | the data is already there | existing behaviour |
| Authentication | existing sessions | no new identity | existing redirect |
| File storage | none | no files in this feature | |
| External services | none | no integration needed | |
| Queue and workers | none | read only, synchronous | |
| Caching | none | one query, no measured need | |
| Infrastructure | existing internal deployment | | |
| Monitoring | existing logger and error surface | | |

## 4. Application architecture

```
app/support/customers/page.tsx     server component, renders the form
  -> app/api/support/customers     handler: auth, validate, authorize, query
       -> lib/services/support.ts  the one business rule: last ten, headers
            -> lib/data/orders.ts  the query
```

| Module | Owns behaviour | Owns data | May be called by |
|---|---|---|---|
| lib/services/support.ts | lookup rules | none | the support handler only |
| lib/data/orders.ts | order queries | reads orders | services only |

Dependency direction: page to handler to service to data, never backwards.
Known violations: none introduced.

## 5. Database architecture

Engine: existing PostgreSQL. No new entity.

Reads: `customers` by email, `orders` by customer_id.

Indexes planned:
| Table | Columns | Serving which query |
|---|---|---|
| customers | lower(email) | the exact match lookup, case insensitive |
| orders | (customer_id, created_at desc) | the last ten, already exists |

Constraints: none added.
Transactions: none, read only.
Data lifecycle: unchanged, this feature creates nothing.
Migration strategy: one additive migration adding the `support` role value and
the customers email index. Reversible.

## 6. API architecture

Style: the existing REST convention.
Authentication: existing session cookie.
Authorization rule: the caller must hold the `support` or `admin` role. No
object level scoping applies, because support staff are entitled to any
customer by the nature of the role. This is a deliberate widening and is the
main security decision in this document.

| Operation | Method and path | Auth | Notes |
|---|---|---|---|
| lookup | GET /api/support/customers?email= | support or admin | exact match |

Error contract: the existing `{ error, message }` shape.
Pagination: none, fixed at ten orders.
Filtering and sorting: none. The only parameter is the email, validated as an
address.
Idempotency: not applicable, read only.

## 7. Frontend architecture

Routing: one route, `/support/customers`, inside the existing authenticated
layout.
Components: existing design system, no new component.
State placement: the searched email lives in the URL, so a support agent can
share a link to a lookup during an escalation.
Data fetching: the existing pattern.
Forms: one input, existing form component.
The five states: skeleton, no customer found, customer with no orders, request
failed, results. The two empty states are distinct and both are specified.
Responsive: inherited, desktop only in practice.
Accessibility target: the existing project target, verified by keyboard pass
and the automated scan already in CI.

## 8. Security architecture

Threat model:
- Who: an internal account without the support role, or a compromised one.
- For what: bulk customer email and order history.
- What stops them: role check on the server, VPN, and rate limiting, since a
  lookup endpoint keyed by email is an enumeration tool by design.

| Control | Decision |
|---|---|
| Authentication | existing sessions, unchanged |
| Authorization | server side role check in the handler |
| Input validation | email parsed as an address, maximum 254 characters |
| Rate limiting | 60 lookups per hour per user, on the existing Redis |
| Secret handling | no new secret |
| Data protection | the response carries no payment data and no password hash |
| Audit | each lookup writes an audit row: who looked up whom, and when |

The audit row is not in the requirements. It is proposed because a tool that
lets staff read any customer's history without a trace is the kind of thing
that is discovered during an incident. It costs one table and one insert. The
user can decline it at the gate.

## 9. DevOps architecture

| Concern | Decision |
|---|---|
| Environments | existing local, staging, production |
| Local development | unchanged |
| CI | existing pipeline, no new step |
| CD | existing |
| Deployment | existing internal deploy |
| Secret delivery | none needed |
| Migration execution | existing migration step, runs before the code deploy |
| Backups | unchanged |
| Monitoring | existing logger; the audit table gives a second view |
| Rollback | revert and redeploy, six minutes |

Rollback does not restore: audit rows written during the window, which is
correct, they should survive.

## 10. Risks

| Risk | Likelihood | Impact | Mitigation | Trigger to revisit |
|---|---|---|---|---|
| the role becomes a broad read of customer data | medium | moderate | audit table, rate limit | if a second team asks for the role |
| exact match frustrates agents with partial emails | medium | low | the answer to Q2 was explicit | if agents report it |

## 11. Assumptions still in force

| # | Assumption | If wrong | Cost to change |
|---|---|---|---|
| A1 | ten orders is enough | pagination needed | cheap, one parameter |
| A2 | order headers, not contents | a join and a permissions question | moderate |

## 12. Out of scope

- editing anything
- customer support notes or ticket history
- exporting results
- searching by name, phone or order number
````

## Why this works at one page

Nine sections, all present, none padded. Six of the ten system rows say `none`
with a reason, which is the honest description of a feature that adds one page
to an existing application.

Two things in this proposal would not have appeared in an implementation that
skipped the phase: the audit table, and the observation that a support role is
a deliberate authorization widening. Both are visible to the person approving
it, in a document they will read in three minutes.
