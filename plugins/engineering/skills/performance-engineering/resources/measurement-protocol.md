# Measurement protocol

A number without its conditions cannot be reproduced, challenged or compared.
Every measurement records the conditions.

## Conditions block, mandatory

```
Data volume     1,200 orders, 4,800 line items, 300 customers
Environment     local, or staging, or production, named
Hardware        the machine class, when it matters
Network         unthrottled, or the throttle profile
Cache           cold or warm, and which cache
Concurrency     one request, or the load profile
Runs            5, median reported, range reported
Revision        the commit measured
```

Baseline and after are measured with an identical block. A comparison across
different blocks is not a comparison.

## Frontend

```
Load           the project's own measurement tool, or the browser trace
Interaction    profile the interaction, record the long tasks
Renders        the framework profiler, count renders per interaction
Bundle         the build output, largest modules listed
Network        the waterfall, count requests and identify the critical path
```

Report the metrics the project already tracks. Introducing a new metric to
show an improvement is a way of choosing the answer first.

## Backend

The most useful backend measurement is not a timing. It is a count.

```
Queries per request     log them, count them, before any timing work
Rows returned           per query
Payload size            the response body, measured
External calls          count, and whether they are serial or concurrent
Latency                 median and 95th percentile, under a stated load
```

A request making 142 queries has a problem that no amount of query
optimisation will fix. Find the count first.

## Database

```
explain analyze the query, before the change
read the plan: scan type, rows estimated versus actual, index used or not
apply the change
explain analyze again
compare the plan, not only the time
```

The row estimate against the actual count is the most informative line in a
plan. A large divergence means the planner is working from stale or
insufficient statistics, and the fix may be the statistics rather than an
index.

## Reporting a delta

```
Before   LCP 4.8s median, range 3.9 to 6.1, 5 runs
After    LCP 1.4s median, range 1.2 to 1.7, 5 runs
Conditions identical, block above
Change   one commit, the join and the index
```

Rules:

- report the median and the range, never the best run;
- report the tail when the tail is what users experience;
- attribute the delta to one change, which is why changes are made one at a
  time;
- state what was not fixed, with its number.

## When a measurement is impossible

Say so, and say what is missing.

```
Unknown: production latency at the 95th percentile.
Missing input: no application performance monitoring is configured, and the
repository contains no access to production metrics.
What was measured instead: local timing at seeded volume, which is a lower
bound and not a substitute.
```

An honest lower bound is useful. A local number presented as a production
number is not.
