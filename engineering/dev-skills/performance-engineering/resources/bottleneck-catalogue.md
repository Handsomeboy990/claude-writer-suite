# Bottleneck catalogue

Patterns that dominate in practice, with the measurement that reveals each and
the fix that addresses it.

## N plus 1

```
Reveal   count queries per request; the count grows with the row count
Shape    a loop over rows, each iteration loading a relation
Fix      one query with a join, or a batched load keyed by identifier
Trap     the ORM version is invisible in the code and obvious in the log
```

The most common serious backend bottleneck, and the one most often missed in
review because the code reads cleanly.

## Missing or unused index

```
Reveal   explain, sequential scan on a large table, or an index present and
         not chosen
Fix      an index matching the query shape, equality columns first
Trap     an index on a low cardinality column changes nothing
Trap     a function applied to the column prevents the index from being used
Cost     every index slows writes; count the existing ones first
```

## Unbounded query

```
Reveal   latency and memory grow with the data, not with the request
Shape    no limit, no pagination, select of every column
Fix      pagination contract with a maximum, explicit column list
```

## Serial external calls

```
Reveal   request latency equals the sum of the dependencies
Fix      concurrent execution for independent calls
Trap     making dependent calls concurrent produces a race, not a speedup
```

## Oversized payload

```
Reveal   response size measured; serialisation time in the profile
Shape    the entity serialised whole, with relations included by default
Fix      explicit field list, relations loaded on request
Bonus    this is also the fix for a class of data exposure defect
```

## Blocking the request path

```
Reveal   throughput collapses under load while a single request looks fine
Shape    a synchronous computation, a file operation, or an email send inside
         the request
Fix      move it off the path: a job, a queue, or after the response
```

## Long transactions

```
Reveal   lock waits, connection pool exhaustion, timeouts under load
Shape    a network call or a long computation inside a transaction
Fix      shorten the transaction to the writes that must be atomic
```

## Bundle size

```
Reveal   build output, largest modules
Shape    a whole library imported for one function, a heavy component on the
         initial route, duplicate versions of the same package
Fix      import the function, split the route, deduplicate the lockfile
Trap     tree shaking claims are frequently untrue for a given configuration
```

## Render storms

```
Reveal   the framework profiler, renders per interaction
Shape    an unstable reference passed to a memoised child, context holding a
         value that changes on every render, state lifted too high
Fix      stabilise the reference, split the context, move state down
Trap     adding memoisation without measuring usually adds cost
```

## Layout thrash

```
Reveal   forced reflow entries in the trace
Shape    reading a layout property and writing a style, in a loop
Fix      batch reads, then writes; use transform rather than layout properties
```

## Images

```
Reveal   transfer size, layout shift score
Fix      explicit dimensions, modern format, responsive sources, lazy below
         the fold, the project's image pipeline
```

## Cache with a bad key

```
Reveal   a hit rate near zero, or stale data reported as a bug
Shape    a key missing a dimension that the value depends on, such as the
         user, the locale or the permission set
Fix      the key includes every input the value depends on
Danger   a cache keyed too broadly is a data leak, not a performance problem
```

## Ordering of investigation

Count before timing. Counts are cheap to measure, stable across machines, and
usually point straight at the dominant cost. Timing comes second, to confirm
that the count was the cost.
