# Render verification

The procedure that separates a generated PDF from a finished one.

## Why the automated checks are not enough

Every defect below passes `qpdf --check`, produces valid metadata and extracts
clean text. All are invisible in the source. All are obvious in the render.

```
a heading alone at the foot of page 7
a table whose header stayed on page 11 while its rows went to page 12
E with an acute accent rendered as an empty box in every heading
a caption at 6pt because the figure was scaled to fit
a footer overlapping the last line on the three longest pages
a cover carrying the previous version's date
a contents page listing page numbers from before the last edit
```

Nothing catches these except looking.

## Step 1, automated

```bash
pdfinfo   document.pdf
pdffonts  document.pdf
pdftotext document.pdf - | head -80
qpdf --check document.pdf
```

| Check | Pass condition |
|---|---|
| Page count | matches expectation exactly |
| Title | the real title, not the filename or a template placeholder |
| Author | set |
| Language | set to the output language |
| Fonts | every row shows an embedded font |
| Text extraction | returns text, in reading order |
| Structure | no errors |
| File size | proportionate to the content |

## Step 2, render

```bash
pdftoppm -png -r 110 document.pdf page
```

One image per page. Inspect:

- Every page, for a document under 30 pages.
- Otherwise: the first 20, every page containing a table or a figure, every
  section start, the last 3, and a systematic sample of one page in five.

Never a random sample only. Pagination defects cluster around tables, figures
and section boundaries, which is exactly what a random sample under-represents.

## Step 3, the defect list

| Defect | Look for | Usual cause |
|---|---|---|
| Clipped text | a line cut at the margin, a shaved descender | fixed height container, or line height too tight |
| Overflow | text past the margin or into the header | a long unbreakable string, a wide table, a preformatted block |
| Orphan heading | a heading alone at the foot of a page | no break-after rule on headings |
| Widow line | one line alone at the top of a page | no widow control |
| Broken table | rows without their header | header repeat not enabled |
| Empty page | an unintended blank | a forced break plus an odd-page rule |
| Missing glyph | a box, a blank, a wrong character | the font lacks the glyph, usually accented capitals |
| Wrong page numbers | contents disagreeing with pages | contents not regenerated after the final edit |
| Inconsistent typography | one heading at the wrong size | a style applied by hand, usually to the last section edited |
| Broken image | absent, stretched, pixelated, cropped | wrong path, wrong aspect ratio, resolution too low |
| Unreadable content | a shrunk table, a 6pt caption | content that does not fit and was scaled instead of restructured |
| Overlap | figure over text, footer over the last line | absolute positioning, or a float without clearance |
| Wrong cover | old date, unreplaced placeholder | cover not regenerated with the body |

## Step 4, fix and re-inspect

- Fix in the source. Never in the PDF. A hand edit is discarded by the next
  regeneration, and nobody remembers it was there.
- Regenerate.
- Re-inspect the fixed pages **and every page after them**. Any pagination
  change shifts everything downstream, and a fix on page 12 routinely creates
  a new orphan on page 19.
- Repeat until a full inspection finds nothing.

## Step 5, print

For anything that will be printed:

- [ ] Printed in greyscale, on paper, and read.
- [ ] Every colour distinction survives.
- [ ] Nothing enters the binding margin or the unprintable edge.
- [ ] Double-sided pagination correct; sections start where intended.
- [ ] Links show their target in a footnote or an annex.

Where physical printing is impossible: render at 300 dpi, convert to
greyscale, inspect, and say that this is what was done. Do not imply a print
check that did not happen.

## Report

```markdown
## Render verification
File:     2026-08-11-handover-v2.pdf
Engine:   weasyprint 62.3
Pages:    34
Inspected: all 34, rendered at 110 dpi

Automated
  pdfinfo    pass, title and author correct, language en
  pdffonts   pass, 3 fonts, all embedded
  pdftotext  pass, reading order correct
  qpdf       pass

Visual
  Pass 1: 4 defects
    p7   orphan heading, section 4.2
    p11  table 3 header did not repeat onto p12
    p19  figure 5 overlapping the footer
    p1   cover date read 2026-07-30
  Fixed in source, regenerated.
  Pass 2: 1 defect
    p22  new orphan created by the pagination shift from the p11 fix
  Fixed, regenerated.
  Pass 3: clean.

Print
  Greyscale print performed. Figure 2 relied on colour to distinguish two
  series; markers added, regenerated, reprinted, verified.

Result: delivered.
```

Pass 2 is the point of this document. The fix on page 11 created a defect on
page 22 that did not exist before. Delivering after pass 1 would have shipped
a defect introduced by the fix.
