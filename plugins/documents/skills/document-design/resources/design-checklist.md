# Design checklist

Run before rendering. Every failure sends the document back to design, not
forward to production.

## Hierarchy

- [ ] Three heading levels or fewer.
- [ ] Levels distinguishable on a single page, without comparison.
- [ ] Numbering consistently on or off across the whole document.
- [ ] Headings share one grammatical shape.
- [ ] No heading is the last line on a page.
- [ ] The structure is reconstructable from any page opened at random.

## Typography

- [ ] One scale, applied without exception.
- [ ] Body 10 to 11 point in print, 16 to 18 pixels on screen.
- [ ] Line height 1.4 to 1.6.
- [ ] Line length 60 to 90 characters.
- [ ] At most two font families.
- [ ] Every font contains every glyph of the output language, verified by
      rendering a sample containing the accented and special characters.
- [ ] No text below 8 point anywhere, including captions and footnotes.

## Space

- [ ] Space above each heading exceeds space below it.
- [ ] Paragraph separation by space or indent, not both.
- [ ] Margins at least 25mm, 30mm on the binding edge for double-sided print.
- [ ] A full line of space around every table and figure.
- [ ] Caption sits closer to its object than to the surrounding text.

## Tables

- [ ] Every table compares; none is prose with rules drawn on it.
- [ ] Header row repeats on every page the table spans.
- [ ] Numbers right aligned, text left aligned, headers matching.
- [ ] Units in the header, once, not in every cell.
- [ ] No empty cell.
- [ ] Caption above, numbered, referenced from the text.
- [ ] No table shrunk below the minimum readable size to make it fit.

## Figures

- [ ] Numbered in a sequence separate from tables.
- [ ] Captioned with what they show, not what they are.
- [ ] Referenced from the text by number at least once.
- [ ] Placed after their first reference.
- [ ] Readable in greyscale.
- [ ] Every arrow labelled, every boundary drawn.
- [ ] Resolution sufficient for print, at least 150 dpi at final size.

## Page furniture

- [ ] Header on every page except the cover.
- [ ] Page numbers on every page except the cover.
- [ ] `n of N` where the document may be printed and separated.
- [ ] Cover carries title, version, date, author or organisation.
- [ ] Table of contents present beyond eight pages or six sections.
- [ ] Contents entries match the headings exactly, with correct page numbers.
- [ ] Draft or confidential status on every page, not only the cover.

## Colour and contrast

- [ ] No meaning carried by colour alone.
- [ ] One accent colour at most.
- [ ] Body text contrast at least 4.5:1.
- [ ] Nothing relies on a coloured background surviving a print.
- [ ] Bold used sparingly, italic not used for emphasis, no stray underline.

## Metadata

- [ ] Title is the real title, not the filename.
- [ ] Author set.
- [ ] Language set to the output language.
- [ ] Subject and keywords set where the document enters a management system.
- [ ] Filename is an index entry: date, subject, version.

## Print and screen

- [ ] Printed in greyscale, on paper, and read. Every distinction survives.
- [ ] Nothing enters the binding margin or the unprintable edge.
- [ ] Links show their target in print, in a footnote or an annex.
- [ ] Reading order matches visual order when text is extracted.
- [ ] No widow, no orphan, no table split from its header.

## Consistency across the set

- [ ] The style sheet exists and was reused, not reinvented.
- [ ] Terminology matches the glossary.
- [ ] Covers, headers and footers identical across documents in the set.
- [ ] Version and date conventions identical.

## The three failures worth checking twice

1. **A fourth heading level.** It is always a symptom of structure that should
   have been split, and it is always cheaper to fix now than after review.
2. **Colour as the only distinction.** Invisible on a monochrome printer, to a
   colourblind reader, and in a photocopy, which is how most formal documents
   are actually consumed.
3. **A table header that does not repeat.** The document is correct on screen
   and unusable from page two onward on paper.
