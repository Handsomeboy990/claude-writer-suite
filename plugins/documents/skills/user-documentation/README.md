# user-documentation

Documentation for people who did not build the system and do not want to
understand it: user guides, manuals, onboarding, help centre articles, FAQs
and support-facing troubleshooting.

- Inputs: the product, the tasks users actually attempt, support tickets.
- Outputs: task articles, task index, glossary, support articles.
- Depends on: `document-core`.
- Downstream: `document-design`, `pdf-production`, `self-critique`.

## When to use

The reader is not technical, arrived because something failed or was not
obvious, and wants to finish a task rather than understand a system.

## When not to use

The reader can run commands and read code. That is `technical-writing`.

## What it enforces

Articles are titled after tasks the reader could have searched for before
knowing the product existed. One action per step, with what the reader sees
afterwards. Error messages quoted exactly, never paraphrased. Every procedure
performed in the product as a new user before it is written. The words
`simply`, `just` and `easily` are banned.

## Configuration

| Field | Effect |
|---|---|
| `language.document_output` | output language, set to the reader's |
