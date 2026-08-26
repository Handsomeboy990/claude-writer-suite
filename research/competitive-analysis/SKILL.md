---
name: competitive-analysis
description: Analyses a competitive or comparative landscape from verifiable evidence: defines the comparison axes that matter to the decision, gathers each option's real characteristics from primary sources, compares on a like-for-like basis, separates observed fact from marketing claim, and states the trade-offs and the gaps rather than declaring a single winner. Use to compare products, vendors, technologies, or approaches for a decision.
license: MIT
metadata:
  category: research
  version: 1.0.0
  depends_on: [research-core, source-research]
  outputs: [comparison-axes, evidence-matrix, tradeoff-analysis, recommendation]
---

# Competitive Analysis

A comparison is only as honest as its axes and its sources. The failure modes
are choosing axes that flatter a predetermined winner, comparing options on
different bases, and repeating each option's own marketing as if it were
observed fact. This skill compares on evidence, for a decision, and states
trade-offs rather than crowning a winner the decision did not ask for.

## 1. Define the axes from the decision

```
decision      what the comparison is for; the axes serve it, not the other way
axes          the characteristics that actually change the decision, named before
              gathering, so the options cannot select the axes
weight        which axes are decisive and which are tie-breakers; a comparison
              that weights everything equally hides the one axis that matters
exclude       the axes that do not affect this decision, however tempting to list
```

Axes chosen after seeing the options tend to be the axes the preferred option
wins. Choose them from the decision, first.

## 2. Gather each option's real characteristics

```
primary       each option's real behaviour from primary sources: the docs, the
              pricing page, the source, the filing, a hands-on trial where possible
not           the option's own comparison page, which is engineered to win
like for like   the same axis measured the same way across options; a benchmark
              one vendor ran on its own hardware is not comparable to another's
recency       options change; a comparison against last year's version is stale
```

## 3. Separate observed fact from claim

```
observed      what was seen directly: the trial, the source, the measured number
claimed       what the option says about itself, attributed as a claim, not a fact
independent   what a third party without an interest reports, per source hierarchy
gap           where an option's real behaviour could not be established, say so;
              do not fill it with the option's marketing
```

## 4. Compare and surface trade-offs

```
matrix        options against axes, each cell an evidence-backed entry with its
              source and its type (observed, claimed, independent)
tradeoff      the axes on which options genuinely differ, and what each choice
              costs; the point of the analysis is the trade-off, not the score
context       the best option depends on the weight of the axes for this decision;
              state the conditions under which each option wins
no false winner   resist collapsing a real trade-off into a single ranking; a
              recommendation names the conditions it assumes
```

## 5. The recommendation

```
conditional   given the decision's weighting, this option, because of these axes
alternatives  when the weighting differs, which option wins instead
risks         what the recommendation depends on that could change
gaps          what could not be established and how it would move the answer
```

## 6. Prohibitions

- Never choose the comparison axes after seeing which option they favour.
- Never compare options on different bases and present it as like-for-like.
- Never repeat an option's marketing claim as an observed fact.
- Never fill a gap in an option's real behaviour with its own marketing.
- Never declare a single winner where a real trade-off exists; state the conditions.
- Never weight every axis equally to avoid the judgement the decision needs.
- Never trust an option's own comparison page as a source about a competitor.

## 7. Protocol

1. State the decision and derive the axes that affect it, with weights.
2. Gather each option's real characteristics from primary and independent sources.
3. Mark each cell as observed, claimed, or independent; name the gaps.
4. Compare like-for-like; assemble the evidence matrix.
5. Surface the genuine trade-offs and the conditions under which each option wins.
6. Recommend conditionally, with alternatives, risks, and gaps.
7. Verify the weighty claims with `source-verification` before relying on them.

## 8. Auto-critique

Score from 0 to 5: axes derived from the decision before seeing the options,
characteristics from primary and independent sources not marketing, observed
kept distinct from claimed, like-for-like comparison, trade-offs surfaced rather
than collapsed, recommendation conditional with its assumptions, gaps named.

Threshold: no axis below 3, average at least 4. Axes chosen to flatter a
predetermined winner, or marketing repeated as observed fact, caps the score
until fixed.

## 9. Interfaces

- Upstream: `research-core`, `source-research` gathers the evidence,
  `source-verification` checks the weighty claims.
- Downstream: `synthesis-reporting` and `report-writing` render the analysis;
  `technology-selection` and `dependency-selection` are the engineering-specific
  forms of this comparison with their own criteria.
- Lateral: `market-research` for the market-level version, `decision-records`
  when the choice is recorded.

## 10. Live sources

The analysis reads each option's primary sources and independent reporting
directly where the runtime can reach them. An option's own comparative marketing
is read as a claim about itself, never as a source about a competitor. Gaps that
require a source the runtime cannot reach are named, not filled.
