---
name: caching-strategy
description: Decides whether to cache at all, then where, for how long, keyed by what, and how the entry is invalidated: browser and HTTP caching, CDN, application and shared caches, computed values, stampede protection, and the correctness rules that keep one user from seeing another user's data. Use when a read is measurably expensive, never because a cache is available.
license: MIT
metadata:
  category: dev-skills
  version: 1.0.0
  depends_on: [engineering-core, performance-engineering]
  outputs: [cache-decision, key-design, invalidation-plan, staleness-budget]
---

# Caching Strategy

A cache trades correctness for speed. That trade is sometimes excellent and
always a trade, so it is made deliberately, with a measurement on one side and
a written staleness budget on the other.

The two classic failures: caching before measuring, and caching without
deciding who the entry belongs to.

## 1. Do not cache yet

Before adding a cache, exhaust the cheaper fixes:

```
the missing index
the query in a loop
the payload returning fields nobody uses
the recomputation of something already in memory
the request the client makes three times per page
the endpoint called on every keystroke with no debounce
```

A cache in front of an unindexed query hides a defect and makes the first
request after every eviction terrible. `performance-engineering` produces the
measurement that decides.

## 2. What may be cached

```
safe        immutable content, addressed by a content hash
safe        public data equal for every caller
careful     data scoped to one caller, only with the caller in the key
careful     computed aggregates, with an explicit staleness budget
dangerous   anything whose staleness has legal, financial or safety weight
never       an authorization decision, unless revocation is part of the design
never       a response whose body varies by permission but whose key does not
```

The rule that prevents the worst incident in this discipline: **the cache key
contains everything the response varies by**. Caller, role, tenant, locale,
currency, feature flags, version.

## 3. Layers

| Layer | Fits | Invalidation |
|---|---|---|
| immutable asset | files with a content hash in the name | never, the name changes |
| browser cache | per user, small, short lived | headers, and a version in the URL |
| CDN | public content, global reach | purge, or a short time to live |
| reverse proxy | public or cheaply keyed responses | purge or time based |
| application memory | small, hot, per process | time based, process restarts clear it |
| shared cache | expensive computations shared across processes | explicit, on write |
| database materialised view | heavy aggregates | refresh, scheduled or triggered |
| client state | data already fetched in this session | on navigation or on mutation |

Cache as close to the consumer as correctness allows, and no closer.

## 4. Keys

```
include everything that changes the value
name the key with a scheme: entity, identifier, version, variant
version the key when the shape changes, so old entries expire naturally
never key by something the client controls without validating it first
keep keys short enough to read in a log line
document the key scheme where the code builds it
```

Changing the key is the safest invalidation there is: nothing to purge, the
old entries fall out on their own.

## 5. Invalidation

```
time based     the default: a time to live matched to the staleness budget
write through  update the cache when the source changes, in the same path
delete on write clear the entry and let the next read repopulate, simplest
version bumping change the key, avoid deletion entirely
event driven   a subscriber invalidates on a change elsewhere, with the
               failure mode decided: what happens when the event is lost
```

Every cached value has an answer to: what happens if this is stale for an
hour? If the answer is `nobody notices`, use a long time to live and stop
engineering. If it is `we bill wrongly`, do not cache it.

## 6. The failure modes

```
stampede        many callers miss at once and all recompute. Fix with a lock,
                a single flight, or staggered expiry
cold start      after a deploy or a restart, everything misses at once
thundering
  invalidation  clearing a prefix invalidates far more than intended
stale forever   an entry with no expiry and a broken invalidation path
negative caching an error or an empty result cached as if it were the truth
memory pressure  eviction removes the entries that were carrying the system
partial writes   the source is updated and the cache update fails, leaving a
                 permanent lie
```

For each one used in the design, state the mitigation in writing.

## 7. HTTP caching, specifically

```
Cache-Control on every response, explicitly, including no-store where needed
private for anything user specific, and never public by accident
ETag or Last-Modified where revalidation is cheaper than a full response
Vary on every header the response depends on, including authorization
authenticated responses never cached by a shared cache without private
a version in asset URLs, so an asset can be cached for a year
```

The single most common data exposure in this area: a shared cache storing an
authenticated response because nothing said `private`.

## 8. Prohibitions

- Never add a cache before measuring the cost of the read.
- Never cache a response whose body varies by permission without the
  permission in the key.
- Never cache an authorization decision without a revocation path.
- Never introduce a shared cache service for one endpoint.
- Never leave a cached entry with no expiry and no invalidation path.
- Never cache an error indefinitely.
- Never let a cache failure become an application failure: a cache miss and a
  cache outage must both degrade to the source.

## 9. Protocol

1. Measure the read and prove it is expensive.
2. Exhaust the structural fixes first.
3. Decide the staleness budget, in words, with the person who owns the data.
4. Choose the layer closest to the consumer that preserves correctness.
5. Design the key, including every dimension the value varies by.
6. Choose the invalidation mechanism and write down its failure mode.
7. Address stampede, cold start and negative caching explicitly.
8. Verify with the cache disabled, so a cache outage is survivable.
9. Measure again and record the delta.
10. Document the key scheme, the budget and the invalidation in the code.

## 10. Auto-critique

Score from 0 to 5: measurement first, structural fixes exhausted, staleness
budget written, layer choice, key completeness, invalidation with a stated
failure mode, stampede and cold start handled, behaviour verified with the
cache unavailable, delta measured.

Threshold: no axis below 3, average at least 4. A cached response that varies
by permission without the permission in the key is an automatic failure,
whatever it does for latency.

## 11. Interfaces

- Upstream: `performance-engineering` for the measurement,
  `architecture-design` for where the cache belongs.
- Lateral: `backend-engineering` and `frontend-engineering` for
  implementation, `api-design` for the HTTP headers, `security-audit` for
  exposure through shared caches.
- Downstream: `reliability-testing` for behaviour when the cache is
  unavailable, `observability` for hit rate and staleness, `testing-quality`
  for the correctness tests.
