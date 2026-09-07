# Example: comparing three managed database vendors

The decision: pick a managed Postgres provider for a team of four shipping a B2B
app with unpredictable growth and a tight ops budget. The axes come from that
decision, before any vendor page is opened.

## Axes, derived from the decision, weighted

```
decisive     operational burden (team of four, no dedicated ops)
decisive     predictable cost under unpredictable growth
important    backup and point-in-time recovery (B2B data)
important    connection handling (serverless app, many short connections)
tie-breaker  region availability
excluded     max theoretical throughput (the app is nowhere near any vendor's limit)
```

Throughput leads most vendor comparison pages and is excluded here, because it
does not affect this decision.

## Evidence, by type

```
axis: operational burden
  A  observed: managed upgrades, automated failover (docs, confirmed in a trial)
  B  observed: manual major-version upgrades (docs); a real ops cost
  C  claimed: "zero-ops" (marketing); trial showed manual scaling steps -> claim
     does not match observation, recorded as such

axis: predictable cost
  A  observed: flat instance pricing (pricing page); predictable
  B  observed: usage-based, with a per-connection component (pricing page); hard
     to predict for a serverless app that opens many connections
  C  observed: flat base plus egress (pricing page); egress is the variable

axis: connection handling
  A  observed: built-in pooler (docs, tested)
  B  claimed: "handles any load"; trial hit connection limits without an external
     pooler -> claim narrowed to observation
  C  observed: pooler included (docs, tested)
```

## Trade-off, not a ranking

```
A wins on operational burden and cost predictability, at a higher floor price.
C matches A operationally at a lower floor, but egress cost is the variable to
  watch for this app's traffic shape.
B is cheapest at rest and the riskiest operationally and for cost, given the
  serverless connection pattern; its marketing claims did not survive the trial.
```

## Conditional recommendation

```
given    a four-person team, no ops capacity, and cost predictability weighted
         decisive: A, accepting the higher floor price as the cost of low burden
if       the egress profile turns out low after measuring real traffic: C becomes
         the better value at the same operational level
risk     A's floor price assumes the current instance tiers; re-check if pricing
         changes
gap      real egress cost for C could not be established without production
         traffic; named, and it is the one number that would move the answer to C
```

## The lesson

The comparison did not crown a winner. It named the one measurement (C's real
egress) that decides between the two viable options, and excluded the axis
(throughput) that the vendors' own pages lead with and that this decision does
not care about.
