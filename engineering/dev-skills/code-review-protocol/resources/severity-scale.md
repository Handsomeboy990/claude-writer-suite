# Severity scale

Severity comes from the consequence, never from the size of the fix.

## blocker

The change must not ship.

- data loss or corruption on a realistic path;
- any user can read or modify another user's data;
- authentication or authorization can be bypassed;
- a secret is exposed;
- money can be moved with a client controlled amount;
- the feature does not do what was asked;
- a migration is irreversible and untested.

## major

Wrong behaviour in a case that will occur, or a failure with no handling.

- a realistic input produces a wrong result;
- an unhandled failure path leaves the user stuck or the state inconsistent;
- an unbounded query that will degrade with real data;
- a race condition reachable by two concurrent users;
- a business rule duplicated in two places, already divergent;
- no test covers a path that changed behaviour.

## minor

Correctness holds. Quality, clarity or cost suffers.

- a missing empty state on a list that is rarely empty;
- a redundant fetch with a measurable but small cost;
- a misplaced file that contradicts convention;
- an error message that is truthful but unhelpful;
- duplication that has not yet diverged.

## note

A preference with no defect behind it. Mentioned once, never argued.

If a note cannot be tied to a concrete future failure, it is dropped rather
than written.

## Calibration examples

| Finding | Level | Why |
|---|---|---|
| `findFirst({ where: { id } })` on a user owned resource | blocker | any authenticated user reads any record |
| total computed from a client supplied price | blocker | money, client controlled |
| `catch {}` around a payment capture | blocker | silent money loss |
| list endpoint without pagination on a growing table | major | degrades with real data |
| missing await on an audit log write | major | log silently lost, no failure visible |
| double click creates two orders | major | duplicate effect, no idempotency |
| no loading state on a slow page | minor | poor experience, no defect |
| helper placed in `utils` instead of the domain folder | minor | convention drift |
| a variable could be named better | note | no failure behind it |

## Anti inflation rule

Severity is not raised to force attention, and not lowered to avoid work. When
in doubt between two levels, state the consequence in one sentence and let the
sentence decide. If the sentence describes no consequence, the finding is a
note or nothing.
