# Task template

One block per task. Referenced by identifier from commits, the checklist and
the parallelisation map.

````markdown
### T21 Invitation endpoint

Objective:    an administrator can create a team invitation over HTTP
Requirement:  F4, architecture section 6
Depends on:   T14 invitation contract, T18 invitations table, T09 session guard
Modules:      app/api/teams/[id]/invitations/, lib/services/invitations.ts
Implements:
  - POST handler in the mandatory order from backend-engineering section 2
  - service with the expiry, quota and duplicate rules R11 to R14
  - token generated with a cryptographic source, stored hashed, never returned
Validates:    email (trimmed, lowercased, max 254), role (enum), teamId (uuid)
Authorizes:   caller must be an administrator of the team named in the path
Tests:
  - 201 with the declared shape, token absent
  - 401 unauthenticated, 403 non administrator, 404 unknown team
  - 409 duplicate pending, 409 already a member, 402 seat limit
  - two concurrent identical requests produce one row
Done when:    the contract test file passes and the response matches the
              architecture section 6 shape
Estimate:     half a day to a day; the range is the concurrency handling
````

## Sizing rules

**Too large**, split it:

```
T7 Build the invitation feature
```

Six files, three layers, a migration and a UI. Cannot be reviewed as one
change, cannot be reverted cleanly, and its `Done when` is a paragraph.

**Too small**, merge it:

```
T7a Create the invitations file
T7b Add the imports
```

Not a unit of work. The commit for it says nothing.

**Right sized**:

```
T18 Invitations table and partial unique index
T19 Invitation service, expiry and quota rules
T21 Invitation endpoint
T22 Invitation dialog
T23 Invitation journey test
```

Each is one commit, one review, one revert.

## The fields that get skipped

**Depends on.** Written as identifiers, not prose. `Depends on: the database
being ready` cannot be checked by anything. `Depends on: T18` can.

**Validates and Authorizes.** Present on every task that accepts external
input or returns scoped data. Their absence on such a task is how endpoints
ship without an ownership check, then get found by `security-audit` a week
later.

**Tests.** Named cases, not `add tests`. The named list is what stops the test
pass from covering only the happy path.

**Done when.** An observable condition. Not `the endpoint is implemented`, but
what someone else could check.

## Milestone block

````markdown
## M6a Team invitations, end to end

Demonstrates: an administrator invites a member, the member accepts, and
appears in the team

Tasks:  T14, T18, T19, T21, T22, T23, T24
Depends on: M2 identity, M5 frontend base
Parallel:  T21 with T22 after T14; everything else sequential
Risk:      the mail provider sandbox is not available in staging, so T24
           delivery verification is stubbed and recorded as a gap
Done when: the journey test passes twice consecutively and the feature is
           reachable from the team page
````

The `Demonstrates` line is the test of a milestone. If it cannot be written as
something a person could watch happen, the milestone is a grouping of tasks
rather than a milestone.

## Coverage check

Before the plan is considered complete:

```
For each requirement in the architecture requirements mapping:
  at least one task serves it            -> otherwise the plan has a hole
For each task:
  it serves at least one requirement     -> otherwise it is unrequested work
For each task changing behaviour:
  it names its tests                     -> otherwise the test pass is optional
For each pair of parallel tasks:
  a contract task precedes both          -> otherwise they will conflict
```

Four checks, run once, on a table. They catch the plan defects that are
otherwise discovered during implementation.
