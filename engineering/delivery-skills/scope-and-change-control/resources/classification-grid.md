# Classification grid

Every discovery is classified in writing before anything is done about it.

## The four classes

```
in scope    serves an approved requirement            do it
follow up   an improvement nobody asked for           register it
urgent      security, data integrity, correctness     fix now, report
change      contradicts the approved design           change protocol
```

## Worked classifications

| Discovery | Class | Reason |
|---|---|---|
| the endpoint I am writing needs an index to work at all | in scope | the requirement cannot be met without it |
| a neighbouring endpoint has no index, no measured impact | follow up | not this requirement, no defect |
| the orders query returns other users' rows | urgent | object level authorization, reachable |
| a helper is duplicated in four files | follow up | cosmetic, no defect |
| the approved schema cannot express the payout rule | change | contradicts the architecture |
| a form field is rendered and never sent | in scope | the approved feature is incomplete |
| the settings page, out of scope, has no empty state | follow up | outside the approved scope |
| the mail provider does not support the required schedule | change | the architecture assumed it did |
| a test I wrote fails because my code is wrong | in scope | this is the work, not a discovery |
| an existing test fails for an unrelated reason | follow up, unless it blocks | investigate, register, do not fix silently |
| a dependency has a published advisory reachable from our code | urgent | security |
| a dependency has an advisory in an unreachable path | follow up | no reachable risk, register with the reason |
| the client asks for an extra field during implementation | client scope | section 7 of the skill |
| the design system button lacks a focus state | urgent if it ships, else follow up | accessibility defect on a reachable path |
| I could restructure this module more cleanly | follow up | no defect, not requested |
| the approved stack's ORM cannot express a required constraint | change | technology decision affected |

## The three refused temptations

```
"while I am in this file anyway"
"it is only ten minutes"
"it would be strange to leave it like that"
```

Each is a reasonable sentence. The register exists so that the improvement is
not lost, which is the real fear behind all three.

Counting matters: ten such improvements at twenty minutes each is a day, and
none of them appears in any plan, so the day appears only as lateness.

## The urgent boundary

Urgent means a reachable risk to security, data integrity or correctness.

```
Urgent
  any user can read another user's data
  a secret is exposed in code, logs or the client bundle
  a write path can corrupt or lose data
  authentication or authorization can be bypassed
  money is computed from a client supplied value
  an approved requirement produces a wrong result

Not urgent, however uncomfortable
  the error handling is poor but correct
  the code is hard to read
  a query is slower than it could be, with no measured impact
  a dependency is old but has no reachable advisory
  the naming is inconsistent
  a feature outside this delivery has a defect
```

The second list goes to the register. Some of it goes to the register marked
`recommended`, which is how a real concern reaches the client without
consuming this delivery's budget.

## Register entry format

```
| # | What | Where | Class | Why not now | Effort | Recommended |
|---|---|---|---|---|---|---|
| FU12 | orders.customer_id unindexed | db/schema.ts | follow up | 340 rows, 12ms measured | small | yes, before 50k rows |
| FU13 | settings page has no empty state | app/settings | follow up | outside approved scope | medium | no |
| FU14 | date formatting duplicated | lib/ | follow up | cosmetic | small | no |
```

The `Recommended` column is what makes the register useful at handover. A list
of forty undifferentiated observations gets ignored; a list of forty with four
marked recommended gets four of them done.

## Writing the classification down

One line in the working notes, before acting:

```
FU12 registered: orders.customer_id has no index. Measured 12ms at 340 rows.
Not in scope for T21. Recommended before 50k rows.
```

Twelve seconds. What it prevents is the retrospective classification, where a
two hour detour is explained afterwards as having been necessary.
