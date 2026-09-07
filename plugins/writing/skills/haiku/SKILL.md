---
name: haiku
description: Writes haiku in French: flexible count, local season marker, the cutting technique and the gap between two images, prohibitions, composition in series. Use for a short form, a notation, or a seasonal collection.
license: MIT
metadata:
  category: poetry
  version: 2.0.0
  depends_on: [writing-constitution, poet]
  outputs: [haiku, seasonal-series]
---

# Haiku

A short form of Japanese origin. In French it does not reduce to a syllable
count: it rests on a perception, a season and a cut.

## 1. The three elements

1. The count: traditionally five, seven, five. In French, brevity matters more
   than arithmetic exactness. A haiku of thirteen to seventeen syllables is
   admissible if the imbalance is controlled.
2. The season word: a term placing the poem in a moment of the year, through a
   concrete phenomenon rather than the name of the season.
3. The cut: a break between two images, producing a gap. This is the essential
   element, and the one most often missed.

## 2. What a haiku is not

- Not an aphorism. No lesson, no moral.
- Not a metaphor. The two images are juxtaposed, not substituted.
- Not an expressed feeling. Emotion arises from the gap between images, never
  from its statement.
- Not a sentence cut into three lines.

## 3. The cutting technique

Most reliable structure: two lines for one image, one line for the other. The
cut sits between them, without heavy punctuation.

Effective kinds of gap:

| Gap | Principle |
|---|---|
| Scale | something very large and something very small |
| Time | what lasts and what passes |
| Sensory | a sound and a seen thing |
| Human and non-human | a gesture and a natural phenomenon |
| Presence and absence | what remains after someone |

## 4. Writing rules

- Present tense, or no verb.
- No evaluative adjective: beautiful, sad, magnificent.
- No explicit `je` in most cases. Subjectivity comes through the choice of
  detail.
- No comparison introduced by `comme`.
- One concrete thing per line.
- No title.

## 5. Adapting to a francophone context

The Japanese season word refers to a codified almanac. In French, choose
verifiable local markers: a harvest, a named wind, a migratory bird, a
seasonal practice. A haiku written in the tropics does not have four seasons:
it has dry seasons and rainy seasons, and that is what it must record.

## 6. Series

A single haiku is fragile. Composing in series of five to twelve, linked by a
place or a season, produces a more solid whole and allows progression.

## 7. Auto-critique

Score 0 to 5: presence of a real gap, accuracy of the season marker,
concreteness, absence of stated feeling, brevity, sound when read aloud.

Threshold: no axis below 4 on the gap and on the absence of stated feeling.

## 8. Interfaces

- Upstream: `poet`.
- Neighbours: `poetry/free-verse`.
