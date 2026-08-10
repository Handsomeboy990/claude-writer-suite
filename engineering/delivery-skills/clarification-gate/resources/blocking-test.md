# Blocking test

Apply the five criteria to every unknown. One hit makes it blocking.

```
1 Architecture depends on it
2 Expensive to reverse
3 Legal, financial or safety consequence
4 Readings are genuinely incompatible
5 No defensible default exists
```

## Worked classifications

| Unknown | Hits | Verdict |
|---|---|---|
| Who is the merchant of record | 1, 2, 3 | blocking |
| Is this one organisation or several tenants | 1, 2 | blocking |
| What does following a course mean | 1, 2, 4 | blocking |
| Can a buyer dispute after payout | 2, 3 | blocking |
| Which country's onboarding rules apply | 3, 5 | blocking |
| Is a course published directly or after review | 1 | blocking |
| Are deleted accounts purged or anonymised | 2, 3 | blocking |
| Who owns uploaded files after account closure | 2, 3 | blocking |
| Default page size for lists | none | assumption, 20 |
| Sort order of the order list | none | assumption, newest first |
| Maximum length of a review | none | assumption, 2000 characters |
| Date display format | none | assumption, locale formatter |
| Whether the sidebar collapses on tablet | none | assumption, follows the design system |
| Which test runner inside the chosen ecosystem | none | assumption, the one already configured |
| Log retention in development | none | assumption, whatever the platform defaults to |
| Expected number of users | 1 only when it changes the architecture | usually assumption with a stated figure |

## The volume question

`How many users` is blocking only when the plausible answers span an
architectural boundary.

```
Not blocking:  an internal tool, plausibly 20 to 500 users
               same architecture across the whole range
               assumption: 500, stated

Blocking:      a public consumer product, plausibly 1,000 to 5,000,000
               the two ends need different data and caching strategies
               question: what is the expected scale at launch and at one year
```

The test is not the size of the unknown, it is whether the answers lead to
different designs.

## The reversibility ladder

When classifying under criterion 2, place the unknown on this ladder.

```
Free to reverse         a constant, a copy string, a page size
Cheap                   an internal module, one file, no stored data
Moderate                a contract between two modules, a schema addition
Expensive               a schema change touching stored rows
Very expensive          a data model change, a provider change, a tenancy model
Irreversible            data that was deleted, money that moved, mail that was
                        sent, a public API other people now depend on
```

Anything at `Expensive` or below the line is blocking under criterion 2.
Anything at `Free` or `Cheap` is an assumption, whatever it feels like.

## The default test

Criterion 5 asks whether a defensible default exists. A default is defensible
when it satisfies three conditions:

1. It is what a competent engineer in this domain would choose.
2. It is cheap to change if the client disagrees.
3. Choosing it does not quietly foreclose a stated requirement.

```
Defensible: pagination default 20, because every list UI in the product uses
20, changing it is one constant, and no requirement mentions page size.

Not defensible: choosing soft delete over hard delete, because the client's
domain may impose deletion, changing it later touches every query, and the
requirement register contains "users can delete their data" whose meaning is
exactly what is in question.
```

The second case looks like a technical default and is actually criterion 3
wearing a technical costume. That is the classification error this table
exists to catch.

## Output

Every unknown leaves the test with one of two records.

```
Blocking:
  Q<n>  <the question, per the question quality rules>
        Area:       <grouping for the batch>
        Criteria:   <which of the five it hit>
        Blocks:     <what cannot proceed>

Non blocking:
  A<n>  <the assumption>
        Why needed: <what could not proceed without it>
        Default:    <the adopted value>
        If wrong:   <the change, and its position on the ladder>
```
