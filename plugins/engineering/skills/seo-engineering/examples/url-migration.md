# Example: changing a URL structure without losing the traffic

The change: a catalogue moving from `/p/1482-blue-widget` to
`/widgets/blue-widget`, because the numeric identifier is meaningless and the
category is useful.

The risk: 62 percent of the site's traffic arrives on catalogue pages from
search.

## What was done before touching a route

```
1  exported every existing address that returns 200: 4,180 pages
2  exported the addresses that receive search traffic: 1,240 pages, of which
   the top 100 account for most of it
3  exported the addresses that receive inbound links from other sites
4  produced the mapping old to new, one to one, generated from the same data
   the routes use, not written by hand
5  identified 340 old addresses with no new equivalent: products removed over
   the years, still receiving traffic
```

Item 5 is the one that decides quality. Three options were weighed and
recorded:

```
redirect to the category page       chosen for 290 of them, where the
                                    category is a genuine alternative
return 410 gone                     chosen for 50 discontinued lines with no
                                    equivalent, because a permanent signal is
                                    more honest than a redirect to a page the
                                    visitor did not want
redirect to the home page           rejected. It preserves nothing and gives
                                    the visitor a worse experience than a
                                    clear message.
```

## The migration

```
1  new routes deployed and serving, old routes still serving. Both live, both
   returning 200, canonical on both pointing at the new address. One day in
   this state, verified.
2  internal links updated to the new addresses in the same release, so that
   nothing internal depends on a redirect.
3  old routes switched to permanent redirects, generated from the same map.
   Verified: 4,180 redirects, zero chains, zero loops, checked by a script
   that follows every one.
4  sitemap regenerated with the new addresses only. Old sitemap retired.
5  structured data and breadcrumbs updated to the new hierarchy.
```

Step 1 is the part usually skipped. Serving both for a day, with a canonical
pointing at the new address, means the change can be reverted with a
deployment rather than with a second migration.

## Verification, automated

```
every old address returns 301 to exactly one new address        4180 / 4180
no redirect chain longer than one hop                           verified
every new address returns 200                                   3840 / 3840
every new address is canonical to itself                        verified
every new address appears in the sitemap                        verified
no old address appears in the sitemap                           verified
no internal link points at an old address                       verified
the 50 discontinued products return 410 with a useful page      verified
```

Eight assertions, run as a script, re-run after every deployment for a month.

## Monitoring after the change

```
week 1   crawl errors flat, redirects being followed as expected
week 2   impressions on new addresses rising, old addresses falling
week 4   aggregate traffic within 3 percent of the pre-change baseline
week 6   old addresses largely dropped from results, new ones established
```

One finding in week 2: 14 pages had a title generated from the old slug and
now read oddly. Fixed and redeployed, which is exactly why the traffic is
watched for a full indexing cycle rather than for a weekend.

## What would have happened without the map

The common shortcut is a catch-all rule redirecting `/p/*` to `/widgets`.
Every one of the 1,240 pages receiving search traffic would have lost its
identity, the 340 removed products would have looked identical to the live
ones, and the recovery would have taken a quarter. The map cost an afternoon.
