# document-core

Constitution of the `documents/` tree. Carries the audience model, the
separation of skill language from output language, the evidence rule, the
shared style standard and the quality gate.

- Inputs: a document request, its recipient, its source material.
- Outputs: audience profile, document plan, quality gate record.
- Depends on: nothing.
- Downstream: every other skill in the `documents/` tree.

## When to use

Load it before any document skill in this tree. It is the file the others
refer to instead of restating.

## When not to use

For fiction, poetry or screenplay, load `writing-constitution` instead. For
documentation that lives in a codebase and is maintained with the code, load
`technical-documentation` in the engineering tree.

## The four rules that matter most

1. The audience is named before the first sentence is written.
2. The output language is the recipient's, not the author's.
3. Nothing is asserted that was not verified. Gaps are marked, never filled
   with plausible text.
4. Eight reviews before delivery, eleven when the deliverable is paginated.

## Configuration

| Field | Effect |
|---|---|
| `language.document_output` | default output language when the request does not state one |
| `identity.organization` | organisation line on covers and letterheads |
