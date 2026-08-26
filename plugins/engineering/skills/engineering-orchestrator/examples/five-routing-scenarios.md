# Example: five requests, five plans

Each block shows the classification, the plan actually composed, and what was
dropped with its reason. These five scenarios are the ones asserted by
`tests/validate-orchestration.sh`.

## A. Fix a bug in an existing API

```
Request:  the /api/orders endpoint returns 500 for orders without a coupon
Category: DEBUGGING, secondary BACKEND
Surface:  apps/api, orders module
Plan:
  1 project-exploration L2, orders slice
  2 debugging, locate the null dereference
  3 backend-engineering, fix
  4 testing-quality, regression test for the coupon absent case
  5 code-review-protocol
  6 technical-documentation, only if the response contract changed
  7 project-continuity
  8 git-workflow
Dropped:
  architecture-design, change confined to one handler
  security-audit, no new input, no authorization surface
  playwright-automation, no browser surface
  performance-engineering, no measurement and no symptom
```

The plan is eight steps and two of them are cheap. Adding a security audit
here would be theatre; adding the regression test is not optional, because
without it the same null path returns next quarter.

## B. Create a new dashboard page

```
Request:  add a dashboard page showing the user metrics
Category: FRONTEND, secondary UI_UX, VALIDATION
Surface:  apps/web, app/dashboard
Plan:
  1 project-exploration L2, layout, design tokens, data access pattern
  2 ui-ux-engineering, hierarchy, states, responsive and accessibility targets
  3 frontend-engineering, implementation with loading, empty and error states
  4 input-validation, the date range filter parsed server side
  5 testing-quality, component tests for the three states
  6 playwright-automation, journey plus responsive screenshots
  7 performance-engineering, list rendering and payload size
  8 code-review-protocol
  9 technical-documentation
  10 project-continuity
  11 git-workflow
Dropped:
  architecture-design, no new boundary
  security-audit, no new authorization surface beyond the existing session
    guard, which was verified rather than assumed
```

Note the fourth step. A dashboard looks like pure frontend until a filter
value reaches a query, at which point validation becomes mandatory.

## C. Add a payment endpoint

```
Request:  add an endpoint that charges a saved card
Category: BACKEND, secondary API, SECURITY, VALIDATION
Surface:  apps/api, payments module
Plan:
  1 project-exploration L3, payments, auth, existing Stripe integration
  2 architecture-design, transaction boundary, idempotency, failure states
  3 backend-engineering, handler and service
  4 input-validation, body, amount, currency, idempotency key
  5 security-audit, authorization, amount authority, replay, webhook trust
  6 testing-quality, happy path, duplicate submission, declined card,
    provider timeout, forbidden access
  7 performance-engineering, external call timeout and retry budget
  8 code-review-protocol
  9 technical-documentation, api reference and runbook
  10 project-continuity
  11 git-workflow
Dropped:
  ui-ux-engineering, no visual surface
  playwright-automation, no browser flow in this change
```

The business logic verification requested for payment work lives in step 5 and
step 6: the amount is never taken from the client, and the duplicate
submission case is a required test, not an extra one.

## D. Review the authentication system

```
Request:  review the authentication system
Category: SECURITY, secondary AUTHENTICATION
Surface:  apps/api lib/auth, apps/web middleware
Plan:
  1 project-exploration L3, auth map and boundary map
  2 security-audit, the twenty four point sweep
  3 code-review-protocol, the files the audit flagged
  4 testing-quality, tests that encode each fixed finding
  5 technical-documentation, threat model and decisions
  6 project-continuity
  7 git-workflow
Dropped:
  debugging, no reported defect
  performance-engineering, not requested and no symptom
```

A review that only lists findings has done half the job. Steps 3 and 4 are
what turn findings into fixed, tested behaviour.

## E. Build a complete feature

```
Request:  build team invitations end to end
Category: FULLSTACK
Surface:  apps/web, apps/api, database
Plan:
  1 project-exploration L3
  2 architecture-design, invitation lifecycle, token model, expiry
  3 fullstack-engineering, owns the contract across layers
  4 backend-engineering, endpoints, service, migration
  5 ui-ux-engineering, states and accessibility of the two new screens
  6 frontend-engineering, invite form, pending list, accept page
  7 input-validation, email, role, token, both boundaries
  8 security-audit, token entropy, single use, role escalation, enumeration
  9 testing-quality, unit, integration, negative and boundary cases
  10 playwright-automation, invite then accept journey
  11 performance-engineering, list query and index
  12 code-review-protocol
  13 technical-documentation
  14 project-continuity
  15 git-workflow, one commit per layer
  16 release-readiness
Dropped:
  dependency-selection, no new library, the existing mailer covers sending
```

Sixteen steps for a real feature is not bureaucracy. The compression is in
each step, not in the count: several of them are minutes of work.

## Counter example, a plan that fails review

```
Request:  fix a typo in the footer copyright year
Plan:     project-exploration L3 -> architecture-design -> frontend-engineering
          -> input-validation -> security-audit -> testing-quality
          -> playwright-automation -> performance-engineering
          -> code-review-protocol -> technical-documentation
          -> project-continuity -> git-workflow -> release-readiness
```

Wrong. The correct plan is: read the file, change the string, run the existing
check, commit. Section 5 of the orchestrator exists to prevent exactly this,
and section 10 detects the drift when it becomes habitual.
