# Connection and recovery checklist

## Transport decision

```
how fresh must the data be, in seconds, from the requirement
how many clients watch the same data
how often does it change
is the traffic one way or two
what does the infrastructure already run
what is the cost of the simplest option being wrong by one interval
```

If the answer to the first question is `within a minute`, polling wins and the
rest of this document shrinks to nothing.

## Lifecycle states the interface must express

```
connecting        first attempt, or after a drop
live              connected and current
reconnecting      with an attempt count or a countdown
degraded          connected, but behind: catching up
disconnected      gave up, with a manual retry control
offline           the device has no network
```

Six states, and the interface shows which one it is in. A screen that shows
data with no indicator is asserting freshness it cannot guarantee.

## Reconnection

```
backoff        base 1s, factor 2, jitter, cap 30s
attempts       unlimited while the tab is visible, paused when hidden
resume         send the last processed message id or sequence
server         serves the gap, or answers "gap too large, refetch"
client         on "refetch", fetches the full state and resets the cursor
duplicates     discarded by message id after a resume
thundering     jitter is mandatory: without it, every client returns at the
               same second after a deploy
```

## Authorization

```
connection authenticated before acceptance
each subscription authorised on creation
subscription re-evaluated on permission change, role change and logout
channel names derived from server side identity, never accepted from a client
messages contain only fields every subscriber may see
a revoked user's socket is closed or downgraded within seconds, tested
```

## Message design

```
{ "id": "msg_01J...", "seq": 1487, "channel": "org_9:documents",
  "type": "document.updated", "v": 2,
  "at": "2026-08-12T14:03:11Z",
  "data": { "documentId": "doc_148" } }
```

```
id       deduplication after a resume
seq      per channel, gap detection
type     documented enumeration
v        shape version, because clients update slowly
data     identifiers, and a signal to refetch rather than the full entity
```

## Failure drills

```
1  drop the connection mid session: reconnects, resumes, no lost update
2  disconnect for longer than the gap buffer: refetches full state
3  deliver the same message twice: one visible effect
4  deliver messages out of order: gap detected, healed
5  revoke a permission mid connection: subscription closed within seconds
6  deploy while connected: staggered reconnection, no stampede
7  slow consumer: buffer bounded, client dropped or slowed deliberately
8  suspend the tab for an hour and resume: state correct within seconds
9  two tabs, same user: both correct, no duplicated side effects
10 genuine offline: interface says so, no silent queueing of impossible work
```

## Metrics

```
connected clients, per process and total
reconnection rate, and the reason distribution
message lag: server publish to client acknowledgement
gap and refetch rate, which is the health signal for recovery
dropped slow consumers
fan out duration for the largest channel
```

A rising refetch rate means the gap buffer is too small or clients are
unstable, and it is visible long before users complain.
