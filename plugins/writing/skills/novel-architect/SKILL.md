---
name: novel-architect
description: Builds the global architecture of a novel: premise, dramatic question, reading promises, structure and turning points, character arcs, subplots, reveal schedule, chapter by chapter outline. Use at the start of a novel, or when a manuscript in progress has lost its direction.
license: MIT
metadata:
  category: core
  version: 2.0.0
  depends_on: [writing-constitution]
  outputs: [novel-bible, master-outline, character-arcs, reveal-schedule]
---

# Novel Architect

Owns the global construction of a novel, from premise to chapter by chapter
outline. This skill decides the shape before a single line of prose is
written.

## 1. When to use it

- At the start of a long project.
- When a manuscript in progress has lost its direction.
- Before any major restructuring decision.

## 2. Required inputs

If any of these is missing, produce it before going further.

- Premise, in one sentence.
- Genre and subgenre.
- Target length in characters or words.
- Intended readership and level of demand.
- Dominant tone, and an editorial comparison title.

## 3. Protocol

### Step 1: lock the premise

Required form: `When [inciting element], [characterised protagonist] must
[concrete objective] or [irreversible consequence], but [structural
obstacle].`

A premise is valid if it contains a measurable desire, a deadline and a
non-accidental antagonism. If it still stands with the protagonist unnamed, it
is too generic.

### Step 2: establish the reading promise

Write the three promises made to the reader in the first fifty pages: plot
promise, emotional promise, world promise. Any ending that fails to settle all
three will be felt as a betrayal, whatever its intrinsic quality.

### Step 3: formulate the dramatic question

One closed question, which the final chapter answers yes or no. For example:
`Nkusu retrouvera-t-il le nom de son père avant que la concession soit
vendue ?` Every subplot is then judged against that question.

### Step 4: choose the structure

| Structure | Recommended for | Main risk |
|---|---|---|
| Three acts | goal-driven plot | soft middle |
| Four parts | thriller, mystery | visible machinery |
| Kishotenketsu | contemplative narrative, literary fiction | absence of tension |
| Spiral | saga, cyclical return of motifs | perceived repetition |
| Frame narrative | memory, transmission, intimate investigation | loss of the main thread |
| Fractured chronology | trauma, delayed revelation | reader confusion |

The choice is written down and justified in the bible. It is not revisable
without going through `quality/story-doctor`.

### Step 5: place the turning points

Six mandatory points, positioned as a percentage of total length:

1. Opening image and initial state: 0 to 3 percent.
2. Inciting incident: 8 to 12 percent.
3. Crossing the threshold, return becomes impossible: 20 to 25 percent.
4. Midpoint, reversal of information or of the balance of power: 50 percent.
5. Collapse, the protagonist loses what they believed secured: 70 to 75
   percent.
6. Climax and resolution of the dramatic question: 88 to 96 percent.

Any deviation greater than five percentage points must be justified by the
genre.

### Step 6: build the protagonist arc

Fill in the following eight fields:

- conscious desire;
- unconscious need;
- founding wound;
- the lie the character holds as true;
- the proof of the lie inside the world of the narrative;
- the cost scene, where the lie makes them lose something;
- the choice scene, where they can abandon the lie;
- final state, winning or losing, but transformed.

The antagonist arc uses the same eight fields. An antagonist with no need of
their own is an obstacle, not a character.

### Step 7: map the subplots

Three to five subplots at most for a standard novel. Each is defined by:
carrier, objective, point of contact with the main plot, chapter of
resolution. A subplot that never alters the main plot is cut or merged.

### Step 8: build the reveal schedule

A four column table: information, character who holds it, reader informed at
chapter N, character informed at chapter M. The gap between N and M produces
either suspense or surprise. The choice is deliberate, never accidental.

### Step 9: break into chapters

Produce one line per chapter: number, provisional title, point of view, place,
internal date, dramatic function, entry value and exit value, reveal if any. A
chapter whose entry value equals its exit value is a dead chapter.

### Step 10: density check

Count chapters per act, the average number of scenes per chapter, and the
number of reversals. A central act with fewer than one reversal every five
chapters will produce a soft middle.

## 4. Deliverables

- `bible-du-roman.md`: premise, promises, structure, theme, internal rules.
- `plan-general.md`: the chapter table.
- `arcs.md`: protagonist, antagonist and secondary arcs.
- `revelations.md`: the reveal schedule.

Templates are in `resources/`, in French, since they are filled in the output
language.

## 5. Common errors

- Confusing plot with a sequence of events. A sequence is not a plot until an
  event is caused by the one before it.
- Pushing the inciting incident past chapter 4.
- Multiplying points of view to compensate for a weak protagonist.
- Writing an outline so detailed that nothing remains to be discovered in the
  writing.
- Resolving the climax with information the reader never had.

## 6. Auto-critique

Score 0 to 5: clarity of the premise, strength of the dramatic question,
structure held, causal necessity, protagonist arc, usefulness of the subplots,
handling of reveals, density of the central act, originality, promise kept.

Threshold: no axis below 3, average at least 3.8. Below that, return to the
step concerned before writing any prose.

## 7. Interfaces

- Upstream: `research-director`, `world-builder`, `character-psychologist`.
- Downstream: `timeline-manager`, `chapter-architect`, `saga-architect`.
- Review: `quality/story-doctor`.
