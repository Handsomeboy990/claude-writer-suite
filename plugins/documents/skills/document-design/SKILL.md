---
name: document-design
description: Decides how a document looks and is navigated: heading hierarchy, typographic scale, spacing, margins, tables, captions, numbering, headers and footers, cover pages, tables of contents, cross-references and metadata. Applies one consistent system across a document set, readable on screen and in print. Use before rendering anything paginated.
license: MIT
metadata:
  category: publishing
  version: 1.0.0
  depends_on: [document-core]
  outputs: [style-sheet, document-skeleton, design-checklist]
---

# Document Design

Design in a professional document is navigation, not decoration. A reader
finds what they need because the hierarchy told them where to look, not
because the page is attractive.

Governed by `document-core`. This skill owns everything visual, so no
individual document decides its own formatting. Consistency across a set is
the deliverable.

## 1. Hierarchy

The reader must be able to reconstruct the structure from a page they land on
by accident.

| Level | Purpose | Rule |
|---|---|---|
| Title | the document | once, on the cover or at the top |
| Section | a major division | numbered in any document over about ten pages |
| Subsection | a division within it | numbered with its parent |
| Sub-subsection | rare | if you need a fourth level, the structure is wrong |
| Body | the content | |
| Caption | figures and tables | numbered independently, referenced from the text |
| Note | asides and sources | footnote or margin, never inline parenthesis over one line |

Rules:

- Three visible levels of heading. A fourth means the document should be split
  or the section should become a list.
- Difference between levels is visible without comparing two pages side by
  side. If the reader has to check, the scale is too tight.
- A heading is never orphaned: never the last line of a page. This is
  enforced, not hoped for.
- Numbering is on or off for the whole document, never mixed.
- Headings are the same grammatical shape throughout: all noun phrases, or all
  imperatives. Mixing them reads as two documents.

## 2. Typographic scale

One scale per document set. Fixed before writing, applied without exception.

| Element | Size relative to body | Weight | Space above | Space below |
|---|---|---|---|---|
| Title | 2.0 to 2.5 | bold | | 2 lines |
| Section | 1.5 to 1.7 | bold | 2 lines | 0.5 line |
| Subsection | 1.2 to 1.3 | bold | 1.5 lines | 0.25 line |
| Sub-subsection | 1.0 | bold or italic | 1 line | 0 |
| Body | 1.0 | regular | | 0.5 to 1 line |
| Caption | 0.85 | regular or italic | 0.25 line | 1 line |
| Code | 0.9 | monospace | 0.5 line | 0.5 line |
| Footnote | 0.8 | regular | | |

Body size: 10 to 11 point for print, 16 to 18 pixels for screen. Below 9 point
a document stops being read by anyone over forty, which includes most people
who sign things.

Line height: 1.4 to 1.6 for body text. Tighter is dense, looser loses the
line.

Line length: 60 to 90 characters. Longer and the eye loses the return; shorter
and the rhythm breaks. On A4 with a single column this means margins of at
least 25mm, which is a typographic requirement rather than a preference.

Fonts: at most two families, one for text and one for code. A serif for
printed body text and a sans for screen is a sound default, and a single
well-chosen family throughout is never wrong. Every font used must contain the
glyphs of the output language, verified rather than assumed.

## 3. Space

Spacing is what makes hierarchy visible. It carries more information than font
size.

The rule that fixes most documents: **space above a heading is always greater
than space below it.** A heading belongs to what follows, and equal spacing
makes it float between two sections, attaching to neither.

| Relationship | Space |
|---|---|
| Between paragraphs | 0.5 to 1 line, or a first-line indent, never both |
| Above a heading | 1.5 to 2 times the space below it |
| Around a table or figure | at least one full line, both sides |
| Between a caption and its object | less than between the caption and the next text |
| Page margins | 25mm minimum, 30mm on the binding edge when printed double sided |

Whitespace is not waste. A document with no whitespace is read slower, retained
less, and abandoned earlier.

## 4. Tables

Tables are the highest-value element in professional documents and the most
often mishandled.

| Rule | Reason |
|---|---|
| A table is for comparison; prose is for argument | a table of sentences is a list with lines drawn on it |
| Header row repeats on every page it spans | otherwise page two is unreadable |
| Numbers right aligned, text left aligned, headers match their column | scanning a column of numbers depends on it |
| One unit per column, stated in the header, not in each cell | `Cost (EUR)`, then bare numbers |
| Horizontal rules only, and few | vertical rules add ink and no information |
| No empty cell | write a dash, or `not applicable`; a blank is ambiguous |
| Caption above the table, numbered | it is read before the table, unlike a figure |
| Wide tables rotated or split, never shrunk below the minimum size | an unreadable table is worse than a second page |

A table that does not fit the page is a structural problem, not a font-size
problem. Split it by column groups, or move it to an annex.

## 5. Page furniture

| Element | Rule |
|---|---|
| Header | document title, or current section; not on the cover |
| Footer | page number, and version or date on formal documents |
| Page numbers | on every page except the cover; `n of N` on documents that get printed and separated |
| Cover | title, subtitle, version, date, author or organisation, recipient where applicable |
| Table of contents | for anything over about eight pages, or with more than six sections |
| Section start | on a new page for formal deliverables; continuous for reference material |

Confidential or draft status appears on every page, not only the cover. Pages
get separated, photographed and forwarded individually.

## 6. Figures, captions, cross-references

- Figures and tables are numbered in separate sequences, and referenced from
  the text by number. `See figure 3` survives a page reflow; `see the diagram
  below` does not.
- Every figure has a caption saying what it shows, not what it is. `Order flow
  from checkout to fulfilment` beats `Diagram`.
- Every figure is referenced from the text at least once. A figure nobody is
  sent to is decoration.
- Figures appear after their first reference, never before.
- Cross-references carry both number and title, so the document remains usable
  when printed and read out of order.
- Every diagram is readable in greyscale. Colour may reinforce meaning; it may
  never be the only carrier of it.

## 7. Colour and emphasis

| Rule | Reason |
|---|---|
| Colour never carries meaning alone | greyscale printing, and colour vision deficiency |
| At most one accent colour | a second is decoration |
| Body text is black or near black on white | anything else costs contrast |
| Text contrast at least 4.5:1, large text 3:1 | the accessibility floor, which is also the print floor |
| Bold for genuine emphasis, sparingly | more than one bold phrase per paragraph is none |
| Italic for terms, titles and foreign words | not for emphasis |
| Never underline anything that is not a link | it reads as a broken link |
| Never colour a whole paragraph | it reads as a warning even when it is not |

Callouts, warnings and notes get at most three types, distinguished by a label
in text rather than colour alone.

## 8. Metadata

Metadata is part of the document, not an export artefact.

```
Title        the real title, not the filename
Author       identity.author_name, or identity.organization
Subject      one line
Keywords     for retrieval in a document management system
Language     the output language, so screen readers pronounce it correctly
Created      date
Version      where the document is versioned
```

Filenames are index entries and are decided deliberately:
`2026-08-11-billing-integration-guide-v2.pdf`, never `document_final_v3.pdf`.

## 9. Consistency across a set

Individual documents do not choose. The set has one style sheet, and every
document uses it.

Fixed once, applied everywhere: the typographic scale, spacing, margins, table
style, colour, cover layout, header and footer, numbering, caption style,
terminology.

Record it as a style sheet next to the documents, so the next author does not
invent a second system. `resources/style-sheet-template.md` is the form.

## 10. Screen and print

Every professional document is printed by someone eventually.

| Check | Requirement |
|---|---|
| Greyscale | every distinction survives |
| Monochrome print | text remains readable, backgrounds do not fill with grey |
| Margins | nothing enters the binding or the unprintable edge |
| Links | printed documents show the target, in a footnote or an annex |
| Page breaks | no orphan heading, no widow line, no table split across its header |
| Reading order | matches visual order, for screen readers and for text extraction |

## 11. Protocol

1. Load `document-core`. Take the audience, the output language, and whether
   the document will be printed.
2. Reuse the existing style sheet if the document belongs to a set. Do not
   invent a second one.
3. Otherwise fix the scale, spacing, margins, table style and colour, and
   write the style sheet.
4. Verify the fonts contain every glyph of the output language.
5. Build the skeleton: cover, contents, sections, annexes.
6. Apply the hierarchy of section 1 and check that three levels suffice.
7. Format tables and figures per sections 4 and 6, with captions and
   references.
8. Add page furniture per section 5.
9. Set the metadata per section 8.
10. Run the checklist in `resources/design-checklist.md`, including the print
    and greyscale checks.
11. Hand to `pdf-production` where a paginated file is required.

## 12. Auto-critique

Score 0 to 5: three heading levels sufficed, scale applied without exception,
space above headings exceeds space below, tables comparative and readable
across pages, every figure captioned and referenced, page furniture complete,
colour never the sole carrier of meaning, metadata set, style sheet recorded,
greyscale and print checks performed.

Threshold: no axis below 3, average at least 4.

Automatic failure: a fourth heading level used to avoid restructuring, meaning
carried by colour alone, a table whose header does not repeat across pages, or
a font missing glyphs for the output language.

## 13. Interfaces

- Upstream: `document-core`, `technical-writing`, `user-documentation`,
  `report-writing`, `administrative-writing`.
- Downstream: `pdf-production`, `self-critique`.
- Related: `ui-ux-engineering` owns the equivalent decisions for interfaces.
