---
name: technical-writing
description: Produces standalone technical and developer deliverables: architecture documents, API and integration references, implementation, installation and configuration guides, operational and maintenance documentation, process documents and troubleshooting guides. For a technically competent reader who is not the author. Use when the document is handed to someone rather than living in a codebase.
license: MIT
metadata:
  category: documentation
  version: 1.0.0
  depends_on: [document-core]
  outputs: [technical-document, verification-log, gap-list]
---

# Technical Writing

For readers who can read code, run commands and diagnose a failure, and who
have never seen this system.

Governed by `document-core`. This skill adds what technical deliverables need
beyond the constitution: the document types and their required shapes, the
verification discipline, and the failure modes specific to writing for
engineers.

## 1. When this skill owns the work

| Document | Owner |
|---|---|
| Repository readme, maintained with the code | `technical-documentation` |
| API reference generated from routes in the repository | `technical-documentation` |
| Runbook committed next to the service | `technical-documentation` |
| Integration guide handed to a partner | this skill |
| Architecture document delivered to a client | this skill |
| Installation guide for an operator outside the team | this skill |
| Process document for an organisation | this skill |
| Troubleshooting guide for a support or ops team | this skill |
| Migration or upgrade guide | this skill |

The test is ownership, not subject. If the document is invalidated by a commit
and should change in that commit, it belongs in the repository and to
`technical-documentation`. If it is a versioned artefact delivered to someone,
it belongs here.

## 2. Document types and their required shape

Each type has a shape. Deviating is allowed; deviating without noticing is
what produces documents nobody can use.

### Architecture document

```
Purpose and scope, including what this does not cover
Context: what exists around the system and what it depends on
Model: the components, their responsibilities, their boundaries
Data: what is stored, where, who owns it, what it costs to lose
Interactions: the flows that matter, one diagram each
Decisions: what was chosen, what was rejected, why, what it costs
Failure: what happens when each dependency is unavailable
Constraints and limits: the numbers, with their source
Open questions
```

The decisions section is what makes it worth writing. An architecture document
that describes the shape without the reasoning is a diagram with paragraphs,
and the next engineer will change something load bearing because nothing
recorded why it was load bearing.

### API and integration reference

```
Authentication, complete, with a working example
Base URL and versioning
Conventions: identifiers, pagination, dates, errors, idempotency, rate limits
One entry per operation, identical shape:
    what it does, in one line
    request: method, path, parameters with types and constraints
    response: shape, with a real example
    errors: every status this returns, and what the caller does about each
    notes: side effects, limits, ordering guarantees
Webhooks: payload, signature verification, retry policy, ordering
Changelog
```

Every example is a real request and a real response, captured by running it.
Invented payloads are the single most damaging thing in an API document,
because they are trusted absolutely and fail only in the caller's production.

Errors are documented as thoroughly as successes. The success case is the part
the reader will discover on their own.

### Installation and configuration guide

```
What you will end up with, and how you will know
Prerequisites: versions, access, credentials needed, checked in advance
Procedure: numbered, one action per step, observable result per step
Configuration reference: every variable, its meaning, required or optional,
    default, and the effect of getting it wrong. Never its value.
Verification: the commands that prove it works, with expected output
Common failures: symptom, cause, fix
Uninstall or rollback, or a statement that there is none
```

Every command is run on a clean environment before it is written. A guide
written from memory of a machine that was already configured is wrong in
exactly the places that matter.

### Operational and maintenance documentation

```
What this service does, in three lines
Where it runs, and how to reach it
Health: what to check, what the healthy values are
Alerts: each one, what it means, first command, escalation threshold
Routine maintenance: what, when, how long, who is affected
Incident procedures: symptom, diagnosis, mitigation, resolution
Backups: what, where, retention, and when a restore was last tested
Dependencies: what breaks this, and what this breaks
Contacts and escalation
```

Written for someone woken at 3am. The first command comes before the
explanation. Every threshold is a number, never `high` or `unusual`.

### Troubleshooting guide

```
Indexed by symptom, in the words of whoever reports it
Per entry: symptom, how to confirm it is this and not something similar,
    cause, resolution, and when to escalate instead
```

Indexing by component is the classic mistake: the person with the problem does
not know which component it is. That is the problem.

### Process document

```
Purpose, and what triggers this process
Roles, and who decides what
Steps, with owner and input and output per step
Decision points, with the criteria
Exceptions, and who may authorise them
Artefacts produced
```

## 3. Verification discipline

`document-core` section 5 forbids inventing facts. Here is what that means in
practice, and it is not optional.

| Element | Verified by |
|---|---|
| A command | running it, on a clean environment, and pasting the real output |
| A path or filename | listing it |
| An endpoint, payload or status code | calling it |
| A configuration variable | finding where the code reads it |
| A default value | finding it in the code, not in another document |
| A version or compatibility claim | the manifest, the lockfile, or the vendor |
| A limit or threshold | the configuration or the measurement, with the date |
| A diagram | tracing the actual call path |

Keep the log. It is what makes the document maintainable by someone else.

```markdown
| Claim | Verified by | Date | Result |
|---|---|---|---|
| `pnpm migrate` applies pending migrations | ran on a clean database | 2026-08-04 | 11 applied, output pasted |
| `GET /invoices` returns 404 for unknown ids | called with an unknown id | 2026-08-04 | returns 200 with an empty object; corrected and defect raised |
```

Verification routinely finds defects. That is a feature: a claim that cannot
be verified is either a documentation gap or a bug, and both are worth
knowing.

## 4. Writing for engineers

Failures specific to this audience, each with the fix.

| Failure | What it looks like | Fix |
|---|---|---|
| Curse of knowledge | a step that is obvious to you and undefined to them | have someone unfamiliar follow it, or follow it yourself on a clean machine |
| Explaining before showing | four paragraphs of context before the first command | working example first, explanation after |
| Documenting the happy path only | no failure modes, no limits, no error responses | one failure per success documented |
| Synonym drift | invoice, bill and charge for the same object | one term per concept, fixed in a glossary, enforced by search |
| Version drift | a command that changed two releases ago | a date and a version on the document, and a verification pass per release |
| Diagrams that show shape only | boxes with no direction, no failure, no data | annotate every arrow with what flows and what happens if it does not |
| False reassurance | simply, just, easily | delete the word; if the step is hard, say what makes it hard |
| Screenshots as instructions | a picture of a form with no field names | name the fields in text; the screenshot supports, it does not carry |

Two habits worth more than the rest:

- **Show the failure.** Documenting what a wrong configuration produces saves
  more time than documenting what a correct one produces, because the reader
  arrives with the wrong one.
- **Answer the second question.** The reader asks how to do X. They will
  immediately ask what happens when X fails, whether X is reversible, and
  whether X is safe to repeat. Answer all three where you answer the first.

## 5. Diagrams

A diagram earns its place when it shows something a paragraph cannot: a
topology, a sequence with concurrency, a state machine, a boundary.

Rules:

- Every arrow is labelled with what flows along it.
- Every boundary that matters is drawn: trust, network, ownership, transaction.
- Failure is shown, not implied. A diagram of the happy path is half a diagram.
- The diagram and the text never contradict each other. When they do, the text
  is what gets read, and the diagram is what gets believed.
- Prefer text-based diagram sources so a diff shows what changed.

## 6. Protocol

1. Load `document-core`. Build the audience profile and set the output
   language.
2. Confirm this skill owns the document, with section 1.
3. Choose the type and its shape from section 2.
4. Inventory the source material. Separate what is verified from what is
   assumed.
5. Verify every claim, per section 3. Keep the log. Raise the defects
   verification finds.
6. Mark unverifiable essential facts as gaps, with an owner. Never fill them.
7. Write the shape first, headings only, and confirm the reader's first
   question is answered above the fold.
8. Write, applying `document-core` section 6.
9. Have the procedures followed on a clean environment, by someone who did not
   write them where possible.
10. Run the eight-point gate. Add 9 to 11 if the deliverable is paginated.
11. Deliver with the verification log, the gap list, the owner and the
    invalidation trigger.

## 7. Auto-critique

Score 0 to 5: audience correct, type shape respected, every command run, every
example real, failure modes documented, terminology uniform, the reader's
first question answered first, diagrams labelled and consistent with the text,
gaps marked rather than invented, verification log complete.

Threshold: no axis below 3, average at least 4. For a document leaving the
organisation, average at least 4.3.

Automatic failure: an unrun command, an invented payload or default, a
procedure never followed end to end, or a version claim taken from another
document rather than from a manifest.

## 8. Interfaces

- Upstream: `document-core`, `project-brief`, `project-exploration`,
  `architecture-design`.
- Downstream: `document-design`, `pdf-production`, `self-critique`.
- Related: `technical-documentation` owns documentation inside a codebase.
  `client-handover` owns the delivery package as a whole.
