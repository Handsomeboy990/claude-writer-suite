---
name: performance-engineering
description: Measures before optimising: baseline, bottleneck identification, then targeted fixes across frontend rendering and bundles, backend queries and payloads, and database indexes and plans, with a proven delta. Use on a slowness symptom, a measurement, or before a release.
license: MIT
metadata:
  category: dev-skills
  version: 1.0.0
  depends_on: [engineering-core, project-exploration]
  outputs: [baseline, bottleneck-analysis, applied-optimisations, measured-delta]
---

# Performance Engineering

Optimisation without measurement is decoration. This skill measures, finds the
one thing that dominates, fixes it, and measures again.

## 1. The rule

```
No optimisation without a baseline.
No claim of improvement without a delta.
No delta without the same conditions on both sides.
```

A change that makes a page feel faster and cannot be shown to be faster was
not a performance change.

## 2. Protocol

1. **Define the symptom.** What is slow, for whom, on what data, at what
   percentile. A page that is slow for one user with fifty thousand rows is a
   different problem from one slow for everyone.
2. **Baseline.** Measure the current state with a repeatable method and record
   the conditions: data volume, network, hardware, cold or warm.
3. **Find the dominant cost.** One thing usually accounts for most of it. Find
   it with a profile, a trace, a query log or a waterfall, not by reading code
   and guessing.
4. **Set a target.** A number, from a product requirement or a budget. Without
   one, optimisation has no stopping point.
5. **Fix the dominant cost only.** One change at a time, so the delta is
   attributable.
6. **Measure again**, same conditions.
7. **Stop** when the target is met. Continuing past it trades readability for
   nothing.
8. **Record** the baseline, the change and the delta, so the next person does
   not redo the analysis.

## 3. Frontend

Ordered by how often each dominates.

| Cost | Symptom | Check |
|---|---|---|
| network waterfall | slow first paint | requests that could be parallel, or removed |
| bundle size | slow load on real networks | build analysis, largest modules |
| unnecessary requests | busy network panel | duplicate fetches, refetch on every render |
| images | large transfer, layout shift | dimensions, format, responsive sources |
| render count | interaction lag | profile, count renders per interaction |
| list rendering | scroll stutter | number of nodes, virtualisation threshold |
| expensive computation | frozen interaction | profile the long task |
| layout thrash | jank | reads and writes to layout interleaved |
| fonts | text flash | loading strategy, subset, preload |

Rules:

- measure with the profiler before adding memoisation; most memoisation added
  by reflex is cost without benefit;
- split code at route boundaries and for large rarely used components;
- import single functions, not whole libraries;
- give images explicit dimensions and use the project's pipeline;
- virtualise only past the point where the measurement shows a problem.

## 4. Backend

| Cost | Symptom | Check |
|---|---|---|
| N plus 1 | latency grows with row count | query log, count queries per request |
| missing index | one slow query dominates | query plan, sequential scan on a large table |
| unbounded query | memory and latency grow with data | absent limit or pagination |
| oversized payload | large response, slow serialisation | field list, included relations |
| serial external calls | latency is the sum of dependencies | calls that could be concurrent |
| no caching | repeated identical work | hit rate on a hot read |
| blocking work | throughput collapses under load | synchronous work on the request path |
| connection pressure | timeouts under load | pool size, transaction duration |

Rules:

- count queries per request; the number is a better early signal than any
  timing;
- select the fields the caller needs, not the entity;
- paginate every list, with a maximum;
- make independent external calls concurrent, dependent ones sequential;
- move work that the response does not need off the request path;
- keep transactions short, and never hold one across a network call.

## 5. Database

```
Plan          read it, do not assume the index is used
Index         on filter, join and order columns; equality before range in a
              composite
Selectivity   an index on a low cardinality column often does nothing
Write cost    every index slows writes; count them before adding another
Joins         check the join order and the row estimates against reality
Statistics    stale statistics produce a plan that made sense last month
Locks         long transactions and lock waits look like slow queries
```

An index added without reading the plan before and after is a guess with a
maintenance cost.

## 6. Measurement discipline

- Same data volume, same environment, same cache state on both sides.
- Multiple runs; report the median and the tail, not the best run.
- The tail is what users complain about. A median improvement with a worse
  tail is usually a regression.
- Measure with realistic data. A table with a hundred seeded rows proves
  nothing about the table with two million.
- Report the conditions with the number. A number without conditions cannot be
  reproduced or challenged.

## 7. Prohibitions

- No optimisation of code that was never measured.
- No caching added before the cost is understood; a cache is a correctness
  risk traded against a cost that may not exist.
- No micro optimisation of code that runs once.
- No readability sacrificed for an unmeasured gain.
- No index added without reading the plan.
- No claim of a percentage improvement without both numbers.
- No optimisation that changes behaviour, unless the behaviour change is the
  point and is stated.

## 8. Report format

```
Symptom     the team dashboard takes 4 to 6 seconds to become interactive
Conditions  1,200 orders, seeded, warm cache, local network throttled to Fast 3G
Baseline    LCP 4.8s median over 5 runs, 3.9 to 6.1 range
Dominant    142 queries per request, from a loop over orders loading customers
Target      under 2s LCP, from the product requirement
Change      single query with a join, one index on orders.customer_id
After       LCP 1.4s median, 1.2 to 1.7 range, 3 queries per request
Delta       queries 142 to 3, LCP 4.8s to 1.4s
Not done    bundle is 480 kB, above the 400 kB budget. Separate task, recorded.
```

## 9. Auto-critique

Score from 0 to 5: symptom defined, baseline recorded with conditions,
dominant cost identified by measurement, one change at a time, delta measured
under identical conditions, tail reported, stopped at the target, no behaviour
changed silently.

Threshold: no axis below 3, average at least 4. A report with an after number
and no before number is not a report.

## 10. Interfaces

- Upstream: `project-exploration`, `debugging` when the symptom is a defect.
- Lateral: `backend-engineering`, `frontend-engineering`,
  `dependency-selection` for size impact.
- Downstream: `code-review-protocol`, `release-readiness`,
  `project-continuity`.
