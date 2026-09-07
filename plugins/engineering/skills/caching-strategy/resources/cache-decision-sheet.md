# Cache decision sheet

One sheet per cached value. If a line cannot be filled, the cache is not ready
to exist.

```
VALUE
  what           <the data being cached>
  read cost      <measured: query time, computation, payload size, frequency>
  read frequency <per second, per user, per page>
  structural fix <what was tried first, and why it was not enough>

STALENESS
  budget         <how long a stale value is acceptable>
  decided with   <who owns this data>
  consequence    <what happens at the end of that window if it is wrong>

LAYER
  chosen         <browser | CDN | proxy | process memory | shared | database>
  reason         <why not closer to the consumer, why not further>

KEY
  scheme         <entity:id:version:variant>
  varies by      <caller, role, tenant, locale, currency, flags, version>
  validated      <which key components come from client input, and how they
                  are validated before use>

INVALIDATION
  mechanism      <ttl | write through | delete on write | key version | event>
  on failure     <what happens if the invalidation is lost>
  worst case     <how long a wrong value can survive>

FAILURE MODES
  stampede       <lock | single flight | staggered ttl | accepted, with reason>
  cold start     <warm up | accepted, with the measured cost>
  cache down     <degrades to source, verified how>
  negative       <are errors cached, for how long, and why>

VERIFICATION
  correctness    <the test proving two callers cannot see each other's value>
  disabled       <the run with the cache off, and the result>
  delta          <before and after, measured, same conditions>
```

## The two tests that must exist

```
1 two callers, different permissions, same resource, sequential requests.
  The second must not receive the first one's response. Written for every
  cache whose value varies by caller.

2 the application with the cache unavailable. Every critical journey still
  works, slower. Written once per cache layer, run in the reliability pass.
```

## Time to live, chosen from consequence

```
immutable asset with a hashed name        one year
public marketing content                  minutes to hours
a list the user just modified             zero, or invalidated on write
a dashboard aggregate                     the staleness budget, usually minutes
a permission or a role                    never cached without revocation
a price shown before purchase             never stale at the moment of charge
a session                                 its own lifetime, not a cache ttl
```

## Signs a cache is being used to hide a defect

```
the time to live keeps getting longer
nobody can say what invalidates the entry
the cache is in front of a query nobody has read
disabling it makes the application unusable rather than slower
support has a runbook step called "clear the cache"
```

The last one is diagnostic. A product whose support procedure includes
clearing a cache has an invalidation defect, not a caching strategy.
