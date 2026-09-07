# document-design

Decides how a document looks and is navigated: hierarchy, typographic scale,
spacing, margins, tables, captions, numbering, page furniture, covers, tables
of contents, cross-references and metadata.

- Inputs: the written document, its audience, whether it will be printed.
- Outputs: style sheet, document skeleton, completed design checklist.
- Depends on: `document-core`.
- Downstream: `pdf-production`, `self-critique`.

## When to use

Before rendering anything paginated, and before starting a document set so the
set has one system rather than one per author.

## When not to use

For interfaces. That is `ui-ux-engineering`, which shares the vocabulary and
almost none of the constraints.

## What it enforces

Three heading levels, never four. Space above a heading greater than space
below. Tables whose header repeats across pages, with no empty cells. Every
figure captioned and referenced by number. Colour never the sole carrier of
meaning. Every distinction surviving a greyscale print.

## Configuration

| Field | Effect |
|---|---|
| `documents.page_size` | A4 or Letter, affecting margins and line length |
| `identity.organization` | cover and letterhead |
| `identity.author_name` | document metadata |
| `language.document_output` | glyph coverage check and metadata language |
