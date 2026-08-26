# administrative-writing

Formal and institutional documents ready for real use: letters, official
correspondence, administrative requests, notices, attestations, memoranda,
meeting minutes, formal statements and application documents.

- Inputs: sender, recipient, purpose, facts and their sources, the recipient's
  country.
- Outputs: the document, the required-element checklist, the list of marked
  gaps.
- Depends on: `document-core`.
- Downstream: `document-design`, `pdf-production`, `self-critique`.

## When to use

The document leaves the organisation, is filed by its recipient, and may be
quoted back later.

## When not to use

Never for technical documentation. The audiences, registers, structures and
consequences have nothing in common, and mixing them produces a letter no
administration accepts and a manual no engineer can use.

## What it enforces

Every required element present. Purpose in the first sentence. Deadlines as
dates, never durations. Salutation and closing matched to the recipient's
country convention. No sentence readable two ways.

Above all: nothing invented. No statute, article, registration number,
licence, institution, title or prior exchange is written unless it was taken
from a source. Missing elements are marked visibly in the draft. Anything
touching legal effect or entitlement is marked for a qualified human. This
skill drafts; it does not advise.

## Limitations

It is not legal advice and does not replace counsel. It will draft around a
legal question and mark it, rather than answer it.

## Configuration

| Field | Effect |
|---|---|
| `language.document_output` | output language, set to the recipient's |
| `identity.author_name` | signature block |
| `identity.organization` | letterhead and sender block |
| `documents.date_format` | date rendering, overridden by the recipient's country |
