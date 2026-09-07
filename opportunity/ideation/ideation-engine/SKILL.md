---
name: ideation-engine
description: Generates ideas that are worth evaluating rather than a long undifferentiated list: frames the real problem and audience first, generates along deliberate axes so the ideas differ in kind rather than in wording, grounds each in a real need, and hands a diverse, non-redundant set to evaluation. Domain-independent: software, business, content, research, hackathons, personal projects. Use when a problem needs ideas generated, before any of them is chosen or built.
license: MIT
metadata:
  category: ideation
  version: 1.0.0
  depends_on: [opportunity-core]
  outputs: [problem-frame, idea-set, generation-axes, grounding-notes]
---

# Ideation Engine

Generating a hundred ideas is easy and nearly worthless: most are variations of
three, and the volume hides the lack of range. This skill generates a smaller,
genuinely diverse set, each grounded in a real need, that is worth the evaluation
that follows. It is the discovery half of the opportunity method, done so the
evaluation half has real material.

## 1. Frame the problem and audience first

```
problem     the real problem to solve, stated as a problem, not a solution in
            disguise; "people forget to drink water" is a problem, "a water app"
            is a solution that has skipped the framing
audience    who actually has this problem, specifically; a problem no named
            audience has is not a problem
why now     what makes this worth solving now: a change, a gap, an unmet need
constraint  the actor's constraints from opportunity-core, so generation stays
            within what could actually be pursued
```

Ideas generated before the problem is framed solve whatever the generator found
interesting, not what the audience needs.

## 2. Generate along deliberate axes

A flat brainstorm clusters around the obvious. Deliberate axes force range.

```
axes        vary the approach deliberately: different mechanisms, different
            audiences within the problem, different business models, different
            levels of ambition, the opposite of the obvious approach
kind        the ideas should differ in kind, not in wording; ten names for the
            same app is one idea, not ten
extremes    include the deliberately minimal and the deliberately ambitious
            version; the useful answer is often between them, and neither is seen
            without generating both
inversion   generate the approach that does the opposite of the default; it
            surfaces assumptions the default hides
```

## 3. Ground each idea in a real need

```
premise     each idea rests on a specific, real need of the named audience, stated
            as a hypothesis to test, per opportunity-core, not as a certainty
distinguish an idea grounded in a real observed need from one grounded in a
            plausible-sounding assumption; label which is which
evidence    where a need is asserted, note what would confirm it, so evaluation
            and idea-evaluation can test it rather than assume it
```

## 4. Hand over a diverse, non-redundant set

```
diverse     the set spans the axes, so evaluation chooses between real
            alternatives, not shades of one
few         a handful of genuinely different ideas beats a hundred variations; the
            count is not the metric, the range is
non-redundant   collapse the near-duplicates before handing over; ten framings of
            one idea waste the evaluation
ready       each idea carries its problem, audience, premise, and the axis it came
            from, so evaluation has what it needs
```

## 5. Prohibitions

- Never generate before framing the problem and naming the audience.
- Never mistake a solution for a problem in the framing.
- Never produce a long list of variations and call it a diverse set.
- Never present a plausible-sounding assumption as an established need.
- Never let volume substitute for range; ten near-duplicates are one idea.
- Never generate ideas that ignore the actor's real constraints.
- Never skip the extreme and inverted versions; the obvious middle is not the
  whole space.

## 6. Protocol

1. Frame the real problem, the specific audience, why now, and the constraints.
2. Choose deliberate generation axes to force range.
3. Generate along the axes, including the minimal, the ambitious, and the inverted.
4. Ground each idea in a specific real need, marked as observed or hypothesised.
5. Collapse near-duplicates; keep the genuinely different.
6. Hand over the diverse set, each with its problem, audience, premise, and axis.
7. Pass to `idea-evaluation` for the convergent half.

## 7. Auto-critique

Score from 0 to 5: problem framed as a problem with a named audience before
generating, axes deliberate and forcing range, extremes and inversion included,
each idea grounded and marked observed or hypothesised, near-duplicates collapsed,
the handed-over set genuinely diverse, constraints respected.

Threshold: no axis below 3, average at least 4. A long list of variations
presented as diversity, or an assumption presented as an established need, caps
the score until fixed, per opportunity-core.

## 8. Interfaces

- Upstream: `opportunity-core` for the method and grounding rule.
- Downstream: `idea-evaluation` converges the set to a ranked few;
  `hackathon-strategy` uses it to generate project ideas for a challenge;
  `market-research` and `client-discovery` when the ideas are business directions.
- Lateral: `project-brief` when a chosen idea becomes a project;
  `technology-selection` when it becomes a build.

## 9. Domain independence

The engine works the same for a software feature, a startup, a research direction,
a piece of content, a hackathon project, or a personal project. What changes is
the axes: business models for a startup, mechanisms for a feature, angles for
content, methods for research. The framing-first, range-over-volume, grounded-
premise discipline is constant across all of them.

## 10. Note on the count

The instinct to measure ideation by the number of ideas is the thing to resist. A
set of six ideas that differ in kind, each grounded and ready to evaluate, is a
better output than sixty that cluster around three premises. When asked for
"lots of ideas", generate for range and hand over the diverse few, with a note
that quantity was traded for the diversity that makes evaluation meaningful.
