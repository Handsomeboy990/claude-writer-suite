# Upload adversarial matrix

Every row is run against every upload surface. Expected behaviour is a clean
rejection with a useful message, never a crash and never an acceptance.

## Identity and limits

| # | Case | Expected |
|---|---|---|
| 1 | no credentials | 401, no bytes read |
| 2 | authenticated, wrong role | 403, no bytes read |
| 3 | upload targeting another owner's resource | 404 or 403 |
| 4 | file one byte over the limit | rejected, streaming stopped early |
| 5 | declared size small, actual size huge | rejected while streaming |
| 6 | more files than the per request maximum | rejected |
| 7 | request with no file | 400 |
| 8 | connection cut mid upload | no partial record, no orphan reachable |

## Type

| # | Case | Expected |
|---|---|---|
| 9 | executable renamed with an image extension | rejected by content detection |
| 10 | correct extension, corrupted content | rejected at parse |
| 11 | valid image with a script in its metadata | accepted, metadata stripped |
| 12 | SVG containing script | rejected, or stored and served as a download from a separate origin |
| 13 | HTML file where documents are allowed | served as a download, never inline on the app origin |
| 14 | archive containing a path traversal entry | rejected at extraction |
| 15 | polyglot file valid as two types | rejected, one detected type only |
| 16 | zero byte file | rejected or accepted deliberately, never a crash |

## Names

| # | Case | Expected |
|---|---|---|
| 17 | name with path separators or parent references | neutralised, never used as a path |
| 18 | name with a null byte or control characters | rejected |
| 19 | name of 4000 characters | truncated in metadata, generated name stored |
| 20 | name identical to an existing file | no collision, generated names are unique |
| 21 | name with unicode that normalises to another name | no collision, no confusion |
| 22 | name that is a reserved device name on some systems | never used on disk |

## Processing

| # | Case | Expected |
|---|---|---|
| 23 | image declaring enormous dimensions | rejected before decoding |
| 24 | highly compressed archive or image bomb | rejected by a size or ratio limit |
| 25 | document with thousands of pages | rejected or bounded |
| 26 | conversion that hangs | killed by timeout, job fails cleanly |
| 27 | conversion failing after the record exists | record reflects the failure, no phantom derivative |

## Delivery

| # | Case | Expected |
|---|---|---|
| 28 | download by a user without access | 404 or 403 |
| 29 | download with a guessed identifier | not found, identifiers are opaque |
| 30 | expired signed URL | rejected |
| 31 | signed URL shared with another user | works only if that is the intent, and it is documented |
| 32 | response headers on a text file | correct type, download disposition, no sniffing |
| 33 | uploads served from the application origin | none, for anything scriptable |

## Lifecycle

| # | Case | Expected |
|---|---|---|
| 34 | record deleted | file deleted or scheduled by the retention rule |
| 35 | storage write fails after the record is written | no record claiming a missing file |
| 36 | record write fails after the storage write | the file is cleaned up by the orphan job |
| 37 | orphan job run | files with no record removed after the grace period |
| 38 | tenant deleted | every file of that tenant removed, verified |

## Recording

```
surface: POST /api/v1/documents/{id}/attachments
run by: <role>   environment: <name>   build: <commit>

rows 1 to 38, each pass | fail | n/a with the reason
findings handed to test-reporting
```
