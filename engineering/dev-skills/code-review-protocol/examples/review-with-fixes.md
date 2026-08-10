# Example: a review that finds, fixes and proves

Diff under review: a new endpoint listing a user's invoices.

```ts
// app/api/invoices/route.ts
export async function GET(req: Request) {
  const url = new URL(req.url)
  const customerId = url.searchParams.get("customerId")
  const invoices = await db.invoice.findMany({
    where: { customerId },
    include: { lines: true, customer: true },
  })
  return Response.json(invoices)
}
```

Twelve lines. A reviewer in a hurry approves it.

## Pass 1, correctness

`customerId` is `string | null`. Passed as `null`, Prisma returns every
invoice whose `customerId` is null rather than throwing, so a missing
parameter silently returns a different result set instead of a 400.

```
major  app/api/invoices/route.ts:3
Input: GET /api/invoices with no customerId
Result: returns rows instead of rejecting the request
```

## Pass 2, security

Two findings, both blockers.

```
blocker  app/api/invoices/route.ts:2
No session check. The route is reachable unauthenticated.
Evidence: middleware.ts matcher covers /dashboard and /settings only.

blocker  app/api/invoices/route.ts:5
Object level authorization missing. customerId comes from the query string and
is not compared to the session user. Any caller reads any customer's invoices
by incrementing an id.
Input: GET /api/invoices?customerId=other-customer-id
```

A third finding, on the response shape:

```
major  app/api/invoices/route.ts:8
include: { customer: true } serialises the full customer row, which contains
email, billing address and stripeCustomerId. The list view needs the name.
```

## Pass 3, performance

```
major  app/api/invoices/route.ts:4
No limit and no pagination. The largest customer in the seed data has 4,200
invoices; with lines included, the response is measured at 11 MB.
Evidence: node scripts/count-invoices.ts, max 4,200 rows.
```

## Pass 4, architecture

```
minor  app/api/invoices/route.ts:4
The query lives in the route handler. Two existing occurrences,
app/api/orders/route.ts and app/api/subscriptions/route.ts, both delegate to
lib/services/. Placement contradicts the convention.
```

## Pass 5, robustness

```
major  app/api/invoices/route.ts:4
No error handling. A database failure produces an unformatted 500 and the
client renders a blank list, since components/invoice-list.tsx treats any
non array response as empty.
```

## Fixed version

```ts
// app/api/invoices/route.ts
import { getSession } from "@/lib/auth"
import { listInvoices } from "@/lib/services/invoices"
import { listInvoicesQuery } from "@/lib/validation/invoices"

export async function GET(req: Request) {
  const session = await getSession()
  if (!session) return Response.json({ error: "Unauthorized" }, { status: 401 })

  const parsed = listInvoicesQuery.safeParse(
    Object.fromEntries(new URL(req.url).searchParams),
  )
  if (!parsed.success) {
    return Response.json({ error: "Invalid query" }, { status: 400 })
  }

  try {
    const page = await listInvoices(session.userId, parsed.data)
    return Response.json(page)
  } catch (error) {
    logger.error("invoices.list.failed", { userId: session.userId, error })
    return Response.json({ error: "Internal error" }, { status: 500 })
  }
}
```

`listInvoices` scopes by the session user, selects the four fields the list
needs, and applies a cursor with a maximum page size of fifty. The customer
identifier is no longer read from the query at all, which removes the class of
bug rather than patching one instance of it.

## Verification, quoted

```
npm test -- invoices
  invoices list
    rejects unauthenticated requests            ok
    rejects an invalid cursor                   ok
    returns only the session user invoices      ok
    ignores a customerId in the query string    ok
    caps the page size at 50                    ok
    returns 500 with no leak on a db error      ok
  6 passing

npm run typecheck   ok
npm run lint        ok
```

## Report

```
blocker 2, major 4, minor 1. All fixed.
Follow up: invoices.customerId has no index. Measured 180ms on the seed data,
acceptable now, recorded in continuity notes with the trigger at 50k rows.
```

Twelve lines of code, seven findings, two of them capable of leaking every
customer's billing data. This is why the review runs on small diffs too.
