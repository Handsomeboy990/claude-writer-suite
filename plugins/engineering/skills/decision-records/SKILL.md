---
name: decision-records
description: Records an architectural or technical decision so that the reasoning survives the people: context, the forces, the options actually considered, the choice, the consequences accepted and what would reverse it. Keeps records immutable and supersedes rather than edits. Use whenever a decision is expensive to reverse, will surprise a newcomer, or has already been argued about twice.
license: MIT
metadata:
  category: dev-skills
  version: 1.0.0
  depends_on: [engineering-core]
  outputs: [decision-record, decision-index, superseding-records]
---

# Decision Records

Code says what the system does. A decision record says why it does it that
way, and what was rejected. Without it, every unusual choice gets
re-litigated, or worse, quietly undone by someone who assumed it was an
accident.

A record is cheap. A record is one page, written once, never edited.

## 1. What deserves a record

```
yes   a choice that is expensive to reverse: storage, protocol, boundary,
      authentication mechanism, deployment model
yes   a choice that will surprise a competent newcomer
yes   a rejection: the obvious option that was considered and refused
yes   a deliberate constraint: no framework here, no shared database, this
      service owns this data
yes   an argument that happened twice
no    a choice with one reasonable option
no    a naming convention, unless it caused a conflict
no    a change of implementation with no visible consequence
```

If nobody would ask `why is it like this`, there is nothing to record.

## 2. Structure

```
Title        a short declarative sentence, not a question
Status       proposed | accepted | superseded by <id> | rejected
Date         when the decision was taken
Deciders     the roles that decided, not a list of personal names
Context      what was true when the decision was made: constraints, scale,
             team, deadlines, what already existed
Forces       what pulled in different directions
Options      each one considered, with what it would have cost
Decision     what was chosen, stated in one sentence
Consequences what becomes easy, what becomes hard, what is now committed to
Reversal     what would make this wrong, and what reversing it would cost
```

The two sections people skip are the ones with the most value later:
`Consequences` and `Reversal`. The first prevents surprise, the second tells a
future team whether they may change their mind cheaply.

## 3. Options are recorded honestly

An options section listing one real candidate and two straw men is worse than
no record, because it forecloses a genuine reconsideration later.

```
for each option: what it does well, what it costs, why it was not chosen
including the option that was almost chosen, and by how little
including do nothing, when that was a real candidate
```

## 4. Immutability

```
a record is never edited after acceptance, except to fix a typo
a changed mind produces a new record that supersedes the old one
the old record's status becomes superseded, with the identifier of the new one
the new record explains what changed in the world, not that the old team was
  wrong
```

Editing a record destroys the only artefact that captures what was true at the
time, and makes every other record untrustworthy.

## 5. Location and format

```
in the repository, next to the code it governs, in version control
plain text or markdown, numbered, in one directory
one file per decision, named with its number and a slug
an index listing every record, its status and its title
linked from the architecture documentation, not duplicated into it
```

A record that lives in a wiki nobody has access to has failed at its only job.

## 6. Writing it at the right time

```
before   for a decision that needs agreement: write it as proposed, circulate
         it, then mark it accepted
during   for a decision discovered while implementing, written the same day
after    acceptable only for an inherited decision being documented
never    six months later from memory, which produces a justification rather
         than a record
```

An archaeological record is still worth writing, and it is labelled as one:
`reconstructed from the code and the history, the original reasoning is not
known`.

## 7. Prohibitions

- Never edit an accepted record to match a new decision.
- Never record a decision nobody made, to legitimise an accident after the
  fact, without labelling it as reconstructed.
- Never omit the option that was nearly chosen.
- Never write consequences that are all positive; if there are none negative,
  the decision was not a decision.
- Never use a record as a design document; it records a choice, not a plan.
- Never name individuals in a way that turns a record into a blame artefact.

## 8. Protocol

1. Confirm the decision meets the bar in section 1.
2. Write the context as it is today, without hindsight.
3. List the options actually considered, each with its cost.
4. State the decision in one sentence.
5. Write the consequences, including the ones that hurt.
6. Write what would reverse it and what that would cost.
7. Circulate as proposed when agreement is needed; otherwise mark accepted.
8. Add it to the index and link it from the architecture documentation.
9. When the decision changes, write a new record and mark the old superseded.

## 9. Auto-critique

Score from 0 to 5: the decision deserved a record, context written without
hindsight, options honest including the near miss, decision stated in one
sentence, negative consequences present, reversal cost stated, immutability
respected, discoverability from the code.

Threshold: no axis below 3, average at least 4. A record with no negative
consequence and no rejected option is a press release and is rewritten.

## 10. Interfaces

- Upstream: `architecture-design`, `architecture-proposal`,
  `technology-selection`, `dependency-selection`, `migration-engineering`.
- Lateral: `technical-debt` for deliberate debt records,
  `scope-and-change-control` when a decision changes an approved design.
- Downstream: `technical-documentation` for the link from the architecture
  documents, `project-continuity` and `client-handover` for the index.
