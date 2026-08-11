---
name: adventure
description: Writes an adventure novel: the itinerary as structure, accounting for resources and attrition, demonstrated competence, a constraining territory, the rhythm of travel and halt, the mandatory return. Use for a journey, an expedition or a survival narrative.
license: MIT
metadata:
  category: genres
  version: 2.0.0
  depends_on: [writing-constitution, scene-builder, immersion-director]
  outputs: [itinerary, adventure-outline]
---

# Adventure

The adventure novel rests on movement, physical obstacle and transformation
through the journey. It is not a sequence of incidents: it is a geography that
wears people down.

## 1. Reading contract

The reader demands: a clear goal, a hostile and researched territory, concrete
skills, escalating obstacles, and a return that changes the meaning of the
departure.

## 2. Building the itinerary

The itinerary is the structure. Every stage must:

- present an obstacle of a different nature from the previous one;
- cost a resource: time, equipment, health, an ally, an illusion;
- reveal something about a character.

Three obstacles of the same nature in a row produce immediate weariness.
Alternate: natural, human, technical, moral, internal.

## 3. Resources and attrition

Keep strict accounts: food, water, ammunition, money, fuel, health, days
remaining. Adventure becomes tense when the reader can count along with the
character.

Attrition rule: what is consumed does not restore itself without a scene. A
bag that always contains what is needed destroys the tension.

## 4. Competence

- The protagonist can do precise, verifiable things. Competence is shown in
  action, never in introduction.
- They are ignorant of something else, and that ignorance must cost them at
  least once.
- Learning along the way is an engine: show the failure, then the mastery.

## 5. Territory

Apply `immersion-director` without exception. The territory is not scenery: it
imposes schedules, detours, clothing, encounters. The climate must decide at
least once in the characters' place.

The populations encountered are neither hostile by nature nor helpful by
function. They have their own affairs, into which the travellers invite
themselves.

## 6. Rhythm

- Alternate travel and halt. The halt is where dialogue and revelation happen.
- Narrate a journey only when it transforms a relationship or consumes a
  resource.
- Place the worst obstacle before the second to last stage, not at the end.
- The return, however brief, is mandatory: it measures the change.

## 7. Cliches to turn or prohibit

- The local guide who betrays.
- The incomplete map as the sole source of suspense.
- The invented tribe as an exotic obstacle.
- The treasure that solves every problem.
- The comic companion with no other function.
- The serious injury forgotten by the next chapter.

## 8. Exit checks

- Every stage costs an identifiable resource.
- No obstacle repeated in nature.
- Resource accounting is consistent from beginning to end.
- The populations encountered have objectives of their own.
- The return exists and changes the meaning of the departure.

## 9. Auto-critique

The eleven constitution axes, plus four genre axes: variety of obstacles,
consistency of attrition, territory embodied, accuracy of the skills.

Threshold: no axis below 3, average at least 4 on consistency of attrition.

## 10. Interfaces

- Upstream: `scene-builder`, `immersion-director`, `research-director`.
- Neighbours: `genres/historical-fiction`, `genres/fantasy`.
