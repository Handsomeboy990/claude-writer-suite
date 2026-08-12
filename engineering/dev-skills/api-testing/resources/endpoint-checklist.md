# Endpoint checklist

One sheet per endpoint. Every row is `pass`, `fail` or `n/a` with a reason.
Empty means not run, which is different from passing.

```
endpoint: POST /api/v1/<resource>        auth: session        role: admin
```

## Identity

| # | Case | Expected |
|---|---|---|
| 1 | no credentials | 401, no data, no side effect |
| 2 | malformed token or cookie | 401, same body as case 1 |
| 3 | expired credentials | 401 |
| 4 | credentials revoked since issue | 401 |
| 5 | valid credentials, wrong role | 403 |
| 6 | valid credentials, another owner's resource | 404 or 403, consistently |
| 7 | valid credentials, another tenant's resource | same as case 6, never 200 |

Cases 6 and 7 decide whether the API has object level authorization or only a
login check. They are run with two accounts the campaign owns.

## Input

| # | Case | Expected |
|---|---|---|
| 8 | every required field present and valid | declared success status |
| 9 | each required field missing, one at a time | 400 or 422, field named |
| 10 | each field with a wrong type | rejected, never coerced silently |
| 11 | boundary values, minimum and maximum | accepted |
| 12 | one beyond each boundary | rejected with a field level message |
| 13 | unknown extra fields | ignored or rejected, by declared policy |
| 14 | a field the client should not control, such as role, owner, price | ignored, never applied |
| 15 | empty body | 400, not 500 |
| 16 | body that is not valid JSON | 400, not 500 |
| 17 | wrong content type | 415 or 400, declared and consistent |

Case 14 is mass assignment. It is checked on every write endpoint that accepts
an object, without exception.

## Path and query

| # | Case | Expected |
|---|---|---|
| 18 | unknown identifier | 404 |
| 19 | identifier of the wrong type | 400 or 404, never 500 |
| 20 | identifier of a deleted resource | 404, or the declared soft delete behaviour |
| 21 | unknown query parameter | ignored, documented |
| 22 | invalid value on a known query parameter | 400, not silently ignored |
| 23 | sort by a field that does not exist | 400, never a database error |
| 24 | filter by a field the caller may not see | 400 or 403, never a filtered leak |

## Output

| # | Case | Expected |
|---|---|---|
| 25 | success body matches the declared shape exactly | every declared field present |
| 26 | no field beyond the declared shape | no internal identifiers, no hashes, no tokens |
| 27 | content type header correct | as declared |
| 28 | error body shape identical to the rest of the API | same structure everywhere |
| 29 | no internal detail in any error | no stack, no SQL, no path, no host |
| 30 | cache headers correct for authenticated data | no shared cache on private responses |

## Collections

| # | Case | Expected |
|---|---|---|
| 31 | empty collection | 200 with an empty list, not 404 |
| 32 | first page, next page, last page | consistent, no duplicates, no gaps |
| 33 | beyond the last page | empty list, not an error |
| 34 | page size above the maximum | capped, declared, not obeyed blindly |
| 35 | invalid cursor or offset | 400 |
| 36 | deterministic order, including equal sort keys | stable across identical calls |
| 37 | only rows the caller may see | verified with a second account |

## Effects

| # | Case | Expected |
|---|---|---|
| 38 | duplicate identical request, sequential | one effect, or a declared 409 |
| 39 | duplicate identical request, concurrent | one winner, one clean loser |
| 40 | replay with the same idempotency key | original response, no second effect |
| 41 | request that fails after a partial write | nothing persisted, or a documented compensation |
| 42 | side effects observed: mail, job, webhook, external call | exactly once |

## Limits

| # | Case | Expected |
|---|---|---|
| 43 | rate limit reached | 429 with the declared retry information |
| 44 | payload above the size limit | 413 or 400, never a crash |
| 45 | slow client, or a request cut mid body | handled, no half written record |

## Sheet footer

```
run by: <role used>        environment: <name>        build: <commit>
resources created: <list>  cleaned up: yes | no, with reason
findings: <ids handed to test-reporting>
```
