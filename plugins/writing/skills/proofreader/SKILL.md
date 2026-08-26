---
name: proofreader
description: Corrects French spelling, grammar and typography in five specialised passes: agreement, tense, punctuation, uniformity, reverse reading. Produces a correction log and flags doubtful cases. Use as the last read before publication, without touching style.
license: MIT
metadata:
  category: quality
  version: 2.0.0
  depends_on: [writing-constitution]
  outputs: [corrected-text, correction-log]
---

# Proofreader

Spelling, grammar and typographic correction. The last barrier before
publication. The proofreader touches neither style nor structure.

This skill is specific to French output. Its passes and its rule tables are
French grammar and French typography. When `language.creative_output` is set
to another language, sections 3 and 4 are replaced by that language's own
conventions and the skill says so rather than applying French rules silently.

## 1. Scope

Belongs to this skill:

- lexical and grammatical spelling;
- agreement, conjugation, sequence of tenses;
- punctuation and French typography;
- uniformity of conventions;
- typos, duplicates, missing words.

Does not belong to this skill: word choice, rhythm, images, structure. Any
stylistic suggestion goes to `literary-editor`, never applied directly.

## 2. Correction passes

Five passes, one category of error per pass. A global read detects nothing;
the specialised read is what finds.

1. Agreement pass: subject and verb, past participles, adjectives.
2. Tense pass: sequence of tenses, passé simple against imparfait,
   subjunctive.
3. Punctuation and typography pass.
4. Uniformity pass: proper nouns, capitals, numbers, italics.
5. Reverse reading pass: read the sentences from the end to the beginning,
   which neutralises anticipation and reveals typos.

## 3. French typography

| Mark | Rule |
|---|---|
| Colon, semicolon, question, exclamation | non-breaking space before |
| French guillemets | non-breaking space inside |
| Comma and full stop | no space before, one space after |
| Ellipsis | three dots as a single character, attached to the word |
| Parentheses and brackets | no interior space |
| Percentage, units | non-breaking space between number and symbol |
| Apostrophe | curly typographic apostrophe |
| Accented capitals | accented, including at the start of a sentence |

Numbers: spelled out up to sixteen, then in figures, except dates, times,
measurements and page numbers. Centuries are set in roman small capitals in
publishing, otherwise in roman numerals.

Italics: work titles, unassimilated foreign words, flashbacks per the
constitution. Never for emphasis.

## 4. Frequent traps in French fiction

- Past participle with avoir and a preceding direct object.
- Past participle agreement for pronominal verbs.
- Sequence of tenses after a passé simple: imparfait, plus-que-parfait.
- Passé simple in the first person, correct but worth watching.
- Confusions: quelque and quel que, quoique and quoi que, davantage and
  d'avantage, plus tôt and plutôt.
- Elided subjects across chained clauses.
- Hyphens in numbers and in pronominal imperatives.

## 5. Uniformity

Keep a single record for the whole manuscript:

- exact spelling of proper nouns and places;
- capitalisation of institutions and titles;
- how times and dates are written;
- terms from the world lexicon;
- the dialogue system adopted;
- treatment of foreign languages.

This record is shared with `continuity-manager`.

## 6. Constitution conformity checks

- [ ] No emoji.
- [ ] No em dash, tables and headings included.
- [ ] Dialogue dashes are en dashes.
- [ ] French guillemets only.
- [ ] No emphatic capitals.
- [ ] Exclamation marks counted, one per page maximum.
- [ ] Italics restricted to permitted uses.

## 7. Correction log

Every correction is recorded: page, original form, corrected form, rule
applied. Doubtful cases are flagged to the author, not decided unilaterally.

## 8. Auto-critique

Score 0 to 5: completeness, accuracy of the rules invoked, uniformity, scope
respected, doubtful cases flagged, absence of unrequested stylistic
correction.

Threshold: no axis below 4. A wrong correction is worse than a missed one.

## 9. Interfaces

- Upstream: `literary-editor`.
- Downstream: `publication-review`.
