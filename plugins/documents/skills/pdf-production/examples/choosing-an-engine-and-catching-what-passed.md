# Choosing an engine, and catching what the checks passed

A 34 page handover report, delivered as a PDF to a client, in English with a
French annex.

## Engine selection

Applying section 1 rather than reaching for a habit.

| Requirement | Consequence |
|---|---|
| Running headers with the current section | rules out a plain Markdown converter |
| Page counters, `n of N` | rules out a plain Markdown converter |
| Regenerated on every revision, reviewed in version control | source must be text |
| Tables, one full-page diagram, no mathematics | rules out LaTeX as unnecessary |
| Produced on a CI runner with no browser | rules out headless Chromium |
| Deterministic pagination across runs | favours WeasyPrint over Chromium |

Chosen: WeasyPrint, from Markdown converted to HTML with a print stylesheet.

Verified before promising anything:

```bash
$ weasyprint --version
weasyprint 62.3
```

Recorded in the recipe. A colleague on 60.x produced a 35 page file from the
same source three weeks later, which is exactly why the version is recorded.

Rejected, with reasons, so nobody re-litigates it:

- **Chromium**: highest CSS fidelity, but not installed on the runner and its
  pagination shifts between versions. Adding it for one document is 300MB and
  a new class of bug.
- **Typst**: a good fit, and would have been chosen for a new document set.
  The source was already Markdown with an HTML pipeline used by three other
  deliverables. A second toolchain for one document is a second set of fonts
  and a second stylesheet.
- **LaTeX**: no mathematics, no bibliography, no existing template. All cost,
  no return.

## Step 1, automated checks

```
$ pdfinfo handover.pdf
Title:          Meridian platform handover
Author:         Atelier Nord
Pages:          34
Page size:      595 x 842 pts (A4)

$ pdffonts handover.pdf
name                    type      emb sub uni
SourceSerif4-Regular    CID Type0 yes yes yes
SourceSerif4-Bold       CID Type0 yes yes yes
SourceSans3-Bold        CID Type0 yes yes yes
JetBrainsMono-Regular   CID Type0 yes yes yes

$ qpdf --check handover.pdf
No syntax or stream encoding errors found

$ pdftotext handover.pdf - | head -20
Meridian platform handover
Version 2
11 August 2026
...
```

Everything passes. Title correct, author correct, four fonts all embedded,
structure valid, text extractable in reading order.

At this point the temptation is to deliver. The document is, on every
measurable axis, correct.

## Step 2, render and look

```bash
pdftoppm -png -r 110 handover.pdf page
```

34 images. Inspected: all of them, since the document is under 30 pages plus a
margin.

### Pass 1, six defects

| Page | Defect | Why nothing caught it |
|---|---|---|
| 7 | Heading `4.2 Deployment topology` alone at the foot | valid PDF, valid text, correct order |
| 11 | Table 3 header on page 11, rows continuing on 12 with no header | text extracted fine; page 12 is a wall of unlabelled numbers |
| 19 | Figure 5 overlapping the footer by roughly 4mm | no structural error; extraction unaffected |
| 23 | `É` in `Équipe` rendered as an empty box, French annex heading | the character is in the source and in the extracted text; only the render lacks it |
| 1 | Cover date read 30 July 2026 | metadata was correct; the cover template held a separate date field |
| 31 | Contents listed section 9 on page 29; it is on page 31 | contents generated before the last two edits |

The glyph defect is the sharpest illustration. The source contains `Équipe`.
`pdftotext` returns `Équipe`. Every automated check passes. The heading font
subset lacked the accented capital, and the annex heading shipped as `quipe`
with a box in front of it, in a document going to a French client.

### Fixes, in the source

1. `h2, h3 { break-after: avoid; }` in the print stylesheet.
2. `thead { display: table-header-group; }`, which is the one-line fix for
   every broken table in CSS Paged Media.
3. Figure 5 max-height reduced to `85vh`, clearing the footer.
4. Heading font swapped to the full Source Sans 3 family rather than the
   subset. Glyph sample rendered and inspected before continuing.
5. Cover date bound to the build date instead of a literal.
6. Contents regenerated as the final build step, which is where it belongs.

### Pass 2, one defect

| Page | Defect |
|---|---|
| 22 | New orphan heading, `6.1 Backup schedule` |

It did not exist in pass 1. The table fix on page 11 pushed roughly a third of
a page of content downstream, and a heading that had been mid-page landed at
the foot of page 22.

The `break-after: avoid` rule from fix 1 covered `h2` and `h3`. Section 6.1 is
an `h4`. Rule extended, regenerated.

Delivering after pass 1 would have shipped a defect created by the pass 1
fixes. This is why section 7 step 9 requires re-inspecting everything after a
pagination change, not only the pages that were fixed.

### Pass 3

Clean, all 34 pages.

## Step 3, print check

Printed greyscale on A4. One finding: figure 2 distinguished two data series
by colour alone, blue and orange, which print as two nearly identical greys.
Markers added, one circle and one square, regenerated, reprinted, verified.

That defect was invisible on screen and would have been invisible in any
number of render passes. It only exists on paper, and the client prints
handover documents.

## Recipe

```
Engine:   weasyprint 62.3
Fonts:    Source Serif 4 2.100, Source Sans 3 2.045 full family,
          JetBrains Mono 2.304, all embedded
Source:   docs/handover.md, docs/print.css
Command:  make handover.pdf
Verified: 2026-08-11, 34 pages, 3 render passes, greyscale print performed
```

## Cost

Automated checks: two minutes, all passing, on a document with six visible
defects.

Render and inspection: forty minutes across three passes.

Those forty minutes are the difference between a handover document and a
handover document with a box where the client's own language should be, on the
page addressed to their team.
