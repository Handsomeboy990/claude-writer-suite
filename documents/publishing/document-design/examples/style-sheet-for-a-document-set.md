# A style sheet for a document set

Four deliverables for one client: an architecture document, an installation
guide, a user manual and a handover report. Four documents, one system.

Without a style sheet, four documents arrive with four covers, three heading
scales and two ways of numbering tables. The client notices, and what they
notice is that these were not produced by one team.

## The style sheet

```markdown
# Style sheet, Meridian delivery documents

Version 1, 2026-08-11. Applies to all four deliverables.
Any deviation is recorded here, or it is a defect.

## Page

Size          A4
Margins       top 25mm, bottom 25mm, inside 30mm, outside 25mm
Sides         double sided, sections start on an odd page
Columns       one

## Type

Body          Source Serif 4, 10.5pt, line height 1.5
Headings      Source Sans 3, bold
Code          JetBrains Mono, 9.5pt
Captions      Source Sans 3, 9pt

Scale
  Title         24pt
  Section       17pt, 2 lines above, 0.5 below
  Subsection    13pt, 1.5 lines above, 0.25 below
  Sub-subsection 10.5pt bold, 1 line above, 0 below
  Body          10.5pt, 0.5 line between paragraphs, no indent

Glyph coverage verified for English and French, including accented
capitals, guillemets and the euro sign. Sample rendered and inspected on
2026-08-11.

## Colour

Text          #1A1A1A on white
Accent        #1F4E79, headings and rules only
Code block    #F5F5F5 background, #1A1A1A text
No other colour. No colour carries meaning anywhere.

## Tables

Rules         horizontal only, 0.5pt, above and below the header, below the
              last row
Header        bold, repeats on every page
Alignment     text left, numbers right, headers match the column
Units         in the header, never in cells
Empty cells   forbidden; write a dash
Caption       above, `Table N. Title`, sentence case
Numbering     continuous through each document

## Figures

Caption       below, `Figure N. What it shows`, sentence case
Numbering     continuous, separate from tables
Reference     every figure referenced by number from the text
Greyscale     every figure verified readable without colour
Resolution    at least 150 dpi at final size

## Page furniture

Header        document title left, section right, 9pt, not on the cover
Footer        page `n of N` centred, version and date right, 9pt
Cover         title, subtitle, version, date, `Prepared for <client>`,
              `Prepared by <organisation>`
Contents      all four documents, two levels deep
Status        `Draft` on every page until the version is final

## Metadata

Title         document title
Author        identity.organization
Language      set per document, en or fr
Filename      YYYY-MM-DD-subject-vN.pdf

## Terminology

One term per concept, across all four documents.

| Use | Never |
|---|---|
| order | purchase, transaction, sale |
| environment | instance, stage, server |
| deploy | release, push, ship |
| customer | client, user, end user |
| client | customer, the business |

`client` is the organisation receiving the delivery. `customer` is their
customer. Confusing the two in a handover document is the failure this row
exists to prevent.

## Deviations recorded

The user manual uses 11pt body rather than 10.5pt. Its audience includes
warehouse staff reading printed pages in poor light. Recorded here rather
than left as an inconsistency.
```

## What the checklist caught before rendering

| Finding | Rule | Fix |
|---|---|---|
| Architecture document used four heading levels in section 5 | hierarchy | section 5.3.2.1 became a labelled list; the structure was already a list pretending to be headings |
| Component diagram distinguished services by colour only | colour | shape and label added; verified in greyscale |
| Capacity table split across pages without repeating its header | tables | header repeat enabled; page 12 had been a wall of unlabelled numbers |
| Installation guide used `stage` and `environment` interchangeably | terminology | `environment` throughout, 14 occurrences |
| Two covers said `Prepared for Meridian`, two said `For Meridian` | consistency | fixed to the style sheet form |
| Handover report contents listed page numbers off by two | page furniture | contents regenerated after the last edit, which is when it must be done |
| French document rendered `É` as a missing-glyph box in headings | glyph coverage | the heading font lacked accented capitals; caught by rendering a sample, not by reading the source |

The last one is the one that matters. The source was correct. Every review of
the text would have passed it. It was only visible in the rendered output, at
final size, which is why section 11 of the skill puts the glyph check before
production rather than after.

## What the style sheet cost and returned

Ninety minutes to write. It removed four separate design conversations, made
the checklist mechanical rather than a matter of taste, and gave the next
author something to follow instead of a previous document to copy
approximately.

The recorded deviation matters as much as the rules. Without that line, the
11pt body in the user manual reads as carelessness. With it, it reads as a
decision, and the next author knows not to normalise it away.
