# literary-editor

Stylistic editing in six passes: paragraph, verbs, adverbs and adjectives,
rhythm, images, conformity. Table of frequent corrections, editorial note, cut
log, explicit limits of intervention.

- Inputs: a revised text.
- Outputs: edited text, editorial note, cut log.
- Depends on: `writing-constitution`, `self-critique-protocol`.
- Downstream: `proofreader`, `publication-review`.

## When to use

A text that is correct but flat, and needs tightening without losing its
voice.

## When not to use

For structural problems, use `story-doctor`. For spelling and typography, use
`proofreader`. Section 6 states those limits and the skill holds them.

## The two principles

Editing is removal: eighty percent of improvements are deletions, and an
addition must be justified. And any intervention that makes the text more
correct and less recognisable is a bad intervention, which is why voice
preservation has a threshold of 4.

## Configuration

`language.creative_output` sets the output language. The correction table in
section 3 is French, as is the prose it corrects.
