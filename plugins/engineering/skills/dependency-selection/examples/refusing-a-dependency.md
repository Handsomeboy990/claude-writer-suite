# Example: two requests, two different answers

## Request one: "add lodash so we can use debounce"

### Question 1, does the project already solve this?

```
rg "debounce" --type ts
  lib/hooks/use-debounced-value.ts:4   export function useDebouncedValue
  components/search-input.tsx:12       useDebouncedValue(query, 300)
```

It does. A hook exists and is used. The request came from someone who did not
find it, which is a discoverability problem, not a dependency problem.

**Decision: refused.** The existing hook is used. A note is added to the
components README pointing at it, so the next person finds it.

Cost avoided: 1 package, roughly 70 kB if imported wholesale, and a second
idiom for the same operation in the codebase.

## Request two: "we need to generate PDF invoices"

### Question 1, existing?

Nothing in the tree generates PDFs. Verified against the lockfile, not only
the manifest.

### Question 2, platform?

No runtime PDF capability. The alternative is HTML to print, which the product
rejected because invoices are attached to emails.

### Question 3, small enough to own?

No. The PDF format is not a weekend project, and a wrong implementation
produces files that open in one reader and fail in another.

The three questions are answered, so the evaluation proceeds.

### Grid

```
|  | Library A | Library B | Service C |
|---|---|---|---|
| 1 solves the need | yes | yes, plus a full layout engine | yes, HTML to PDF as a service |
| 2 compatibility | works on the server runtime | needs a headless browser | HTTP only |
| 3 maintenance | active, monthly releases | active | commercial, SLA |
| 4 security | no advisories | pulls a browser, large surface | data leaves our infrastructure |
| 5 licence | MIT | Apache 2.0 | commercial |
| 6 size | 340 kB server side, not in the client bundle | 300 MB browser download | 0 |
| 7 transitive | 2 packages | 40 packages plus a browser binary | 1 HTTP client |
| 8 types | ships types | ships types | we write them |
| 9 accessibility | n/a | n/a | n/a |
| 10 documentation | good, invoice example present | good | good |
| 11 escape cost | low, one module | medium, layout written as HTML is portable | low, but invoice data crosses a boundary |
| 12 alternatives | this grid | this grid | this grid |
```

### The deciding criterion

Not size, and not maintenance. Criterion 4, security, decided it: Service C
would send customer names, addresses and amounts to a third party, which
changes the data processing posture of the product and requires a contract the
team does not have.

Between A and B, criterion 7 decided: a 300 MB browser binary in the
deployment image, for one feature, against two packages.

**Decision: Library A.**

```
Cost           2 packages, 340 kB server side, 0 in the client bundle
Licence        MIT, compatible
Escape         used behind lib/invoices/pdf.ts, one module, one interface
Follow up      if invoice layouts become complex enough to need real HTML
               layout, reconsider B, and the trigger is written down
```

### Verification after installing

```
pnpm add pdf-lib
pnpm audit          0 vulnerabilities
lockfile diff       +2 packages
build               server bundle 4.1 MB to 4.44 MB, client unchanged
pnpm test           228 passing
```

The client bundle line matters and is checked explicitly: a server only
dependency that accidentally reaches the client bundle is a common and
expensive mistake, and the build output is the only place it shows.

### Committed alone

```
chore: add pdf-lib for invoice generation
```

One commit, one dependency, no feature code. If invoice generation regresses
next month, this commit can be bisected and reverted without unpicking a
feature.
