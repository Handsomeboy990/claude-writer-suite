# Example: an authorized tenant isolation run

## Boundary, confirmed before anything ran

```
Application    staging.<product>.example.com only
Build          4c17ab9
Accounts       tenant A: admin, member. tenant B: admin. All created for this
               engagement, no real customer accounts.
Data           may create documents and exports in both tenants, must delete
               them afterwards
Destructive    forbidden
Availability   forbidden, no scanning, no load
Authorised by  head of engineering, in the campaign ticket, 2026-08-03
Stop           any response from a production host, any real personal data
```

Everything below happened inside that paragraph.

## Step 1, the identifier survey

Before testing access, find out what identifiers look like.

```
document id    doc_000148, doc_000149, doc_000150     sequential
export id      exp_a91f...                             opaque
user id        numeric, visible in the members list
tenant id      present in the session cookie payload and in three API paths
```

Sequential document identifiers mean an isolation defect, if one exists, is
trivially exploitable at scale. That raises the severity of anything found on
that route, and it is recorded now rather than argued later.

## Step 2, every route to one object

Document `doc_000148` belongs to tenant A. Requested as tenant B admin:

```
route                                          result   expected
GET  /documents/doc_000148            (page)   403      403   ok
GET  /api/v1/documents/doc_000148              200      403   FINDING
GET  /api/v1/documents/doc_000148/export       200      403   FINDING
GET  /api/v1/documents?search=<title>          empty    empty  ok
GET  /api/v1/documents/doc_000148/comments     200      403   FINDING
GET  /files/doc_000148/preview.png             200      403   FINDING
POST /api/v1/documents/doc_000148/share        403      403   ok
```

The page checks. Four API routes do not, and one static file path does not
check at all. The interface was never the control.

Evidence kept: the first line of one response, and the status codes. Not the
document contents, because the document belongs to another tenant even in
staging, and nothing beyond proof is retrieved.

## Step 3, inference without access

```
GET /api/v1/documents/doc_999999   404 "not found"
GET /api/v1/documents/doc_000148   200                  before the fix
after the fix:
GET /api/v1/documents/doc_000148   404 "not found"      same body as above
```

The fix returns 404 rather than 403 for an object in another tenant, which is
the right choice here: 403 would confirm that the identifier exists.

Timing was compared across twenty requests to existing and non existing
identifiers. No usable difference. Recorded as checked, because an isolation
report that does not mention inference has not finished the question.

## Step 4, tenant identifier manipulation

```
change the tenant id in the API path            403, correct
change the tenant id in the request body        ignored, server derives it
change the tenant claim in the session cookie   signature invalid, 401
add an X-Tenant-Id header                       ignored
switch tenant through the UI switcher as an
  admin of tenant A, targeting tenant B         403, correct
```

All correct. Recorded, because the campaign must be able to say what held, not
only what broke.

## Step 5, the write side

```
POST /api/v1/documents            with tenant B's id in the body    ignored, ok
PATCH /api/v1/documents/doc_000148 as tenant B                      403, ok
DELETE as tenant B                                                  403, ok
POST /api/v1/documents/doc_000148/comments as tenant B              201  FINDING
```

Comments could be created on another tenant's document. Read and write use two
different loaders, and only one of them checks.

## Finding as reported

```
SEC-01   Tenant isolation missing on the documents API and file routes
Severity Critical        Confidence Confirmed
Routes   GET /api/v1/documents/{id}, /export, /comments,
         GET /files/{id}/preview.png, POST /comments
Cause    the API loader fetches by primary key with no tenant predicate. The
         page controller applies the predicate; the API and the file handler
         do not.
Impact   any authenticated user of any tenant can read and comment on any
         document. Identifiers are sequential, so enumeration is trivial.
Proof    two accounts owned by the engagement, one request per route, status
         codes recorded, response bodies not retained.
Fix      apply the tenant predicate in the shared loader and make the raw
         fetch private to it. Serve files through an authorising handler.
Retest   after the fix, all six routes return 404 for another tenant, and the
         permanent test suite covers each route.
```

## Cleanup

Three documents, two exports and four comments created by the engagement were
deleted. Sessions created during the run were revoked. The environment was
left as it was found, and that line appears in the report.

## What was handed on

```
backend-engineering   the shared loader fix and the file handler
testing-quality       six permanent tests, one per route, run as tenant B
api-testing           the same pattern checked across the other 14 resources
technical-documentation  the 404 over 403 decision, recorded so a future
                      change does not helpfully make it a 403 again
```
