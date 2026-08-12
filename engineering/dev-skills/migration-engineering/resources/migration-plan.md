# Migration plan template

```
MIGRATION
  From             <current>
  To               <target>
  Reason           <one sentence, and what breaks in twelve months without it>
  Owner            <who>
  Window           <dates, and any freeze required>

INVENTORY
  call sites       <counted>
  integrations     <clients, exports, reports that observe the current shape>
  data             <tables, rows, size, known invalid rows>
  test coverage    <what protects the surface, what does not>
  deploy, rollback <the mechanism as it exists today>

COMPATIBILITY
  identical        <...>
  renamed          <...>
  silent change    <the dangerous list: defaults, ordering, rounding,
                    timezones, error semantics, null handling>
  removed          <what replaces it>

STRATEGY
  chosen           <in place | parallel change | strangler | dual write |
                    shadow | flagged rewrite>
  rejected         <the others, with the reason>

STEPS
  1 <shipped, reversible, with its observation>
  2 ...
  n cleanup

DATA
  batch size       <n rows>, checkpoint <where>
  verification     counts, checksums, <n> sampled rows compared field by field
  invalid rows     <reject | repair | quarantine>, decided in advance
  reverse path     <script, or the written reason there is none>
  retention        old data kept until <date>, deleted by <owner>

CUT OVER
  sequence         <step, person, command, check>
  signals          <what proves it worked, measured, not assumed>
  point of no      <the step after which rollback is replaced by forward fix>
    return

ROLLBACK
  procedure        <exact steps>
  rehearsed        <date, environment, result>
  cannot restore   <data written by the new path, mails sent, webhooks
                    delivered, external state changed>

CLEANUP
  <item>           <owner>   <date>
  old code         ...
  compatibility    ...
  feature flag     ...
  dual write       ...
  old columns      ...
  dependency       ...
  documentation    ...

RISKS
  <risk>           <likelihood, impact, mitigation, who is warned>
```

## Signals that a migration is going wrong

```
the steps stopped shipping and became one long branch
the transitional state acquired features of its own
the comparison differences are being ignored rather than diagnosed
the cleanup date has moved twice
both implementations are receiving bug fixes
nobody can say what percentage of traffic is on the new path
```

Each of those is a reason to stop, reassess and either finish or revert. A
migration that stalls consumes attention forever and delivers nothing.

## Verification queries for a data migration

```
counts        source and target row counts match, per partition
checksums     an aggregate over a stable set of columns matches
nulls         columns that must never be null are not
ranges        min and max of dates, amounts and identifiers match
sample        n randomly selected rows compared field by field, by a script
orphans       no target row references a missing parent
duplicates    the new uniqueness constraints hold on the migrated data
encoding      a row containing non ASCII characters survives intact
edge rows     the oldest, the newest, the largest, and the known odd ones
```

Run the same verification twice: once on a copy before the real run, and once
after it. The first tells you whether the script works; the second tells you
whether it worked.
