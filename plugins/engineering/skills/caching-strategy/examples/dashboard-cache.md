# Example: caching a dashboard, and one incident avoided

Symptom: the dashboard takes 4.2 seconds. Someone proposes putting the whole
response in a shared cache for five minutes.

## Measurement first

```
total 4200 ms
  1  aggregate query over invoices          2900 ms
  2  member list                              180 ms
  3  plan and seat count                       40 ms
  4  serialisation of 2.1 MB of JSON          420 ms
  5  everything else                          660 ms
```

Two structural fixes, before any cache:

```
the aggregate query had no index on (organisation_id, issued_at). Adding it:
  2900 ms becomes 240 ms.
the response included every invoice line for every invoice, of which the
  dashboard displays six totals. Trimming the payload: 2.1 MB becomes 34 KB,
  serialisation 420 ms becomes 12 ms.

total after structural fixes: 640 ms, with no cache at all
```

The proposed cache would have hidden both defects, kept 2.1 MB flowing to
every client on every miss, and made the first load after each eviction worse
than before.

## What was then genuinely worth caching

One value remained expensive: a twelve month revenue trend, recomputed on
every visit, 380 ms of the remaining 640.

```
VALUE          twelve month revenue trend per organisation
read cost      380 ms, several times per user per day
staleness      budget: 15 minutes. Decided with finance, who confirmed that
               the trend is a management view, not a billing figure.
layer          shared cache, since several processes serve the same
               organisation and process memory would multiply the misses
key            revenue-trend:v2:{organisationId}:{currency}
varies by      organisation, currency. Not by user: every member with access
               sees the same numbers, and access is checked before the read.
invalidation   ttl 15 minutes, plus delete on write when an invoice is issued
               or voided, because finance staff expect their own correction to
               appear immediately
on failure     if the delete is lost, the value is wrong for at most 15
               minutes, which is the stated budget
stampede       single flight per key: the first miss computes, the others wait
cold start     acceptable, measured at 380 ms for the first request after a
               deploy, per organisation
cache down     the endpoint computes directly. Verified by stopping the cache
               in the reliability drill: the dashboard served in 640 ms.
```

## The incident that was avoided in review

The first key proposed was `revenue-trend:{organisationId}`. During review
someone asked what happens for an organisation that displays in two
currencies. The answer: a member in the currency-switched view would have seen
the other currency's numbers, correctly formatted and completely wrong.

Adding `{currency}` cost nothing. Finding it in production would have cost a
trust problem with a finance team, which is the expensive kind.

The `v2` in the key comes from the same review: the shape of the cached object
was about to change, and bumping the key version meant no purge and no
transitional code path.

## The two tests written

```
1 two organisations, sequential requests, same process. Each receives its own
  trend. The test fails if the key omits the organisation, which is exactly
  how this class of defect appears.

2 the same organisation in two currencies. Each receives its own figures.
  This test exists because of the review above, and it is the one that would
  have caught the original design.
```

## Result

```
before   4200 ms
after    260 ms warm, 640 ms cold
cache    one value, one key scheme, one written staleness budget

what was not cached
  the member list, now 180 ms and correct at every load
  the seat count, which feeds a limit and must never be stale
  the invoice list itself, since users edit it and expect to see their edit
```

Three quarters of the improvement came from an index and a payload, neither of
which needed a cache. That ratio is normal, and it is the reason the
measurement comes first.
