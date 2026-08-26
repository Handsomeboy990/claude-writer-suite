---
name: chapter-architect
description: Breaks a novel into chapters: dramatic function, entry and exit values, openings and closings, length, point of view alternation, worked titles. Use to organise chapters, decide where to cut, or find titles that are not generic.
license: MIT
metadata:
  category: core
  version: 2.0.0
  depends_on: [writing-constitution, novel-architect]
  outputs: [chapter-breakdown, chapter-sheet, chapter-titles]
---

# Chapter Architect

Turns a master outline into playable chapters: breakdown, function, entry,
exit, length, point of view alternation, titles.

## 1. Working definition

A chapter is a complete unit of tension. It begins with an implicit question
and ends with a partial answer that opens another. A chapter that changes
neither the situation, nor the information, nor the relationship between two
characters is cut or merged.

## 2. Required inputs

- Master outline from `novel-architect`.
- Reveal schedule.
- List of permitted points of view.
- Overall length constraint.

## 3. Protocol

### Step 1: assign a single function

One dominant function per chapter. Allowing two weakens both. Functions:
setup, trigger, pursuit, obstacle, revelation, reversal, breathing space,
confrontation, collapse, resolution.

### Step 2: fix the entry and exit values

Each chapter moves a value along an axis: safety to danger, ignorance to
knowledge, bond to rupture, hope to despair, or the reverse. Record the sign:
positive, negative, or double swing.

Three consecutive chapters of the same sign are forbidden. Monotony of sign
produces a weariness the reader attributes to the prose.

### Step 3: define the entry

A chapter enters the situation as late as possible. Four reliable openings:

- in the middle of action already underway;
- on a line of dialogue that unbalances;
- on a concrete detail that contains the whole scene;
- on a movement, a body going somewhere.

Forbidden openings: waking up, weather alone, a summary of the previous
chapter, a character described in front of a mirror.

### Step 4: define the exit

Five effective exits:

1. an irreversible decision;
2. new information that reframes the whole chapter;
3. the arrival of something unplanned;
4. a question asked and not answered;
5. an image that extends the emotion without comment.

The exit must not be a mechanical cliffhanger repeated at every chapter.
Beyond one chapter in three, the effect cancels itself and becomes
predictable.

### Step 5: calibrate the length

- Literary novel: 2500 to 5000 words per chapter.
- Thriller, crime: 1200 to 2500 words, frequent cuts.
- Fantasy and science fiction: 3000 to 6000 words, with short chapters
  alternating to avoid descriptive satiety.

Vary length with tension: the higher the tension, the shorter the chapters.
Length is an instrument of rhythm, not a standard.

### Step 6: organise point of view alternation

- One point of view per chapter, unless an omniscient narration is chosen
  deliberately and declared in the bible.
- Do not introduce a new point of view after the first third of the novel
  without structural necessity.
- A point of view used fewer than three times is a point of view to remove.
- Regular alternation reassures; alternation broken at the right moment
  unsettles. Break it deliberately at the threshold and at the collapse.

### Step 7: write the title

Apply section 5 of the constitution. Three passes:

1. write ten titles without filtering;
2. eliminate those that summarise, those that give away, and those that would
   suit another chapter equally well;
3. keep the one that takes a second meaning after reading.

Then check the full table of contents: read in sequence, it must form a
progression, almost a poem, never a list of labels.

### Step 8: break into scenes

Two to four scenes per chapter. Each scene is then handled by `scene-builder`.
A single-scene chapter is reserved for turning points.

## 4. Chapter sheet

Template in `resources/fiche-chapitre.md`. Required fields: number, title,
function, point of view, place, internal date, elapsed time, entry value, exit
value, reveal, objects and clues planted, promise opened, promise closed.

## 5. Common errors

- Opening every chapter with a summary of what the reader has just read.
- Ending every chapter on a cliffhanger, which neutralises them all.
- Lining up chapters of identical length.
- Changing point of view mid-chapter with no marker.
- Writing a whole chapter to deliver a single piece of information: it belongs
  inside an existing chapter.

## 6. Auto-critique

Score 0 to 5: necessity of the chapter, strength of the entry, strength of the
exit, alternation of signs, relevance of the point of view, quality of the
title, internal rhythm, information density, absence of redundancy, promise
opened and held.

Threshold: no axis below 3, average at least 3.8.

## 7. Interfaces

- Upstream: `novel-architect`, `timeline-manager`.
- Downstream: `scene-builder`, `narrator`.
- Review: `continuity-manager`, `quality/story-doctor`.
