# Flag register

One file, in the repository, next to the code. A flag absent from it is a
conditional nobody owns.

## Entry

```
flag         new_checkout_flow
type         release
controls     the checkout page and the order creation path
owner        payments
created      2026-07-14
remove by    2026-09-01
default      off, which is the previous behaviour
evaluated    one point, in the checkout route handler
state        development on, staging on, production 25 percent
rollout      internal, then 5, 25, 50, 100 percent
metric       checkout completion rate, abort below 96 percent of baseline
tests        both sides run in CI, default path is off
```

## States that need an action

```
a release flag past its removal date              remove it, or re-decide
a flag at 100 percent for more than a month       remove it
a flag at 0 percent for more than a month         remove it and its branch
a flag with no owner                              remove it
a flag evaluated nowhere in the code              delete the provider entry
a flag whose meaning nobody can state             read the code, then remove
different values across environments with no
  written reason                                  investigate before removing
```

## Detection, automated

```
list flags in the provider
list flags evaluated in the code
report the difference in both directions:
  in the provider, not in the code   dead entry, delete
  in the code, not in the provider   evaluation falling back to the default
report release flags past their date
report flags at a constant value for more than 30 days
```

Run it monthly and put the output where the team reads it. Flag debt is the
kind that accumulates silently because each individual flag is harmless.

## Rollout record

```
2026-07-18  internal only, 12 users. Completion 100 percent, 3 defects found.
2026-07-22  5 percent. Completion 97.1 percent of baseline. Within threshold.
2026-07-25  25 percent. Completion 98.4 percent. Latency unchanged.
2026-08-02  paused at 25 percent: an unrelated provider incident made the
            comparison meaningless for two days.
2026-08-05  resumed, 50 percent. Completion 99.2 percent.
2026-08-09  100 percent.
2026-08-12  flag removed, losing branch deleted, tests updated, provider entry
            deleted, register entry closed.
```

The paused line matters: rolling out during an unrelated incident produces a
number that will be quoted for a year and means nothing.

## Removal checklist

```
[ ] decision confirmed: the feature stays or it goes
[ ] conditional removed, losing branch deleted
[ ] tests of the removed branch deleted, tests of the survivor kept
[ ] provider entry deleted, so nobody can flip a flag the code ignores
[ ] register entry closed
[ ] behaviour verified in every environment after removal
[ ] the commit is separate from any behaviour change
```
