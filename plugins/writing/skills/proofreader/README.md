# proofreader

Spelling, grammar and typographic correction in five specialised passes.
French typography, the traps of French fiction, uniformity, correction log. No
stylistic intervention.

- Inputs: an edited text.
- Outputs: corrected text, correction log.
- Depends on: `writing-constitution`.
- Downstream: `publication-review`.

## When to use

The last read before publication.

## When not to use

For anything stylistic. Word choice, rhythm and images belong to
`literary-editor`, and this skill forwards suggestions rather than applying
them.

## Output language

This skill is French-specific. Its passes, its typography table and its trap
list are French rules. Set `language.creative_output` to another language and
sections 3 and 4 are replaced by that language's conventions, stated
explicitly. The skill does not apply French rules to a text that is not
French.

## Threshold

No axis below 4. A wrong correction is worse than a missed one.
