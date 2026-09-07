# Example: one endpoint, tested past its 200

Endpoint under test: `POST /api/v1/exports`, documented as `admin only,
creates a CSV export job, returns 202 with a job id`.

## Inventory, from the code and the specification

```
method      POST /api/v1/exports
auth        session cookie
authz       specification says admin. Handler checks session only.  DEVIATION
body        { "range": "last-30-days" | "all", "format": "csv" }
success     202 { "jobId": string }
errors      documented: 400, 401. Handler can also return 409 and 500.
effects     creates a job row, enqueues work, sends a mail on completion
idempotency none declared, none implemented
rate limit  none
```

Two findings before any request was sent: the authorization gap and two
undocumented statuses.

## The test that most suites stop at

```ts
it("creates an export", async () => {
  const res = await client.post("/api/v1/exports", { range: "all", format: "csv" })
  expect(res.status).toBe(202)
})
```

It passes. It would also pass if the endpoint let any visitor export the whole
database, returned an empty body, or created four jobs per call.

## What was actually run

```ts
describe("POST /api/v1/exports", () => {
  it("returns 202 and a usable job id for an admin", async () => {
    const res = await asAdmin.post("/api/v1/exports", { range: "all", format: "csv" })
    expect(res.status).toBe(202)
    expect(res.body).toEqual({ jobId: expect.stringMatching(/^exp_[a-z0-9]{16}$/) })
    const job = await asAdmin.get(`/api/v1/exports/${res.body.jobId}`)
    expect(job.status).toBe(200)                    // the id is real, not decorative
  })

  it("rejects an anonymous caller", async () => {
    const res = await anonymous.post("/api/v1/exports", validBody)
    expect(res.status).toBe(401)
    expect(res.body).toEqual({ error: { code: "unauthenticated" } })
    expect(await countJobs()).toBe(0)               // no side effect on rejection
  })

  it("rejects a member", async () => {
    const res = await asMember.post("/api/v1/exports", validBody)
    expect(res.status).toBe(403)                    // FAILS: returns 202
  })

  it("ignores an owner field supplied by the caller", async () => {
    const res = await asAdmin.post("/api/v1/exports", {
      ...validBody, organisationId: otherOrg.id,
    })
    expect(res.status).toBe(202)
    const job = await db.job(res.body.jobId)
    expect(job.organisationId).toBe(adminOrg.id)    // FAILS: took the client value
  })

  it("rejects an unknown range", async () => {
    const res = await asAdmin.post("/api/v1/exports", { range: "since-forever", format: "csv" })
    expect(res.status).toBe(400)
    expect(res.body.error.code).toBe("invalid_range")
    expect(res.body.error.field).toBe("range")      // names the request field
  })

  it("rejects a body that is not JSON", async () => {
    const res = await asAdmin.postRaw("/api/v1/exports", "range=all")
    expect(res.status).toBe(400)                    // FAILS: 500 with a parser trace
  })

  it("creates one job for two identical concurrent requests", async () => {
    const [a, b] = await Promise.all([
      asAdmin.post("/api/v1/exports", validBody),
      asAdmin.post("/api/v1/exports", validBody),
    ])
    const created = [a, b].filter((r) => r.status === 202)
    expect(created).toHaveLength(1)                 // FAILS: two jobs, two mails
    expect([a, b].find((r) => r.status === 409)).toBeDefined()
  })

  it("returns no internal detail on failure", async () => {
    const res = await asAdmin.post("/api/v1/exports", { range: "all", format: "pdf" })
    expect(res.status).toBe(400)
    expect(JSON.stringify(res.body)).not.toMatch(/at |\.ts:|select |from /i)
  })
})
```

## Results

```
9 cases run, 4 failed

FAIL  a member can create an export           authorization, Critical
FAIL  organisationId taken from the body      mass assignment, Critical
FAIL  malformed body returns 500              robustness, Medium
FAIL  concurrent duplicates create two jobs   idempotency, High

DEVIATION  409 and 500 undocumented           contract, Medium
DEVIATION  documented admin only, not enforced  resolved as a code defect
```

The two critical findings are one line apart in the handler: the role check
that was never written, and the body spread into the job record. Neither is
visible from the interface, where the export button only exists for
administrators. That is the reason this layer is tested separately.

## What was handed on

```
security-testing        the role matrix across every write endpoint, since the
                        same handler shape is used in four places
backend-engineering     the fix, plus a policy on unknown body fields
testing-quality         the four failing cases, kept as permanent tests
technical-documentation the two undocumented statuses
```
