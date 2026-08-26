# Example: scoping a 36-hour entry to place

A team of three enters a 36-hour hackathon themed "accessibility". The judging
criteria, read first, are: impact 40%, working demo 30%, technical execution 20%,
presentation 10%. The strategy is built from that rubric, not from the team's
first big idea.

## The rubric reshapes the project

```
first idea    a real-time sign-language translator using computer vision
              (ambitious, technically exciting, impact story strong)
reality check impact 40% loves it; working demo 30% is the killer: a reliable CV
              translator will not work in 36 hours, so the demo would be broken,
              losing the heaviest realistic-to-hit criterion
revised       a browser extension that fixes the top accessibility failures on any
              page (missing alt text via a vision model on demand, contrast fixes,
              keyboard-nav repair); strong impact, and it will actually run
```

The revised project scores nearly as high on impact and, crucially, will produce
a working demo, which the first idea would not.

## Scope to finish

```
core (must work, it is the demo)
  - detect and fix missing alt text and low contrast on a live page
  - a visible before/after the judges can see instantly
optional (only if core works and time remains)
  - keyboard-navigation repair
  - a settings panel
cut from the start
  - user accounts, saved preferences, a backend; none serves the demo or the rubric
```

## Build plan with an early demo and a freeze

```
hour 0-12   working skeleton: the extension loads, detects one issue type, shows a
            before/after on a test page. Demoable, however thin, by hour 12.
hour 12-28  deepen the core: the second and third fix types, on real pages, polished
hour 28-32  FREEZE. No new features. Polish the before/after, handle the pages that
            break, make the demo reliable.
hour 32-36  buffer: record the demo, write the submission, re-read the requirements,
            rehearse the two-minute pitch.
```

## Team allocation

```
frontend-strong   the extension UI and the before/after demo surface
backend/logic     the detection-and-fix engine (the core)
pitch owner       shapes the impact story from hour 0, builds the demo script, and
                  fills gaps on the core; the pitch is not assigned at hour 34
parallel          a clean interface between the UI and the engine lets both build
                  without blocking
```

## What the strategy protected against

```
- the broken-demo trap: the first idea would have demoed a translator that did not
  work, losing 30% of the score
- the last-hour collapse: the freeze at hour 28 and the buffer meant the demo and
  submission were done calmly, not in a panic
- the disqualification: re-reading the requirements in the buffer caught a required
  "accessibility impact statement" field the team had not prepared
```

## The lesson

The rubric turned an exciting unfinishable idea into a strong finishable one. The
early demo and the freeze meant the team spent the last hours polishing a working
project, not integrating a broken one. That is how a weekend becomes a placing
entry.
