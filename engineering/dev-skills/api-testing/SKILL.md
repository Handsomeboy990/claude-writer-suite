---
name: api-testing
description: Verifies an HTTP surface against its contract rather than against its happy path: methods, authentication, authorization, headers, parameters, request and response shapes, status codes, error bodies, pagination, filtering, idempotency, concurrency, rate limits and malformed input. Use whenever a project exposes or consumes an API, and before any contract is published.
license: MIT
metadata:
  category: dev-skills
  version: 1.0.0
  depends_on: [engineering-core, testing-quality]
  outputs: [endpoint-inventory, contract-tests, contract-deviations, error-shape-report]
---

# API Testing

An API is a promise made to code that cannot ask questions. This skill checks
that the promise is kept for the requests nobody sends deliberately, not only
for the one in the documentation.

A `200` is where the test starts.

## 1. What belongs here

```
Yes   status codes, response and error shapes, headers, content types
Yes   authentication and authorization per endpoint, including no token at all
Yes   validation of every parameter and every body field
Yes   pagination, filtering, sorting, search, and their boundaries
Yes   idempotency, duplicate and concurrent requests
Yes   rate limits, where they exist
No    business rules that a unit test can observe more cheaply
No    rendering, which belongs to the browser layer
No    load, which is performance-engineering
```

## 2. Establish the contract before testing it

The contract is, in order of authority: a published specification, generated
types, then the handler code itself. When the specification and the code
disagree, that disagreement is the first finding.

Build an inventory before writing anything:

```
method and path
authentication required, and of what kind
authorization rule, and which role satisfies it
parameters: path, query, header, body, and which are required
success status and body shape
declared error statuses and their body shape
side effects: writes, mails, jobs, external calls
idempotency: declared, implied, or absent
rate limit, if any
```

An endpoint whose authorization rule cannot be named from the code is a
finding before a single request is sent.

## 3. Per endpoint

Every row of `resources/endpoint-checklist.md` is exercised or marked not
applicable with a reason. The compressed version:

```
1  valid request, declared status, declared shape, every documented field
2  no credentials at all
3  malformed credentials, expired credentials
4  valid credentials, insufficient role
5  valid credentials, another owner's resource
6  unknown identifier
7  identifier of the wrong type
8  each required field missing, one at a time
9  each field with an invalid value, one at a time
10 boundary values on every constrained field
11 unknown extra fields in the body
12 wrong content type, and no content type
13 wrong method on the same path
14 duplicate identical request, sequential
15 duplicate identical request, concurrent
16 pagination: first, last, beyond last, oversized page, invalid cursor
17 filtering and sorting, including an invalid field name
18 rate limit, where declared
```

Rows 4 and 5 are the two most often skipped and the two most likely to be
exploitable. `security-testing` takes them further, across the whole role
matrix; here they are checked once per endpoint.

## 4. Status codes mean things

An API that returns `200` with an error body, or `500` for invalid input, is
lying to every client that reads it correctly.

| Situation | Expected |
|---|---|
| created a resource | 201, with a location or the resource |
| accepted for later processing | 202, with a way to observe the outcome |
| success with nothing to return | 204, with no body |
| invalid input | 400 or 422, consistently, never both for the same class |
| no credentials, or bad credentials | 401 |
| authenticated, not permitted | 403 |
| absent, or present but not visible to this caller | 404 |
| method not allowed on an existing path | 405 |
| conflict with the current state | 409 |
| rate limited | 429, with the retry information the contract declares |
| unhandled fault | 500, with no internal detail in the body |

Consistency matters more than the choice. One convention, applied everywhere.

## 5. Error bodies

Every error from every endpoint has the same shape. Check:

```
the same top level structure across 400, 401, 403, 404, 409, 422, 429, 500
a stable machine readable code, not only a human sentence
field level errors that name the request field, not the database column
no stack trace, no SQL, no file path, no internal host name
no different wording between a missing account and a wrong password
```

The last line is an enumeration defect and is reported to `security-testing`.

## 6. Idempotency and concurrency

For every endpoint with a side effect:

```
send the same request twice, sequentially: one effect, or a declared conflict
send it twice, concurrently: one winner, one clean loser
replay it after the resource changed: rejected or absorbed, never a silent
  overwrite
if an idempotency key is supported, replay with the same key and confirm the
  original response is returned rather than a second effect
```

A payment, an invitation, an export and a webhook consumer all belong to this
section. `bug-hunting` covers the same ground from the interface; here it is
verified at the contract, where the fix lives.

## 7. Consuming an API

When the project calls someone else's API, the tests exercise the project's
client against a stub at the network boundary, never a mock of the client
itself. What is verified:

```
the request the client actually builds: URL, method, headers, body
the timeout, and what the project does when it fires
retry behaviour, and whether a retry can duplicate an effect
the provider's error responses, each one handled
a response shape one field short of what the client expects
```

Stubbing the client library instead of the network means the request is never
tested, which is the request that breaks in production.

## 8. Prohibitions

- Never assert only the status code. A `200` with an empty body passes that.
- Never assert the whole response body with a snapshot when three fields carry
  the contract; a snapshot fails on every unrelated change and gets updated
  without reading.
- Never test against production, unless the contract authorises it and the
  request is a read.
- Never leave created resources behind in a shared environment.
- Never accept an undocumented status code as correct because it appeared.
- Never put a real token in a test file, a fixture or a report.

## 9. Protocol

1. Build the endpoint inventory from the specification and the code.
2. Record every disagreement between them as a finding.
3. Order the endpoints by consequence: writes and authorization first.
4. Run the per endpoint checklist, recording every result.
5. Check the error shape across the whole surface, not endpoint by endpoint.
6. Exercise idempotency and concurrency on every endpoint with an effect.
7. Verify the outbound clients against network level stubs.
8. Turn the findings into permanent contract tests through `testing-quality`.
9. Report deviations from the contract separately from defects in behaviour.

## 10. Auto-critique

Score from 0 to 5: inventory completeness, coverage of the checklist,
authorization cases actually run, status code and error shape consistency
checked across the surface, idempotency exercised, assertions that inspect the
body, cleanliness of the environment afterwards.

Threshold: no axis below 3, average at least 4. An endpoint tested only with
valid credentials and a valid body is untested, whatever its coverage number
says.

## 11. Interfaces

- Upstream: `quality-engineering` for the contract, `project-exploration` for
  the endpoint inventory, `backend-engineering` for what the handler intends.
- Lateral: `input-validation` for the server side matrix, `security-testing`
  for the full role and tenancy matrix, `bug-hunting` for the same abuse from
  the interface.
- Downstream: `testing-quality` for permanent contract tests,
  `technical-documentation` when the specification is wrong,
  `test-reporting` for the findings.
