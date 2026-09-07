# Applicant-tracking parsing checklist

Before a CV goes out into a market that uses tracking systems, confirm a machine
can read it. A CV that impresses a human and scrambles in the parser never
reaches the human.

## Layout parses
- [ ] Real, selectable text everywhere; no text baked into an image or logo
- [ ] Standard section headings (Experience, Education, Skills), not creative labels
- [ ] Single-column, or a two-column layout confirmed to extract in reading order
- [ ] No tables for layout; parsers linearise them unpredictably
- [ ] A common font and standard bullet characters
- [ ] Contact details in the body text, not only in a header or footer that some
      parsers drop

## Extraction is clean
- [ ] Copy the whole CV as plain text: dates, titles, and companies come through
      intact and in order
- [ ] Name and contact details extract correctly
- [ ] No mojibake or dropped characters from an unusual font or encoding

## Keywords are present and true
- [ ] The real, relevant terms from the target role appear where the candidate's
      experience genuinely supports them
- [ ] Terms are woven into achievement bullets, not dumped in a keyword list
- [ ] No keyword the candidate cannot support is added to game the filter; that
      wins the parse and loses the interview

## Human scan still works
- [ ] The six-second scan lands on name, current role, and top achievements
- [ ] The strongest, most relevant achievement is near the top, not buried
- [ ] Length is earned: one page early-career, two mid-to-senior

## The two-reader test
Read it as a machine (copy to plain text, check the extraction) and as a human
(scan for six seconds). It must pass both. Optimising for one at the cost of the
other is the failure this checklist prevents.
