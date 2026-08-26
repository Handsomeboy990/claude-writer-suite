---
name: narrator
description: Manages the narrating instance: person, focalisation, tense, narrative distance, free indirect speech, knowledge contract, unreliable narrator, holding a voice over length. Use to choose a point of view, correct a focalisation slip, or stabilise a voice across a long manuscript.
license: MIT
metadata:
  category: core
  version: 2.0.0
  depends_on: [writing-constitution]
  outputs: [narration-charter, narrative-voice]
---

# Narrator

Management of narration: who tells, from when, at what distance, with what
memory, and what that instance cannot know.

## 1. Founding decisions

Four decisions are taken once and recorded in the bible. Any later departure
is a defect, unless it is systematised.

1. Person: first, second, third.
2. Focalisation: internal, external, zero.
3. Tense: passé simple, passé composé, present.
4. Distance: is the narrator pressed against the character, one step back, or
   far away.

## 2. Choice table

| Combination | Dominant effect | Cost |
|---|---|---|
| First person, present | maximum immersion, urgency | the narrator's memory is hard to justify |
| First person, past | voice, retrospective irony | the narrator survives, so mortal suspense drops |
| Third internal, passé simple | the French novel standard | risk of neutrality |
| Third internal, present | modern tension | fatiguing over length |
| Third external | opacity, camera effect | emotion is hard to carry |
| Declared omniscience | scope, saga, irony | loss of identification when badly held |
| Second person | strangeness, address | unsustainable beyond a long short story |

## 3. Narrative distance

Five degrees, from furthest to closest:

1. Narrative summary: `Il passa trois ans à Kisangani.`
2. Objective narration: `Il descendit du bus et compta ses billets.`
3. Coloured narration: `Le bus le laissa dans une chaleur qui sentait le
   caoutchouc brûlé.`
4. Free indirect speech: `Trois ans. Trois ans, et toujours pas de nom sur la
   porte.`
5. Direct thought: `Je n'aurais pas dû revenir.`

Rule: movement between degrees must be gradual within a scene. Jumping from
degree 1 to degree 5 with no transition produces a break the reader feels as a
stylistic fault.

Free indirect speech is the central tool of the French novel: it allows the
third person to be held while giving the character's vocabulary and syntax. It
takes no quotation marks, no italics and no introducing verb.

## 4. Knowledge contract

Establish explicitly:

- what the narrator knows from the first page;
- what they learn at the same moment as the reader;
- what they know but will not yet say, and why that silence is defensible in
  retrospect;
- what they cannot know.

A narrator with internal focalisation does not describe their own face, does
not know the thoughts of others, and does not report a scene they did not
attend without naming their source.

## 5. Unreliable narrator

Four usable forms:

- unreliability by interest: they lie to protect themselves;
- by incapacity: age, illness, intoxication, trauma;
- by values: they judge by a system the reader does not share;
- by ignorance: they report faithfully what they misunderstand.

Fairness rule: every element allowing the reader to reconstruct the truth must
be present in the text before the revelation. Unreliability is a game, not a
cheat.

## 6. Voice

A narrative voice is built on five measurable parameters:

1. average sentence length and its variance;
2. dominant vocabulary, from the narrator's trade or milieu;
3. relation to imagery: rare and strong, or numerous and sustained;
4. relation to judgement: comments, or refuses to comment;
5. punctuation rhythm, particularly the use of the colon and the semicolon.

To hold a voice across four hundred pages, write one reference page and return
to it every time the manuscript is picked up after an interruption.

## 7. Transitions and ellipses

- An ellipsis is signalled by a section break, a temporal marker in the first
  sentence, or a change in the state of the world.
- Never summarise what has just been shown.
- A change of point of view happens at a typographic break, never mid
  paragraph.

## 8. Common errors

- Focalisation slip: entering a second character's head for one sentence.
- A narrator describing what they cannot see.
- Accumulated perception filters: il vit, il sentit, il remarqua.
- A uniform voice shared by the narrator and every character.
- A moral comment from the narrator at the end of a scene, which cancels its
  effect.

## 9. Auto-critique

Score 0 to 5: consistency of person and tense, focalisation held, accuracy of
distance, quality of free indirect speech, knowledge contract respected,
singularity of voice, handling of ellipses, absence of overhanging commentary.

Threshold: no axis below 3, average at least 3.8.

## 10. Interfaces

- Upstream: `novel-architect`.
- Lateral: `scene-builder`, `dialogue-master`.
- Review: `continuity-manager`, `quality/literary-editor`.
