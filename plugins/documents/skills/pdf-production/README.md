# pdf-production

Produces and verifies professional PDFs. Selects the generation engine from
the document, builds cover, contents, pagination, page furniture and metadata,
then renders the pages and inspects them.

- Inputs: a document that passed the content gate and the design checklist.
- Outputs: the PDF, a render verification report, a reproducible generation
  recipe.
- Depends on: `document-core`, `document-design`.
- Downstream: `self-critique`, `client-handover`.

## When to use

Any paginated deliverable: a report, a guide, a manual, a formal letter, a
handover package.

## When not to use

Documentation that lives on screen and is read in a browser or a repository. A
PDF of a web page is a worse web page.

## The rule that defines this skill

A generated PDF is not a finished PDF until the rendered pages have been
looked at. Automated checks pass on documents that are visibly broken: clipped
lines, orphan headings, tables split from their headers, missing accented
capitals. None of these appear in the source, and none are reported by a
validity check.

## Engine

No default. Chromium, WeasyPrint, Typst, LaTeX, a Markdown converter or a
library, chosen from the document by the decision procedure in section 1, and
verified installed before a PDF is promised.

## Requirements

The verification steps use `pdfinfo`, `pdffonts`, `pdftotext` and `pdftoppm`
from Poppler, and `qpdf`. Where they are unavailable, the skill states which
checks could not be run rather than implying they passed.

## Configuration

| Field | Effect |
|---|---|
| `documents.pdf_engine` | preferred engine; empty means choose per document |
| `documents.page_size` | A4 or Letter |
| `identity.author_name`, `identity.organization` | PDF metadata and cover |
| `language.document_output` | document language metadata and glyph coverage check |
