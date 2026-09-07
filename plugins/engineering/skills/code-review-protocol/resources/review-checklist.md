# Review checklist

Five passes, one question each. Run in order. Do not merge the passes.

## Pass 1, correctness

- [ ] Every new branch was traced with a concrete input.
- [ ] Null, undefined, empty string, empty array, zero and NaN handled.
- [ ] Optional chaining does not hide a case that needs handling.
- [ ] Every promise is awaited or deliberately detached with a comment.
- [ ] No floating promise inside a try block that will not catch it.
- [ ] Sequential awaits that could be concurrent, and the reverse.
- [ ] Check then act sequences are atomic or guarded.
- [ ] Read modify write on shared state uses a lock or an atomic operation.
- [ ] No `any`, unchecked cast or non null assertion on external data.
- [ ] External responses are validated before their fields are used.
- [ ] Boundaries tested: first, last, single, none, maximum, overflow.
- [ ] Date handling: timezone, daylight saving, month end, leap day.
- [ ] Invalid states are rejected, not merely undocumented.
- [ ] Transactions cover exactly what must be atomic.
- [ ] No work after commit that assumed the commit succeeded silently.
- [ ] No empty catch, no catch that logs and continues into a broken state.

## Pass 2, security

- [ ] Authentication is enforced on the new path, not assumed.
- [ ] Authorization is checked server side for every new access path.
- [ ] Queries using a request supplied identifier are scoped by owner.
- [ ] No string concatenation into SQL, shell, path, template or header.
- [ ] User content rendered into HTML is escaped or sanitised at the sink.
- [ ] No server side fetch of a user supplied URL without an allowlist.
- [ ] State changing requests are protected against cross site submission.
- [ ] Uploads restrict type, size and destination, and never execute.
- [ ] No secret in code, log, error message or test fixture.
- [ ] Responses contain only fields the caller is entitled to see.
- [ ] Price, role, ownership and workflow state come from the server.
- [ ] Error messages do not distinguish existing from non existing accounts.

## Pass 3, performance

- [ ] No query inside a loop, including the ORM shaped version.
- [ ] Every list query has a limit or a pagination contract.
- [ ] Columns used for filtering, joining or ordering are indexed.
- [ ] No data fetched and then discarded.
- [ ] Repeated network calls in a hot path are batched or cached.
- [ ] Expensive computation in a render path is memoised or moved.
- [ ] No blocking operation on the request thread or event loop.
- [ ] Serialisation does not include relations nobody asked for.
- [ ] Client references passed to memoised children are stable.
- [ ] Each finding states the scale at which it appears.

## Pass 4, architecture

- [ ] Business rules are not in handlers or components.
- [ ] Queries are not in components or controllers.
- [ ] No rule is implemented twice.
- [ ] No module reaches into another module's internal files.
- [ ] No circular dependency introduced.
- [ ] No abstraction with a single implementation and no second in sight.
- [ ] New files are placed where two existing occurrences say they belong.
- [ ] Function names match what the bodies do.
- [ ] No dead code, no commented out code, no unread flag.

## Pass 5, robustness

- [ ] Every failure path returns or renders something truthful.
- [ ] Loading state exists where the user waits.
- [ ] Empty state exists where a list can be empty.
- [ ] Error state exists where a request can fail, with an actionable message.
- [ ] Every outbound call has a timeout.
- [ ] Retries are bounded and applied only to idempotent operations.
- [ ] Double submission cannot duplicate an effect.
- [ ] Behaviour when the external service is down is chosen, not accidental.
- [ ] Logs allow reconstruction of the failure, and contain no secret.

## Closing

- [ ] Every finding has a file, a line range and a failing input.
- [ ] Every blocker and major is fixed.
- [ ] Every fix was verified by running something, with the output quoted.
- [ ] The diff was re-read after fixing.
- [ ] Follow ups that were not fixed are recorded in continuity notes.
