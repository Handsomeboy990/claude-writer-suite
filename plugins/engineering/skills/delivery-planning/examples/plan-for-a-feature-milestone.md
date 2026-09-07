# Example: two plans for the same project

Project: the training platform, after approval. Four features, one role model,
one attestation generator.

## Plan A, horizontal, and why it fails

```
M1  All database tables
M2  All backend services
M3  All API endpoints
M4  All frontend pages
M5  Testing
M6  Deployment
```

It looks orderly and it is a common shape. Four problems, all of which surface
late.

**Nothing is demonstrable until M4.** The client sees nothing for three
quarters of the project, then sees everything at once, which is exactly when
their feedback is most expensive to act on.

**Integration problems arrive in M4.** Every mismatch between what the API
returns and what a page needs is discovered after both are written, when the
fix is a change on both sides plus a contract renegotiation.

**M5 is where the project fails.** Testing as a milestone means the first
integration test runs against six weeks of untested code. Every failure has
six weeks of candidate causes.

**Nothing can be cut.** At week ten, if the deadline is at risk, there is no
finished feature to ship. There are four half features spread across four
layers.

## Plan B, vertical

```
M0  Foundation      repo, tooling, CI skeleton, one deployable hello page
M1  Data and identity
      users, roles, sessions, the two migrations
      demonstrable: a trainer can sign in and sees an empty dashboard
M2  Courses, end to end
      table, service, endpoints, list and detail pages, tests
      demonstrable: a trainer publishes a course, a trainee sees it
M3  Enrolment and following, end to end
      demonstrable: a trainee enrols, reads pages, progress is recorded
M4  Attestation, end to end
      demonstrable: a trainee completes a course and downloads a PDF
M5  Administration tracking, end to end
      demonstrable: administration sees who completed what
M6  Hardening       security, accessibility, performance passes
M7  Operations      environments, pipeline, deployment, observability
M8  Delivery        documentation, handover
```

Each milestone from M1 ends in something the client can watch happen. The
integration problems appear inside each milestone, where they involve two
files rather than a codebase.

If week ten arrives and the deadline is at risk, M0 to M3 is a working product
that is missing attestations. That is a conversation. Plan A at week ten is
not.

## M2 broken into tasks

```
T10  Courses table and migration
     Depends on: T04 users table
     Modules: migrations/, db/schema
     Tests: migration applies and rolls back on a copy of the seed data
     Done when: the schema matches architecture section 5 and rolls back

T11  Course contract
     Objective: the request and response shapes for course operations exist as
       one shared definition
     Depends on: T10
     Modules: lib/contracts/courses
     Done when: both the service and the future page import the same shapes
     Note: this is the contract task that makes T13 and T15 parallel safe

T12  Course service, publication rules
     Depends on: T10, T11
     Implements: create, update, publish; R3 a course cannot be published
       without at least one page; R4 publication is direct, per the answer to
       U2
     Authorizes: only the owning trainer, or an administrator
     Tests: publish with no page rejected; publish by another trainer 403;
       update after publication allowed per R5
     Done when: service tests pass

T13  Course endpoints
     Depends on: T11, T12
     Parallel with: T15
     Validates: title (1 to 200), description (max 5000), page bodies
     Tests: 201, 400 per field, 401, 403, 404, and the publish rule
     Done when: contract tests pass against architecture section 6

T15  Course list and detail pages
     Depends on: T11, T08 layout
     Parallel with: T13
     Implements: list with the five states, detail with the page reader
     Tests: component tests for loading, empty, error, populated
     Done when: pages render against a stubbed contract, keyboard navigable

T16  Course journey test
     Depends on: T13, T15
     Parallel with: nothing
     Tests: trainer publishes, trainee sees it, unpublished course not visible
     Done when: passes twice consecutively

T17  Course documentation
     Depends on: T13
     Done when: the endpoint reference matches the implemented handlers
```

Seven tasks, one milestone, one demonstrable outcome.

## The parallelisation map for M2

```
| Task | May run with | Must wait for |
|---|---|---|
| T10 | nothing | T04 |
| T11 | nothing | T10 |
| T12 | nothing | T10, T11 |
| T13 | T15 | T11, T12 |
| T15 | T13 | T11, T08 |
| T16 | nothing | T13, T15 |
| T17 | T16 | T13 |
```

T11 is the reason T13 and T15 can run at the same time. Without it, the page
would be built against an imagined response shape and the two would be
reconciled at T16, which is the exact failure Plan A produces at the scale of
the whole project.

## Coverage check on M2

```
R2 trainers publish courses      -> T12, T13, T15   covered
R3 minimum one page to publish   -> T12             covered
R5 edit after publication        -> T12             covered
U2 direct publication, no review -> T12             covered, assumption A6

Tasks serving no requirement:    none
Tasks changing behaviour with no named tests: none
Parallel pairs without a contract task: none
```

Four lines that take a minute and catch the two plan defects that are
otherwise found halfway through implementation: a requirement nobody planned
for, and two people building against different assumptions.
