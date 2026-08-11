# Style sheet template

One per document set. Written once, stored next to the documents, reused
rather than reinvented. A set with no style sheet becomes a set where each
author copies the previous document approximately.

```markdown
# Style sheet, <set name>

Version <n>, <date>. Applies to <list the documents>.
Any deviation is recorded at the bottom, or it is a defect.

## Page

Size          A4 | Letter
Margins       top, bottom, inside, outside
Sides         single | double sided
Section start any page | new page | odd page
Columns       one | two

## Type

Body          <family>, <size>, line height <n>
Headings      <family>, <weight>
Code          <family>, <size>
Captions      <family>, <size>

Scale
  Title          <size>
  Section        <size>, <space above>, <space below>
  Subsection     <size>, <space above>, <space below>
  Sub-subsection <size>, <space above>, <space below>
  Body           <size>, <paragraph separation>

Glyph coverage verified for <languages>, including accented capitals and
currency symbols. Sample rendered and inspected on <date>.

## Colour

Text          <hex>
Accent        <hex>, used for <what, exhaustively>
Code block    <background>, <text>
No colour carries meaning anywhere.

## Tables

Rules         horizontal only, <weight>, above and below the header, below
              the last row
Header        bold, repeats on every page
Alignment     text left, numbers right, headers match their column
Units         in the header
Empty cells   forbidden, write a dash
Caption       above, `Table N. Title`, <case>
Numbering     continuous per document | continuous per section

## Figures

Caption       below, `Figure N. What it shows`, <case>
Numbering     separate sequence from tables
Reference     every figure referenced by number from the text
Greyscale     every figure verified readable without colour
Resolution    at least 150 dpi at final size

## Page furniture

Header        <left>, <right>, <size>, not on the cover
Footer        <content>, <size>
Page numbers  `n` | `n of N`
Cover         <fields, in order>
Contents      required beyond <n> pages, <depth> levels
Status        <draft or confidential marking, on every page>

## Metadata

Title         the document title
Author        <identity.organization or identity.author_name>
Language      per document
Filename      YYYY-MM-DD-subject-vN.pdf

## Terminology

| Use | Never |
|---|---|
| | |

## Deviations recorded

| Document | Deviation | Reason |
|---|---|---|
```

## Filling it in

- Decide before the first document, not after the third.
- Every value is concrete. `Readable` is not a size, `generous` is not a
  margin.
- The terminology table is the part that saves the most rework. Fill it from
  the words the documents actually disagree about, which you find by searching
  for synonyms.
- Record deviations rather than tolerating them silently. A recorded deviation
  reads as a decision; an unrecorded one reads as carelessness, and the next
  author normalises it away.

## Where it lives

Next to the documents, in version control, under a name the next author will
find: `style-sheet.md` at the root of the document directory. Not in someone's
notes, and not only in the finished documents, where it has to be reverse
engineered.
