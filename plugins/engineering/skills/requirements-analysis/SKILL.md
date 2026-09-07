---
name: requirements-analysis
description: Turns a specification, brief, PRD, feature list, mockup or client request into an implementable engineering specification, separating explicit requirements, assumptions, constraints and unknowns without ever inventing a requirement. Run first on any project input.
license: MIT
metadata:
  category: delivery-skills
  version: 1.0.0
  depends_on: [engineering-core]
  outputs: [engineering-specification, assumption-register, unknown-register, scope-boundary]
---

# Requirements Analysis

Converts what a person wrote into what an engineer can build, without adding
anything they did not say.

The output is not a summary. It is a specification with four separated
registers: what was stated, what is being assumed, what constrains the work,
and what nobody knows yet.

## 1. The separation rule

Four registers, never merged, never silently promoted.

| Register | Definition |
|---|---|
| Requirement | stated by the source, quotable |
| Assumption | not stated, adopted to proceed, reversible on contradiction |
| Constraint | a fact that limits the solution space |
| Unknown | cannot be determined, blocks or does not block, stated |

Promoting an assumption to a requirement without asking is the single most
expensive error in this phase. It produces a system that satisfies a
specification nobody wrote.

Every assumption carries: what is assumed, why it was needed, what changes if
it is wrong.

## 2. Input kinds

Each carries different silences.

| Input | Reliably present | Reliably missing |
|---|---|---|
| written specification | features, screens | error paths, permissions, limits |
| PRD | user value, success criteria | data model, non functional needs |
| feature list | scope breadth | rules, states, ownership |
| mockups or screenshots | layout, happy path | empty states, errors, validation |
| client conversation | intent, priorities | precision, edge cases |
| existing API documentation | contracts | which parts are actually implemented |
| existing repository | reality | intent, and why the code is as it is |

Mockups deserve their own warning. A mockup shows one state of one screen with
ideal data. Everything the five states cover is absent from it by
construction.

## 3. Protocol

### Step 1, read the source completely

All of it, before writing anything. Partial reads produce a specification of
the first section and assumptions about the rest.

Where an existing repository is part of the input, run `project-exploration`
first. Code is a stronger source than a document about the code.

### Step 2, extract the product frame

```
Objective        what changes for the business when this exists
Users            each distinct kind of person who touches it
Roles            what each may do, in one line
Workflows        the primary paths, named
Value            why this is worth building
Success          how anyone will know it worked
```

Roles are the field most often left implicit and most expensive to get wrong.
A specification that says users without distinguishing them is hiding an
authorization model.

### Step 3, extract functional requirements

Per feature:

```
Name
Trigger        what starts it
Actor          which role
Preconditions  what must be true
Behaviour      what the system does
Rules          the business rules that constrain it
States         the states an entity moves through, and legal transitions
Effects        what changes in storage, what is sent, what is notified
Failure        what happens when it does not work
Permissions    who may do it, who may see the result
```

The last three lines are almost never in the source and almost always needed.
Their absence is recorded as an unknown or resolved by an assumption, never
skipped.

### Step 4, extract non functional requirements

Only those the project actually has. Inventing a scalability requirement for
an internal tool with fifty users is as wrong as ignoring one for a public
service.

```
Security        authentication model, data sensitivity, regulated data
Performance     expected volumes, acceptable latency, growth rate
Availability    what downtime costs, whether that implies anything
Scalability     the real numbers, or an explicit not a concern
Accessibility   the target level, and whether it is contractual
Localisation    languages, currencies, timezones, formats
Observability   who operates this and what they need to see
Maintainability who takes it over after delivery
Compliance      only when the source names a regime that applies
```

Each line is a number, a name or an explicit `not a concern for this
project`. A table of aspirations helps nobody.

### Step 5, extract constraints

```
Existing systems       what must be integrated with, and its real contract
Imposed technology     what the client requires, with the reason if given
Existing data          what already exists and cannot be reshaped freely
Hosting                where this must run
Budget                 recurring cost limits, if stated
Timeline               the date, and what it is tied to
Team                   who maintains this afterwards
```

### Step 6, draw the scope boundary

Two lists, both explicit.

```
In scope     what will be built
Out of scope what will not, including things a reader might reasonably expect
```

The out of scope list is the more useful one. It is where the disagreement
surfaces now, at the cost of a sentence, instead of at delivery.

### Step 7, register the unknowns

Each unknown carries: what is missing, what it blocks, and whether an
assumption can carry the work forward.

```
Blocking      architecture or implementation cannot proceed correctly
Non blocking  an assumption is recorded, work continues, revisit later
```

Blocking unknowns go to `clarification-gate`. Non blocking ones go to the
assumption register and stay visible.

## 4. Requirement quality

A requirement that cannot be tested cannot be built. Rewrite each one until it
can.

| Unusable | Usable |
|---|---|
| the system must be fast | a search returns in under 500ms at 100k rows |
| the interface must be intuitive | a new user completes onboarding without help, measured on 5 people |
| it must be secure | only the owner and an administrator may read an order |
| it must scale | 500 concurrent users, 2M rows in the largest table |
| users can manage their data | a user can export, correct and delete their profile data |
| the app must be reliable | a failed payment never leaves an order in `paid` |

The rewrite is proposed, not imposed. Where the rewrite changes meaning, it
becomes a clarification question.

## 5. Prohibitions

- Never invent a requirement that the source does not support.
- Never record an assumption as a requirement.
- Never drop a stated requirement because it is inconvenient.
- Never resolve a contradiction silently; a contradiction is a question.
- Never infer a non functional requirement from the technology.
- Never treat a mockup as a complete state specification.
- Never let a feature list stand in for its business rules.
- Never produce a specification longer than the thing it specifies.

## 6. Deliverable

```
Product        objective, users, roles, workflows, value, success criteria
Functional     one block per feature, section 3 step 3
Non functional only the applicable lines, each with a number or a name
Constraints    existing systems, imposed technology, data, hosting, budget
In scope       the list
Out of scope   the list
Assumptions    what, why, what changes if wrong
Unknowns       what, what it blocks, blocking or not
```

## 7. Auto-critique

Score from 0 to 5: source read completely, four registers genuinely separated,
roles and permissions extracted rather than assumed, failure paths present per
feature, non functional lines carrying real numbers, out of scope list
populated, unknowns named precisely, requirements testable.

Threshold: no axis below 3, average at least 4. An assumption presented as a
requirement is an automatic failure, because everything downstream inherits
it.

## 8. Interfaces

- Upstream: `delivery-orchestrator`, `project-exploration` when a repository
  is part of the input.
- Downstream: `clarification-gate` for the blocking unknowns,
  `technology-selection` and `architecture-proposal` for the specification.
- Related: `scope-and-change-control` owns the scope boundary after approval.
