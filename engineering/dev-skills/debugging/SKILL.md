---
name: debugging
description: Finds the root cause of a defect instead of guessing: reproduction, evidence collection, bisection of the failing path, targeted instrumentation, exact file and line, verified fix and regression test. Use on any reported bug, crash, wrong result or failing test.
license: MIT
metadata:
  category: dev-skills
  version: 1.0.0
  depends_on: [engineering-core, project-exploration]
  outputs: [root-cause-report, reproduction, verified-fix, regression-test]
---

# Debugging

Produces a root cause with a file, a line range and a mechanism. A hypothesis
without those three is not a diagnosis.

The output of this skill is never a list of things that might be wrong. It is
one cause, demonstrated.

## 1. Protocol

### Step 1, define the defect precisely

```
Observed     what happens, exactly, including the message and the stack
Expected     what should happen, and where that expectation comes from
Trigger      the smallest input or action that produces it
Frequency    always, intermittent, under load, first request after deploy
Scope        one user, one environment, everyone
Since when   a version, a deploy, a data change, or unknown
```

An unfilled line is a question to answer, not a blank to leave. Frequency and
scope alone eliminate most candidate causes.

### Step 2, reproduce

Reproduction in order of preference:

1. a failing test written from the report;
2. a local run of the exact trigger;
3. a request replayed against a development environment;
4. a trace or log from the environment where it occurred.

A defect that cannot be reproduced is investigated by narrowing, not by
guessing. State plainly that reproduction failed and what evidence replaces
it.

Nothing is fixed on the basis of a defect that was never observed.

### Step 3, collect evidence before forming a theory

Read, in this order: the error and the full stack, the code at the top frame,
the code at the first frame owned by the project, the inputs at that point,
the version control history of that file.

`git log` and `git blame` on the failing lines answer the since when question
faster than any reasoning.

### Step 4, bisect the path

The defect lives somewhere between the input and the output. Cut that path in
half and determine which half holds it. Repeat.

Cut points, in a typical request: the boundary parse, the authorization check,
the service entry, the query built, the query result, the transform, the
serialisation, the client parse, the render.

Three or four cuts locate almost any defect. Reading the whole path from the
start locates it eventually, and costs ten times more.

### Step 5, instrument, minimally

When reading is not enough, add logs. Rules:

- use the project's logger, at the project's level convention;
- log the values that discriminate between the two remaining hypotheses,
  nothing else;
- never log secrets, tokens, full request bodies or personal data;
- remove them once the cause is found, unless the log has lasting operational
  value, in which case it stays at the right level and is mentioned in the
  report.

A temporary log left in the codebase is a defect introduced by the fix.

### Step 6, name the root cause

```
Cause        the mechanism, in one sentence
File         path and line range
Code         the three to ten lines that matter
Why now      what changed, or what condition made it reachable
Impact       who is affected and how badly
Related      the same pattern elsewhere, listed
```

Root cause means the mechanism, not the symptom and not the layer. Two tests
for whether the cause is real:

- it explains the frequency and the scope from step 1;
- reverting it makes the reproduction pass, and nothing else does.

### Step 7, fix

The fix addresses the mechanism. When the same mechanism exists in three other
places, all four are listed; the ones outside the task scope go to continuity
rather than being silently left.

Order: write the failing test first, then fix, then watch it pass. A fix
without a test that failed before is a fix with no evidence.

### Step 8, verify

```
Before fix   the test fails, output quoted
After fix    the test passes, output quoted
Regression   the surrounding suite still passes, output quoted
Original     the reported trigger no longer reproduces
```

## 2. Common causes, ranked by frequency

Consult when the bisection stalls. This is a prompt list, never a conclusion.

| Family | Typical mechanism |
|---|---|
| null and absence | a value that is optional in one path and assumed in another |
| type coercion | a string compared to a number, a truthy check on zero or empty string |
| async | a missing await, a promise not returned, work after a response was sent |
| ordering | two effects whose order was accidental and changed |
| state | stale closure, cached value, memoised on an incomplete key |
| identity | comparing objects by reference where value equality was meant |
| boundary | first or last element, empty collection, single element |
| time | timezone, daylight saving, month end, clock skew, expiry compared in the wrong unit |
| environment | a variable set locally and absent in the environment that fails |
| data | a row that violates an assumption nobody wrote down |
| concurrency | two requests interleaving on a check then act |
| dependency | behaviour changed by an upgrade, or a peer version mismatch |
| build | stale artefact, cache, or a source file not included in the bundle |
| configuration | a default that differs between environments |

## 3. Prohibitions

- No fix without a reproduction or an equivalent, stated, evidence path.
- No list of five possible causes presented as a diagnosis.
- No change of unrelated code while investigating.
- No repeated request to the user for information the repository, the logs or
  a targeted test can supply.
- No trial and error edits hoping the symptom disappears.
- No suppression of an error to make the symptom stop.
- No test weakened or deleted to make a suite green.
- No debug output left behind.

## 4. When the cause is in a dependency

State it with the evidence: the version, the code in the dependency that
fails, the issue or changelog entry if it exists. Then choose deliberately:
pin, upgrade, patch, or work around at the call site with a comment naming the
reason. Silent workarounds become permanent.

## 5. Report format

```
Defect      login hangs when the password is wrong
Reproduced  yes, test app/(auth)/actions.test.ts submits a wrong password
Cause       the wrong password branch throws instead of returning the error
            state, so useActionState never resolves the pending state
File        app/(auth)/actions.ts:31
Why now     introduced in 4f1c8a2 when the unknown user branch was changed to
            a return and the password branch was left as a throw
Impact      every failed login, all users, since 2026-07-14
Related     app/settings/actions.ts:52 has the same mixed pattern
Fix         both branches return { error }, matching the project convention
Verified    before: 1 failing, after: 5 passing, npm test -- auth
            the reported trigger no longer reproduces
Follow up   app/settings/actions.ts fixed in the same commit, listed above
```

## 6. Auto-critique

Score from 0 to 5: precision of the defect definition, reproduction achieved
or honestly replaced, evidence before theory, efficiency of the bisection,
exactness of the cause, no debug leftovers, regression test present,
verification quoted.

Threshold: no axis below 3, average at least 4. A report with a cause that
does not explain the observed frequency and scope is redone.

## 7. Interfaces

- Upstream: `project-exploration`, `engineering-orchestrator`.
- Lateral: `backend-engineering`, `frontend-engineering`,
  `performance-engineering` when the symptom is slowness,
  `security-audit` when the symptom is a vulnerability.
- Downstream: `testing-quality` for the regression test,
  `code-review-protocol`, `project-continuity`.
