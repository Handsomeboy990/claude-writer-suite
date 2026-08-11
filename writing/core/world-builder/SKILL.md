---
name: world-builder
description: Builds coherent worlds from material constraint: geography, economy, power, belief, technology, language, systems of magic or technology. Use to create a world, check its consistency in cascade, or define the rules of a system of the impossible.
license: MIT
metadata:
  category: core
  version: 2.0.0
  depends_on: [writing-constitution, research-director]
  outputs: [world-bible, internal-rules, cartography, lexicon]
---

# World Builder

Creation of coherent worlds, invented, historical or contemporary. A world is
credible only when it is constrained.

## 1. Guiding principle

You do not build a world for its own sake. You build what produces conflict,
what limits the characters, and what will be seen. Everything else exists in
the background, unwritten, and shows itself through effects.

The rule of the tenth: the reader sees one tenth of the world you build. The
other nine tenths exist solely to guarantee that the visible tenth does not
contradict itself.

## 2. Order of construction

### 1. Material constraint

Start with the scarce resource: water, arable land, energy, metal, safety,
information. Every society organises itself around what it lacks. Scarcity
then determines power, law, the geography of settlement, and the conflicts.

### 2. Geography and climate

Relief, water networks, soils, seasons, prevailing winds. Then derive: roads,
ports, natural borders, crops, architecture, clothing, the rhythm of the day.

### 3. Economy

Who produces, who trades, who takes a cut. Currency or barter, credit, debt. A
world with no visible economy rings hollow, fantasy included.

### 4. Power

Source of legitimacy: force, birth, election, knowledge, religion, money. Mode
of succession. Counter-powers. What happens to someone who disobeys,
concretely, with a dated example.

### 5. Belief

What is feared, what is promised to the dead, what is unclean. Rites are
social facts: they cost time and money, they exclude and they gather.

### 6. Knowledge and technology

Technical level, transmission of knowledge, literacy, medicine. The technical
level must be consistent with the economy and the available energy.

### 7. Language

See `resources/lexique.md`. Invent only the words the narrative will use. Five
to fifteen terms are enough to suggest an entire language.

## 3. Special systems: magic, technology, supernatural power

Five mandatory questions. Without a firm answer to each, the system does not
hold:

1. Who can use it, and why them.
2. What does it cost, paid immediately and visibly.
3. What is the absolute limit, never crossed.
4. Who controls access, and what social power that creates.
5. Why has the world not been more radically transformed by its existence.

Corollary: the reader must know the rules before those rules solve a major
problem. A capability revealed at the climax cancels the tension.

## 4. Consistency in cascade

Every decision propagates. Systematically check the consequences on:

- food and its preservation;
- travel times;
- the circulation of information;
- the place of women, children and the old;
- medicine and mortality;
- the treatment of the dead;
- lighting and the relation to night.

Those seven points expose ninety percent of inconsistencies.

## 5. Revealing the world

- No encyclopaedia paragraphs. Information arrives through use, conflict, lack
  or a character's mistake.
- A character does not notice what is familiar to them: the world is described
  through the eye of someone arriving, someone returning, or someone losing
  something.
- Three precise details beat an exhaustive description.
- Local vocabulary is introduced by context, never by a gloss.

## 6. Real and historical worlds

When the world exists, it is documented by `research-director` rather than
invented. Section 8 of the constitution, on representation, applies in full.
No shortcuts, no decorative local colour.

## 7. Traps

- The frozen world, where nothing has changed in a thousand years.
- The map before the constraint.
- The single empire with no rival and no periphery.
- An entire people defined by one trait.
- A magic system with no cost, or whose cost is never paid on the page.
- Impossible geography: a capital with no water, a port with no hinterland.

## 8. Auto-critique

Score 0 to 5: internal consistency, material constraint, economic
credibility, logic of power, special system held, absence of encyclopaedism,
sensory richness, originality, cultural respect, dramatic usefulness.

Threshold: no axis below 3, average at least 3.8.

## 9. Interfaces

- Upstream: `research-director`.
- Lateral: `immersion-director`, `timeline-manager`.
- Review: `continuity-manager`.
