# Injection methods

Ordered from least invasive to most. Take the first one that produces the mode
you need.

## 1 Network level stubs

Intercept the request where it leaves the process, and answer it however the
test requires. The project's own client code still runs, which is the point.

```
suits      timeout, error status, malformed body, partial body, wrong content
gives      determinism, no environment changes, works in CI
does not   prove anything about the real provider's behaviour
```

Use the interception mechanism the project already has. Introducing a second
one for a single campaign is a maintenance cost that outlives the campaign.

## 2 Browser level conditions

For anything the user experiences directly.

```
offline, then online again
a slow network profile for a whole flow
blocking a single request pattern while the rest succeeds
delaying one response by several seconds
returning an error for one endpoint only
```

This is where the honest failure property is usually broken: the interface
reports success because the client never checked, or reports nothing at all.

## 3 Client configuration

Shorten a timeout so it fires deterministically instead of waiting for a real
one. Reduce a retry limit so the exhausted chain can be observed in a test.

```
suits      timeout behaviour, retry limits, backoff
warning    the shortened value belongs to the test configuration, never to a
           shipped default
```

## 4 Proxy

A proxy between the application and a dependency, adding latency, dropping
connections or corrupting responses.

```
suits      slow dependencies, connection loss mid stream, TLS failure
needs      an environment you control end to end
```

## 5 Service control

Stop the dependency. The most realistic method and the most disruptive.

```
suits      unavailable at startup, dying mid run, recovery after restart
only in    an isolated environment the campaign owns
never in   production or any shared environment, without written authorisation
```

## 6 Data conditions

No injection at all: arrange the data so the failure is natural.

```
an empty table, for every empty state
a row referenced by another that no longer exists
a record older than a retention window
a value that predates a schema change
a queue with a message whose handler was deployed after it
```

Cheap, deterministic, and it finds the defects that survive every stub.

## Rules

```
one failure at a time, so the result attributes to a cause
inject at more than one point in the same operation
record the exact injection, so the finding is reproducible
remove every injection, and verify normal behaviour afterwards
never let an injection mechanism reach a shipped code path
never inject where the contract forbids it
```

## Turning a finding into a permanent test

Every reproducible finding becomes a test with the same injection at the
network boundary. Those tests are cheap, they run in CI, and they are the only
protection against the same defect returning with the next refactor.

```
given the payment provider times out after capture
when  the customer completes checkout
then  the order exists exactly once
and   the interface reports the outcome truthfully
and   retrying does not charge a second time
```
