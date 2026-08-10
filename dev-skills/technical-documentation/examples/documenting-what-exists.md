# Example: documentation that lies, and its correction

A pull request adds an endpoint and this documentation.

## What was written

```markdown
### GET /api/invoices

Returns the user's invoices. Supports filtering by customer and date range,
and pagination. Rate limited to 100 requests per minute.

**Query parameters**

| Name | Type |
|---|---|
| customerId | string |
| from | date |
| to | date |
| page | number |
```

It reads well. Four of its five claims are false.

## What the code does

```ts
// app/api/invoices/route.ts
export async function GET(req: Request) {
  const session = await requireSession()
  const parsed = listInvoicesQuery.safeParse(
    Object.fromEntries(new URL(req.url).searchParams),
  )
  if (!parsed.success) return badRequest(parsed.error)
  return Response.json(await listInvoices(session.userId, parsed.data))
}

// lib/validation/invoices.ts
export const listInvoicesQuery = z.object({
  cursor: z.string().optional(),
  limit: z.coerce.number().int().min(1).max(50).default(20),
})
```

Findings against the documentation:

1. `customerId` does not exist. It was removed deliberately, because accepting
   it was the object level authorization defect that this endpoint was
   rewritten to fix. Documenting it invites a client to send it and a future
   engineer to reintroduce it.
2. `from` and `to` do not exist.
3. Pagination is cursor based, not page based. A client written against this
   documentation fails on its first call.
4. There is no rate limit on this route. The claim was copied from another
   endpoint.
5. The response shape and the errors are absent, which are the two things a
   caller actually needs.

## What ships

```markdown
### GET /api/invoices

Returns the authenticated user's invoices, newest first. Invoices are always
scoped to the session user; there is no parameter to request another user's
invoices.

**Query parameters**

| Name | Type | Required | Default | Notes |
|---|---|---|---|---|
| cursor | string | no | | opaque, from `nextCursor` of a previous response |
| limit | integer | no | 20 | 1 to 50 |

**Response 200**

```json
{
  "invoices": [
    {
      "id": "inv_01H8XK",
      "number": "2026-0042",
      "issuedAt": "2026-08-01T00:00:00.000Z",
      "totalMinor": 4900,
      "currency": "EUR",
      "pdfUrl": "https://files.example.com/inv_01H8XK.pdf"
    }
  ],
  "nextCursor": "eyJpZCI6..."
}
```

`nextCursor` is absent on the last page. Amounts are integer minor units;
divide by the currency exponent for display.

**Errors**

| Status | error | Cause |
|---|---|---|
| 400 | invalid_query | cursor malformed, or limit outside 1 to 50 |
| 401 | unauthenticated | no valid session |

**Example**

```bash
curl "https://api.example.com/api/invoices?limit=5" \
  -H "Cookie: sid=$SESSION"
```

**Not supported**

Filtering by customer or date range. Both were considered and are tracked as
follow up work.
```

## The `Not supported` section

Unusual, and worth the four lines. Without it, the next engineer reads the
parameter table, assumes filtering was overlooked, and adds `customerId` back,
reintroducing the exact defect the rewrite removed.

Stating what deliberately does not exist is often more valuable than
describing what does.

## Verification performed

```
Endpoint exists                app/api/invoices/route.ts, read
Parameters match the schema    lib/validation/invoices.ts, read
Response shape                 curl executed, output matches the example
                               with identifiers replaced by fictional ones
Errors                         both cases triggered, statuses confirmed
Rate limit claim               removed, no limiter exists on this route
Stale content                  the customerId paragraph deleted from
                               docs/api.md, not only from the new section
```

The last line is the one most often skipped. Adding correct documentation
while leaving the incorrect version elsewhere leaves two documents, and
readers find the wrong one first as often as not.
