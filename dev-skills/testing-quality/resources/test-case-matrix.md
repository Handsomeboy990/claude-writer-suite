# Test case matrix

Ten mandatory families. For each feature, every applicable row has a test or a
written reason for its absence.

| # | Family | Question the test answers |
|---|---|---|
| 1 | happy path | does the feature do what it was written for |
| 2 | invalid input | is each validated field actually rejected |
| 3 | empty data | what does a first time user see |
| 4 | error path | what happens when a query or a call throws |
| 5 | unauthenticated | is the door locked |
| 6 | unauthorized | is the right person behind the right door |
| 7 | duplicates | does clicking twice do it twice |
| 8 | boundaries | minimum, maximum, one beyond each |
| 9 | external failure | provider down, provider slow, provider wrong |
| 10 | business rules | the rules the feature exists to enforce |

## Expansion by feature type

### A create endpoint

```
creates the resource and returns the declared shape
rejects each invalid field
rejects an unauthenticated caller with 401
rejects an authorized-for-nothing caller with 403
rejects a duplicate, sequentially
rejects a duplicate, concurrently, with one winner
enforces the quota at the limit and one beyond
rolls back cleanly when the post commit effect fails
```

### A list endpoint

```
returns an empty array for a new account, not a 404
returns only rows the caller owns
paginates: first page, next page, last page, beyond the last
caps the page size at the maximum
rejects an invalid cursor
orders deterministically, including for equal sort keys
```

### A form component

```
renders the loading state
renders the empty state
renders the error state and retries
shows field errors and moves focus to the first invalid field
preserves input after a failed submit
disables submit while pending
is operable by keyboard alone
```

### A background job

```
processes the expected work
is idempotent when run twice on the same input
is bounded when the input set is large
records a failure without losing the remaining work
does not overlap destructively with a concurrent run
```

### A migration

```
applies on a database at the previous revision
rolls back, or is documented irreversible with the reason
the previous application version still works after it applies
the new application version works before the drop step
backfill handles a row that violates the new assumption
```

## Boundary values worth writing every time

| Data | Cases |
|---|---|
| collection | zero, one, exactly the page size, page size plus one |
| string | empty, minimum, maximum, maximum plus one |
| number | zero, negative, minimum, maximum, maximum plus one |
| money | zero, the smallest unit, a value that would round badly as a float |
| date | today, the boundary of the window, one second either side, a leap day |
| permissions | owner, member, non member, admin, revoked member |
| concurrency | two identical requests at the same instant |

## Reasons that justify an absent test

Acceptable, when written down:

```
n/a: the feature has no authorization surface, it is public by design
n/a: no external service is involved
deferred: no mail sandbox in the test environment, covered by a stub at the
  client boundary, recorded in continuity notes
```

Not acceptable:

```
the code is simple
it is covered indirectly
we will add it later
it is hard to test
```

The last one is a design signal, not an excuse. Code that is hard to test
usually has a responsibility in the wrong place.
