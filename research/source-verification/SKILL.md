---
name: source-verification
description: Checks a claim before it is relied on: traces it to its origin, confirms the source actually says what it is quoted as saying, tests the source's authority and independence and recency, cross-checks against independent sources, and detects the circular citation where many sources trace to one unverified origin. The skeptic's pass that separates a fact from a widely repeated rumour. Use on any claim that carries weight, and before a finding informs a decision.
license: MIT
metadata:
  category: research
  version: 1.0.0
  depends_on: [research-core]
  outputs: [verification-verdict, provenance-trace, contradiction-notes, confidence-rating]
---

# Source Verification

A claim repeated by a hundred sources can trace to one source that made it up.
Verification is the pass that follows a claim to its origin and asks whether the
origin holds. It is the difference between a fact and a rumour with good
distribution.

Not every claim needs it. The ones that carry a decision do.

## 1. Which claims to verify

```
verify    a claim that a decision rests on
verify    a surprising claim, a claim that fits the desired conclusion too well,
          a claim with a precise statistic and a vague source
verify    a claim repeated everywhere in identical wording, which suggests one
          origin, not many witnesses
skip      a claim that is uncontested, low-stakes, and consistent with primaries
          already read
```

## 2. Trace the claim to its origin

```
follow    each source's citation back, rung by rung, to where the claim first
          appears
origin    the first source that states it as its own finding, not as a citation
test      does the origin actually support the claim, or has the claim drifted
          from what the origin said as it was repeated
drift     a number that gained precision, a hedge that was dropped, a "may" that
          became "does", a correlation that became a cause
```

The most common failure: a careful primary said "associated with, in this
sample, under these conditions", and the hundredth repetition says "causes".

## 3. Test the origin

```
authority   is the origin actually in a position to know the claim
independence   is the origin independent of an interest in the claim being true
method      for an empirical claim, does the origin's method support its
            conclusion, or is the conclusion larger than the method
recency     is the origin current, or superseded by something later
retraction  has the origin been corrected, retracted, or contradicted by its own
            author since
```

## 4. Cross-check

```
independent   is the claim supported by a source that does not trace back to the
              same origin? Three sources citing one origin are one source.
converging     independent sources reaching the claim by different routes raise
              confidence; the same wording everywhere lowers it
absence        if a claim that should be widely documented appears in only one
              place, that absence is a warning
```

## 5. The verdict

```
verified      traced to a sound origin, supported, cross-checked; report as fact
partly         the origin supports a narrower version than the claim; report the
              narrower version
unverified     could not be traced to a sound origin; report as unverified, do
              not launder it into a fact
contradicted   a sound source contradicts it; report the contradiction
circular       many sources, one unverified origin; report that, which is itself
              a finding
```

## 6. Prohibitions

- Never accept a claim by the count of sources repeating it; trace it to origin.
- Never report a claim as verified without an independent cross-check.
- Never let a claim keep the precision or certainty it gained in repetition past
  what its origin supports.
- Never treat sources that all cite one origin as independent corroboration.
- Never upgrade an unverified claim to a fact because it is convenient.
- Never skip verification on the claim the decision most depends on.

## 7. Protocol

1. Select the claims that carry weight; skip the uncontested and low-stakes.
2. Trace each to its origin, rung by rung, noting any drift in the repetition.
3. Test the origin: authority, independence, method, recency, retraction.
4. Cross-check against genuinely independent sources.
5. Detect circular citation where many sources share one origin.
6. Issue a verdict per claim: verified, partly, unverified, contradicted, circular.
7. Report the narrower supported version where the claim overreached its origin.

## 8. Auto-critique

Score from 0 to 5: weighty claims selected for verification, each traced to
origin, drift in repetition detected, origin tested for authority and
independence and method and recency, cross-checked against genuinely independent
sources, circular citation caught, verdict honest including unverified and
contradicted.

Threshold: no axis below 3, average at least 4. Reporting a claim as verified
that traces to a single unchecked origin, or laundering an unverified claim into
a fact, caps the score until fixed.

## 9. Interfaces

- Upstream: `research-core` for the evidence standard, `source-research` supplies
  the claims and their sources.
- Downstream: `synthesis-reporting` uses the verdicts and confidence ratings,
  `competitive-analysis` and the business and career skills rely on verified
  claims before a decision.
- Lateral: `self-critique` for the skeptic role, `report-writing` states the
  confidence in the delivered document.

## 10. Live sources

Verification reads the origin directly whenever the runtime can reach it, rather
than trusting the chain of repetition. When the origin is unreachable, the
verdict is unverified with the obstacle named, never a verified rating inferred
from the repetition alone.
