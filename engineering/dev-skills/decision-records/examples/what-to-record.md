# Example: five candidates, two records

A quarter of engineering decisions, sorted by whether they earn a record.

## 1. Choosing a date library

Two candidates, similar, one already used elsewhere in the company.

```
Would anyone ask why?    no
Expensive to reverse?    no, it is used in four files
Verdict                  no record. A line in the dependency justification is
                         enough, which dependency-selection already produces.
```

## 2. Sessions in the database rather than in the cache

```
Would anyone ask why?    yes, immediately. The obvious choice is the cache.
Expensive to reverse?    moderate, it touches authentication
Rejected option?         yes, and for a specific reason: at the time there was
                         no cache in the infrastructure and adding one for
                         sessions alone was not justified
Verdict                  record. ADR-0012.
```

Two years later that record was superseded, and the superseding record could
say precisely what had changed: three nodes and twenty times the login volume.
Without ADR-0012, the new team would have assumed the original choice was
ignorance.

## 3. Naming API fields in camelCase

```
Would anyone ask why?    no
Argued about twice?      once, briefly
Verdict                  no record. It belongs in the API conventions
                         document, which is a standard, not a decision.
```

A convention is a rule to follow. A decision is a trade that was made. Putting
conventions into decision records buries the records that matter.

## 4. No shared database between services

```
Would anyone ask why?    yes, the first time someone wants a join
Expensive to reverse?    very
Constraint?              yes, it forbids something engineers will want to do
Verdict                  record, and the most valuable kind: a record whose
                         main job is to explain a prohibition.
```

This record is quoted in code review roughly once a month, which is exactly
the return on twenty minutes of writing.

## 5. Upgrading the framework to the next major version

```
Would anyone ask why?    no, support ends in March
Rejected option?         staying, which was not viable
Verdict                  no record for the decision to upgrade.

But: the upgrade forced a choice between two routing approaches, one of which
constrains how the application will be structured for years.
That is the record. Not the upgrade, the constraint it introduced.
```

## The rule this illustrates

Record the choice, not the task. A migration is work; the architecture it
commits you to is a decision. An upgrade is maintenance; the pattern it forces
is a decision.

Two records from a quarter is a healthy rate. Twenty means conventions are
being recorded as decisions, and nobody will read the two that matter.
