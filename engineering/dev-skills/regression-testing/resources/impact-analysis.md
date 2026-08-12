# Impact analysis

From a diff to a set of features that must be re-verified. The expansion is
mechanical: each rule is applied to every changed file, and the result is a
list of user visible behaviours, not a list of files.

## Expansion rules

| What changed | What enters the impact set |
|---|---|
| a handler or controller | that endpoint, its callers, anything sharing its service |
| a service or use case | every handler and job calling it |
| a shared utility or helper | every feature importing it, without exception |
| a base component | every screen rendering it, at every supported width |
| a hook or store | every component consuming it, plus its persistence behaviour |
| a query or repository method | every read that uses it, plus its permission filter |
| a migration | every read and write of the touched tables, plus the previous release if it still runs |
| an index | the queries it serves, and their plans |
| a validation schema | every entry point using it, and its error messages |
| middleware | every route behind it, including the ones nobody remembers |
| authentication or session code | every authenticated flow, plus expiry and revocation |
| authorization code | the whole role matrix, no shortcuts |
| a configuration default | every environment where the default applies |
| a feature flag | both sides of the flag |
| a dependency | everything it touches, which is why it forces a full suite |
| a build or bundler setting | the built artefact itself, not only the tests |
| a translation file | the locale changed, plus layout at the longest string |
| a webhook consumer | replay, duplicates, and out of order delivery |

## Blast radius signals

A change is wider than it looks when any of these is true:

```
the file is imported in more than ten places
the file name contains base, common, shared, util, core, helper
the change is in a template, layout or wrapper
the change alters a default value rather than adding a branch
the change touches a type used across a boundary
the change is a rename that a search-and-replace performed
the change modifies a query used by a list and a detail view
```

## From files to behaviours

The impact set is written as behaviours, because tests are selected by
behaviour:

```
Changed   lib/pricing/discount.ts, lib/cart/total.ts
Impact
  cart total with and without a discount
  checkout summary and the amount actually charged
  invoice generation, which reuses total()
  the reporting export, which recomputes totals independently
  the admin refund screen, which displays a stored total
Not impacted
  catalogue browsing, no price computation on that path
  authentication, no shared code
```

The `Not impacted` list matters as much as the other one: it is where a
reviewer disagrees, and where a missed regression is caught before it ships.

## Data impact

For any change touching persistence:

```
rows written before the change, read after it
rows written after the change, read by the previous release
nullable becoming required, on existing rows
a default added, on rows that predate it
an enum value removed, still present in stored data
a backfill, and the state halfway through it
```

## Recording the analysis

```
diff        <range or description>
files       <count>, of which shared: <count>
impact set  <behaviours, ordered by consequence>
excluded    <behaviours considered and excluded, with the reason>
tier        <the tier chosen, and why it stops there>
```

The excluded list is the honest part of the document. A regression analysis
with nothing excluded either ran everything, or did not think.
