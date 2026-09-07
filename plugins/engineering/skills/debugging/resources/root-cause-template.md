# Root cause report template

```markdown
## Defect

Observed:
Expected:
Trigger:
Frequency:   always | intermittent | under load | first request after deploy
Scope:       one user | one environment | everyone
Since:       version, deploy, data change, or unknown

## Reproduction

Method:      failing test | local run | replayed request | trace only
Command:
Result:      quoted output

## Evidence

Stack top frame:
First project frame:
Input values at that point:
History of the file:      git log output, one line per relevant commit

## Bisection

Cut 1:   point in the path, value observed, half eliminated
Cut 2:
Cut 3:

## Root cause

Mechanism:   one sentence
File:        path:line-line
Code:

Why now:
Impact:      who, how badly, since when
Related:     the same pattern elsewhere, listed with paths

## Fix

Change:      one line description
Rationale:   why this and not the alternative
Convention:  the existing occurrence it follows

## Verification

Before:      test name, failing, output quoted
After:       test name, passing, output quoted
Regression:  suite result, output quoted
Trigger:     original reproduction no longer occurs

## Follow up

Instances not fixed here, with paths and the reason.
Temporary instrumentation removed: yes | kept at level X because ...
```

## Rules

- Every line is filled or explicitly marked unknown with the missing input.
- The mechanism sentence must explain the frequency and scope lines. If it
  does not, the cause is wrong or incomplete.
- `Related` is never left empty without having searched. A defect pattern
  usually has siblings.
- Verification quotes real output. A description of what would happen is not
  verification.
