---
name: market-research
description: Researches a market to inform a business decision from verifiable evidence: sizes the market honestly rather than with a top-down fantasy, maps the real competitors and their positioning, finds the actual customer segments and their needs, identifies the trends and the gaps, and states confidence and sources throughout. Every figure is sourced or marked an estimate with its method. Use to assess a market opportunity, size a segment, or map a competitive field before a business decision.
license: MIT
metadata:
  category: business
  version: 1.0.0
  depends_on: [opportunity-core]
  outputs: [market-sizing, competitor-map, segment-analysis, opportunity-assessment]
---

# Market Research

A market assessment drives a real decision about where to spend real money and
time, so its figures have to be honest. The failure mode is the top-down fantasy:
a huge total market, a made-up "we only need 1 percent", and a number nobody can
source. This skill sizes markets from evidence, maps real competitors, and states
its confidence, because a business decision built on an invented number fails
expensively.

## 1. Size the market honestly

```
bottom-up   prefer building the size from real units: the number of potential
            customers times a realistic price times a realistic adoption; grounded
            and defensible
top-down    a total-market figure from a source is context, not the answer; "the
            global market is X billion" says nothing about the reachable, winnable
            share
reachable   distinguish the total market, the market the provider can actually
            serve, and the share they could realistically win; conflating them is
            the classic overstatement
sourced     every figure is from a live source, or an estimate with its method and
            assumptions stated, per opportunity-core; never a number with no
            derivation
```

The "we only need 1 percent of a huge market" argument is a warning sign, not a
plan. Size what is reachable, from the bottom up, with sources.

## 2. Map the real competitors

```
real        the actual competitors, from live sources; who serves this market now,
            including the incumbents and the substitutes customers use instead
position    what each does, for whom, at what price, with what strength and
            weakness; from their real product and pricing, not their marketing
gap         where the competitors are weak, absent, or serving a segment poorly;
            the gap is the opportunity, and it is found by mapping who is there, not
            by assuming no one is
honest      "no competitors" almost always means the market does not exist or they
            were not looked for; find the substitutes, because customers solve the
            problem somehow today
```

## 3. Find the real segments and their needs

```
segments    the distinct groups within the market, each with different needs,
            willingness to pay, and reachability; a market is rarely uniform
needs       what each segment actually needs, from real signals: reviews of
            existing solutions, public complaints, stated demands, not assumption
reachable   which segments the provider can actually reach and serve; the most
            attractive segment is worthless if it cannot be reached
```

## 4. Identify trends and confidence

```
trends      the real, sourced direction of the market: growing, shifting,
            consolidating, from dated evidence, not a narrative
confidence  stated per finding, per research-core's standard: a well-sourced size
            is high confidence, a bottom-up estimate is moderate, a segment need
            inferred from thin signals is low; the reader acts on the confidence
gaps        what could not be established, and what it means for the decision;
            an honest gap beats a confident invention
```

## 5. Assess the opportunity

```
assessment  given the reachable size, the competitive gap, the reachable segments,
            and the trends: is this a real opportunity, for this actor, and where
conditional the assessment names the conditions and the confidence; a moderate-
            confidence opportunity is presented as such, not as a certainty
honest      when the research shows the market is small, crowded, or unreachable,
            say so; that finding saves the actor from an expensive mistake, and it
            is the most valuable output a market research can produce
```

## 6. Prohibitions

- Never present a top-down total market as the reachable opportunity.
- Never use "we only need X percent" as a sizing method.
- Never state a market figure without a source or a stated estimation method.
- Never claim "no competitors"; find the substitutes customers use today.
- Never infer a segment need from assumption and present it as established.
- Never present a market assessment as more certain than the sources support.
- Never talk the actor into a market the evidence shows is small or crowded.

## 7. Protocol

1. Size the market bottom-up where possible; separate total, serviceable, and
   winnable; source every figure or state its method.
2. Map the real competitors and substitutes, with their positioning and gaps.
3. Identify the segments, their real needs, and their reachability.
4. Establish the trends from dated evidence.
5. State confidence per finding and name the gaps.
6. Assess the opportunity conditionally, for this actor, with its confidence.
7. Report a small, crowded, or unreachable market honestly when that is the finding.

## 8. Auto-critique

Score from 0 to 5: sizing bottom-up and separating total from reachable, every
figure sourced or method-stated, competitors and substitutes real, segments and
needs evidenced, trends dated, confidence stated per finding, assessment
conditional and honest including an unfavourable finding.

Threshold: no axis below 3, average at least 4. A top-down fantasy sizing, a
"we only need 1 percent" argument, or an unsourced market figure caps the score
until fixed, per opportunity-core.

## 9. Interfaces

- Upstream: `opportunity-core` for grounding, `research-core` for the evidence and
  confidence standard.
- Downstream: `idea-evaluation` uses the market assessment to test a demand
  assumption, `client-discovery` uses the segments, `synthesis-reporting` and
  `report-writing` render the assessment for a decision.
- Lateral: `competitive-analysis` in `research/` for the deep competitor
  comparison; `source-verification` for the weighty market claims.

## 10. Live sources

Market research reads whatever market data, competitor, and search sources the
runtime exposes, and states each figure with its source or its estimation method.
When a needed source is unreachable, it says so and gives a bottom-up estimate
with its assumptions labelled, rather than borrowing a top-down number it cannot
verify. The most dangerous output is a confident market size with no derivation,
because a real budget gets committed against it; the discipline is that every
number can be traced to a source or an explicit, checkable assumption.
