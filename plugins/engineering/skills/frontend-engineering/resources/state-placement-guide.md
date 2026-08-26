# State placement guide

Six homes, checked in order. The first that fits is the answer.

## 1. Derived

The value can be computed from state that already exists.

```
selectedItem      derive from items and selectedId
isValid           derive from the field values
totalPrice        derive from the cart lines
filteredList      derive from list and query
```

Storing a derived value creates two sources of truth that drift apart. The
only reason to store one is a measured computation cost, and then it is
memoised, not duplicated.

## 2. Local

Used by exactly one component and its immediate rendering.

```
isDropdownOpen, hoveredIndex, uncontrolled input draft, isTooltipVisible
```

## 3. Lifted

Two or more siblings need it. One parent owns it and passes it down. Lift no
higher than the closest common ancestor.

Symptom of over lifting: a value in a top level provider that three components
read and one writes, all of them in the same subtree.

## 4. URL

The user should be able to reload, share, bookmark or use the back button.

```
search query, active filters, sort order, page number, active tab,
selected entity in a master detail view, an open modal that has an address
```

This is the most frequently missed home. A dashboard whose filters reset on
reload is not a styling problem; it is state in the wrong place.

Constraints: keep the parameters short and readable, validate them on read
since a URL is external input, and give every parameter a default so a bare
URL works.

## 5. Server cache

The value came from the server. It belongs to whatever the project uses to
cache server data, with its own key, staleness policy and invalidation.

Never copied into a client store. The copy goes stale, and the bug that
follows is reported as data appearing wrong at random.

Invalidation is decided when the mutation is written, not later.

## 6. Global client

Genuinely cross cutting, client owned, and not server data.

```
theme, locale preference, a collapsed sidebar, a feature flag snapshot,
an in flight toast queue
```

If a candidate does not appear in a list like that one, it is probably server
cache or URL state wearing a disguise.

## Decision examples

| Value | Home | Why |
|---|---|---|
| current user profile | server cache | it comes from the server and can change there |
| is the profile dropdown open | local | one component, no sharing, no reload meaning |
| dashboard date range | URL | shared links and reload must preserve it |
| unsaved form draft | local, or persisted deliberately | recovery is a product decision |
| list of orders | server cache | server owned, paginated, invalidated on mutation |
| which order row is expanded | local or URL | URL when a link to an expanded row is meaningful |
| dark mode | global client | cross cutting, client owned |
| permission set | server cache | server owned, never trusted for authorization anyway |
| toast messages | global client | cross cutting and ephemeral |
| selected rows for a bulk action | lifted | the toolbar and the table both need it |

## Rules that prevent the common defects

1. Server data has exactly one home. A second copy is a bug waiting.
2. Anything the user would expect to survive a reload goes in the URL.
3. A global store that grows entities is a cache reimplemented badly.
4. State that only one component reads is never lifted for tidiness.
5. Every store addition names its reader and its writer before it is added.
