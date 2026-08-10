# Example: four sentences into a specification

## The source, in full

> Bonjour, nous voulons une plateforme pour que nos formateurs publient leurs
> cours en ligne. Les stagiaires s'inscrivent, suivent les cours et reçoivent
> une attestation à la fin. Il faut aussi que l'administration puisse suivre
> qui a terminé quoi. Livraison souhaitée avant la rentrée.

Four sentences. What follows is what an engineer needs, and how much of it the
source actually contains.

## What is stated, quotable

```
R1  Trainers publish courses online.
R2  Trainees enrol.
R3  Trainees follow courses.
R4  Trainees receive an attestation at the end.
R5  Administration can track who completed what.
C1  Delivery before "la rentrée".
```

Six items. That is the entire requirement set the source supports.

## Roles, extracted rather than assumed

The source names three distinct actors, which is more than most briefs of this
length give.

```
| Role | Stated | May do, per the source |
|---|---|---|
| formateur | yes | publish courses |
| stagiaire | yes | enrol, follow, receive attestation |
| administration | yes | track completions |
```

What the source does not say, and which the authorization model needs:

```
U1  Can a formateur see which stagiaires enrolled in their own course?
U2  Can administration create or edit courses, or only read?
U3  Is a formateur also able to be a stagiaire on another course?
U4  Who publishes, the formateur directly, or after review?
```

U4 is the one that changes the schema: a `published` state with a reviewer is
a different model from a `published` boolean.

## The word that hides a project

`suivent les cours` carries no engineering meaning until it is decided what
following a course consists of.

```
Possible readings, each a different product:
  a) the trainee reads pages and marks them read
  b) the trainee watches videos and progress is tracked by position
  c) the trainee completes exercises that are graded
  d) the trainee attends live sessions and attendance is recorded
```

Reading (a) is two tables. Reading (c) is a grading subsystem. Reading (d)
needs scheduling and a calendar integration. No assumption is safe here, so
this becomes the first blocking question.

Similarly, `attestation` can be a database row, a downloadable PDF, or a
signed document with a verifiable identifier. The three differ by a week of
work and by whether a legal requirement is attached.

## Non functional, with honest emptiness

```
| Area | Requirement | Source |
|---|---|---|
| Security | trainee data is personal data; access scoped per role | inferred from the domain, recorded as A3 |
| Performance | not a concern for this project | no volume stated, see U6 |
| Availability | not a concern for this project | internal training, no stated cost of downtime |
| Scalability | not a concern for this project | see U6 |
| Accessibility | unknown, may be contractual for a training body | U7 |
| Localisation | French interface | the source is in French, recorded as A4 |
| Observability | who operates this after delivery is unknown | U8 |
| Maintainability | unknown | U8 |
| Compliance | personal data of trainees; certification rules may apply | U9 |
```

Seven of nine lines are `not a concern` or an unknown. That is the correct
output for a four sentence brief. Filling them with plausible targets would
have manufactured requirements the client never asked for and will be billed
for.

## Assumptions, each with its cost

```
| # | Assumption | Why needed | If wrong |
|---|---|---|---|
| A1 | one organisation, not a multi tenant platform | decides the whole data model | a rewrite, not a change |
| A2 | courses are free, no payment | no payment mentioned | adds a payment subsystem and its compliance |
| A3 | trainee progress and results are personal data with restricted access | the domain implies it | broader access, simpler model |
| A4 | interface in French only | the brief is French | adds localisation infrastructure |
| A5 | attestation is a generated PDF, not a legally signed document | the common case | adds signing, verification and archival |
```

A1 and A2 are the two that would be catastrophic if assumed silently. Both are
listed at the top of the clarification batch even though the work could
technically proceed under the assumption, because both change the architecture
rather than a detail of it.

## The scope boundary, where the argument happens early

```
In scope
- course creation and publication by a formateur
- enrolment and course following by a stagiaire
- attestation generation on completion
- completion tracking for administration

Out of scope, and worth stating
- payments and invoicing
- live sessions, video conferencing
- forums, messaging between trainees and formateurs
- mobile applications
- SCORM or other e-learning standard import
- multi organisation tenancy
- automatic exam grading
```

The out of scope list is longer than the in scope list, and it is the more
valuable half. Every line is something a training platform plausibly has, and
that this one will not have unless the client says so now.

## The unknowns, sorted by what they block

```
Blocking, cannot design without them
U1  what does following a course consist of, readings (a) to (d)
U2  is a course published directly or after review
U3  what is an attestation, row, PDF, or signed document
U4  one organisation or several

Non blocking, assumption carries the work
U5  can a formateur enrol as a stagiaire elsewhere
U6  expected number of trainees and courses
U7  is an accessibility level contractual
U8  who operates and maintains this after delivery
U9  which certification rules apply, if any
```

Four blocking unknowns from four sentences. They go to `clarification-gate` as
one batch. The other five are recorded and revisited at the validation gate,
where the client sees them listed and can correct any that matter.

## What was not produced

No architecture. No stack. No estimate. No table of database entities. Those
come after the four blocking questions are answered, because three of the four
change the entities.

The temptation at this stage is to show progress by producing a schema. A
schema built on U1 unanswered is a schema that gets thrown away, and it
anchors everyone's thinking on the wrong reading of `suivent les cours`.
