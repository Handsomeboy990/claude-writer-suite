# Example: the same list, before and after

Feature: an invoices table on the billing page.

## What gets written first

```tsx
export function InvoiceList() {
  const { data } = useInvoices()
  return (
    <table>
      <tbody>
        {data.map((invoice) => (
          <tr key={invoice.id}>
            <td>{invoice.number}</td>
            <td>{invoice.total}</td>
          </tr>
        ))}
      </tbody>
    </table>
  )
}
```

Eleven lines, and five defects.

1. `data` is undefined on the first render; the component crashes before the
   request resolves.
2. No empty state. A new customer sees an empty bordered box.
3. No error state. A failed request renders the same empty box, so the user
   cannot tell the difference between having no invoices and the service being
   down.
4. No column headers, so the table is unusable with a screen reader.
5. `invoice.total` renders a raw number, which will be `4900` for a currency
   the user expects as a formatted amount.

## What ships

```tsx
export function InvoiceList() {
  const { data, error, isPending, refetch } = useInvoices()

  if (isPending) return <InvoiceListSkeleton rows={5} />

  if (error) {
    return (
      <ErrorState
        title="Invoices could not be loaded"
        description="The billing service did not respond."
        action={<Button onClick={() => refetch()}>Try again</Button>}
      />
    )
  }

  if (data.invoices.length === 0) {
    return (
      <EmptyState
        title="No invoices yet"
        description="Invoices appear here after your first payment."
      />
    )
  }

  return (
    <table className="w-full">
      <caption className="sr-only">Your invoices</caption>
      <thead>
        <tr>
          <th scope="col">Number</th>
          <th scope="col">Date</th>
          <th scope="col" className="text-right">Amount</th>
          <th scope="col"><span className="sr-only">Actions</span></th>
        </tr>
      </thead>
      <tbody>
        {data.invoices.map((invoice) => (
          <tr key={invoice.id}>
            <td>{invoice.number}</td>
            <td>
              <time dateTime={invoice.issuedAt}>
                {formatDate(invoice.issuedAt)}
              </time>
            </td>
            <td className="text-right tabular-nums">
              {formatMoney(invoice.totalMinor, invoice.currency)}
            </td>
            <td>
              <a href={invoice.pdfUrl}>
                Download<span className="sr-only"> invoice {invoice.number}</span>
              </a>
            </td>
          </tr>
        ))}
      </tbody>
    </table>
  )
}
```

## The decisions behind it

**Skeleton with a fixed row count.** Five rows of the same height as real rows,
so the page does not jump when the data arrives. A spinner would have been
less work and would have shifted the layout.

**Error state distinct from empty state.** Different words, different action.
This is the single most common conflation in list components, and it turns an
outage into a support ticket that says the data disappeared.

**`tabular-nums` on the amount column.** Amounts align on the decimal, so the
column can be scanned. A detail that costs one class and is invisible until it
is missing.

**Accessible link text.** Four rows of `Download` are four identical links to
a screen reader user listing links on the page. The visually hidden suffix
makes each one distinct without changing the visual design.

**Money formatted from minor units and a currency.** The component never sees
a float. `formatMoney(4900, "EUR")` is unambiguous where `invoice.total` was
not.

## Partial state, the fifth one

This list has a companion summary that loads from a different endpoint. The
page renders them independently rather than waiting for both:

```tsx
<Suspense fallback={<SummarySkeleton />}>
  <BillingSummary />
</Suspense>
<Suspense fallback={<InvoiceListSkeleton rows={5} />}>
  <InvoiceList />
</Suspense>
```

The user reads the summary while the invoices are still arriving. Waiting for
the slowest of two requests before showing anything is a choice, and usually
the wrong one.

## State placement

The page has a year filter. It lives in the URL:

```
/billing?year=2025
```

Reload preserves it, a link to a filtered view works, and the back button
behaves. Kept in `useState`, it would have been lost on every reload, and the
resulting report would have been filed as a caching bug.

## Verification

```
vitest run invoice-list
  renders the skeleton while pending          ok
  renders the error state and retries         ok
  renders the empty state for zero invoices   ok
  renders rows with formatted amounts         ok
  each download link has a distinct name      ok
  5 passing

Keyboard: tab reaches every download link, focus visible, order matches
the visual order.
Narrow width 320px: the table scrolls inside its container, the page does not.
```
