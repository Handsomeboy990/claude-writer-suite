# Example: one flag, and the four that should never have existed

An audit of a two year old product found 23 flags. Four of them illustrate
every failure in this discipline.

## `enable_new_billing`, a release flag that became furniture

```
created   2024-11, to ship a billing rewrite disabled
state     production 100 percent since 2025-02
code      41 conditionals across 12 files, both branches maintained
```

Two branches of billing code had been maintained for eighteen months. A defect
fixed in 2025 was fixed only in the enabled branch, so anyone reading the old
one saw code that had silently diverged.

Removal took two days, deleted 900 lines, and removed a class of confusion
that had cost more than the rewrite.

## `pro_features`, a flag that was authorization

```
controls  access to features included in the paid plan
type      recorded as release, actually an entitlement
problem   support staff toggled it per customer as a goodwill gesture. The
          billing system knew nothing about it, so three accounts had paid
          features and no subscription for over a year.
```

Fixed by moving the decision to the permission model, where it is derived from
the subscription, authorized, and audited. The flag was deleted. The three
accounts became a conversation with the customers rather than a discovery in a
reconciliation.

## `use_fast_search`, a flag evaluated twice

```
evaluated once in the page component and once in the API handler, with a
percentage rollout keyed on the request rather than on the user
```

A user could get the new search interface and the old search backend in the
same request, producing empty results for a query that had matches. It
appeared as an intermittent search defect for six weeks.

Fixed by evaluating once in the handler and passing the result down, and by
keying the assignment on the user identifier so it is sticky.

## `disable_pdf_export`, the one that was right

```
type      kill switch
created   2025-03, after an incident where the PDF library exhausted memory
default   enabled, which is the safe state for a kill switch protecting
          availability
owner     platform
exercised twice: once in a real incident, once in a rehearsal
lifespan  permanent, and reviewed annually
```

This flag has no removal date and should not have one. Its type is different,
its default is different, and it is exercised on purpose so that it works when
someone reaches for it at three in the morning.

## What the audit changed

```
23 flags   ->  7
removed        11 release flags past their purpose, 2 dead provider entries,
               1 entitlement moved to the permission model, 2 experiments
               whose decision had been taken a year earlier
kept           3 kill switches, 2 operational flags, 2 live release flags
               with dates
added          a monthly detection job, a register, and a rule: no flag ships
               without an owner and a removal date, kill switches excepted
```

The register is 40 lines. It replaced the sentence that used to begin every
incident call: does anyone know what this flag actually does.
