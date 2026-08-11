# publishing

Two skills. How a document looks, and how it becomes a file someone opens.

| Skill | Owns |
|---|---|
| [document-design](document-design/) | hierarchy, typography, spacing, tables, captions, page furniture, covers, contents, metadata |
| [pdf-production](pdf-production/) | engine selection, generation, and verification of the rendered pages |

They run after the content is written and passed its gate, in this order. No
individual document decides its own formatting: `document-design` fixes one
system for a set, and every document in the set uses it.

## document-design

Design here is navigation, not decoration. A reader finds what they need
because the hierarchy told them where to look.

Three rules do most of the work:

- Three heading levels, never four. A fourth level always means the structure
  should have been split.
- Space above a heading is greater than space below it. A heading belongs to
  what follows.
- Colour never carries meaning alone. Formal documents are photocopied,
  printed in greyscale, and read by people who do not see colour the way the
  author does.

## pdf-production

The one rule: a generated PDF is not a finished PDF until the rendered pages
have been looked at.

Automated checks pass on documents that are visibly broken. A heading orphaned
at the foot of a page, a table separated from its header, an accented capital
rendered as an empty box: all of these produce a structurally valid PDF with
correct metadata and clean text extraction. Only the render shows them.

The engine is chosen from the document, not by habit, and verified installed
before a PDF is promised. Chromium, WeasyPrint, Typst, LaTeX, a Markdown
converter or a library, each with the case where it is right.

## Requirements

`pdf-production` uses `pdfinfo`, `pdffonts`, `pdftotext` and `pdftoppm` from
Poppler, plus `qpdf`, for its verification steps. Where a tool is unavailable
it says which checks could not be run rather than implying they passed.

Neither skill installs an engine on your behalf.

## Configuration

| Field | Used by |
|---|---|
| `documents.page_size` | both |
| `documents.pdf_engine` | `pdf-production`, empty means choose per document |
| `identity.organization`, `identity.author_name` | covers and metadata |
| `language.document_output` | glyph coverage check and document language |
