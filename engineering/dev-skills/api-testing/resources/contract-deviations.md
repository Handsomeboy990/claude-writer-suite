# Contract deviations

A deviation is a difference between what the API promises and what it does.
It is reported separately from behavioural defects, because the fix is a
decision: change the code, or change the contract.

## Kinds

| Kind | Example | Usual fix |
|---|---|---|
| undocumented status | the handler can return 409, the specification lists 400 and 404 | document it |
| undocumented field | the response carries `internalRef` | remove it from the response |
| missing field | a field the specification declares is absent when null | return it as null |
| type drift | an identifier documented as a string, returned as a number | fix the code, it breaks clients |
| status misuse | 200 with `{"error": ...}` | fix the code |
| inconsistent errors | 400 on one endpoint, 422 on its sibling, same class of fault | one convention |
| authorization drift | documented as admin only, accessible to any member | fix the code, then check the audit trail |
| pagination drift | documented cursor, implemented offset | decide, then fix one side |
| optionality drift | a field documented optional, rejected when absent | fix whichever is wrong |

## Reporting format

```
DEV-03  authorization drift            Severity: Critical
Endpoint    GET /api/v1/exports/{id}
Documented  admin only
Actual      any authenticated member of any organisation
Evidence    request as member of org B against an export owned by org A,
            200 with the file. Two accounts owned by the campaign.
Decision    code, not documentation. Object level check missing.
Handed to   security-testing for the boundary sweep, backend-engineering for
            the fix, testing-quality for the permanent test
```

## Severity for deviations

```
Critical   the deviation is an authorization or data exposure difference
High       a client written to the contract will break, or already does
Medium     the contract is wrong but no client depends on the difference yet
Low        wording, examples, or an undocumented but harmless field
Info       an internal inconsistency worth one convention decision
```

## The rule that decides which side changes

```
1  If the difference exposes data or bypasses a permission, the code is wrong.
2  If a published client depends on the current behaviour, the contract is
   wrong and the behaviour is kept, with a version note.
3  If nothing depends on it yet, the code follows the contract.
4  If the contract has never been published, fix whichever is more honest and
   write it down.
```

Never resolve a deviation by silently updating the specification to match a
behaviour nobody chose.
