---
name: realtime-systems
description: Builds live features that survive a real network: transport choice between polling, server sent events and websockets, connection lifecycle and reconnection with state recovery, message ordering and deduplication, authorization on every message, presence, fan out and scaling across processes, backpressure, and offline behaviour. Use for live updates, collaboration, notifications, dashboards and chat.
license: MIT
metadata:
  category: dev-skills
  version: 1.0.0
  depends_on: [engineering-core, architecture-design]
  outputs: [transport-decision, connection-lifecycle, message-contract, recovery-strategy, scaling-plan]
---

# Realtime Systems

A live feature is a distributed system with a user watching it. Connections
drop, messages arrive twice or not at all, and two clients disagree about the
truth. All of that happens on ordinary mobile networks, not only under load.

Design the recovery path first. The connected case needs almost no design.

## 1. Choose the cheapest transport that works

| Transport | Fits | Costs |
|---|---|---|
| request on demand | data the user asks for | nothing, and it is often enough |
| polling | low frequency updates, small payloads | wasted requests, latency of one interval |
| long polling | occasional updates, hostile networks | connection per client, complexity |
| server sent events | one way server to client, text | one direction only, connection limits per host |
| websocket | two way, frequent, low latency | connection state, scaling, more failure modes |
| broker to client | many subscribers, existing infrastructure | another dependency to operate |

Polling every thirty seconds is not an embarrassment. It is a design with one
failure mode, and it should be refused only for a stated reason.

## 2. Connection lifecycle

```
connect        authenticated before the socket is accepted, not after
authorise      per subscription, not per connection
heartbeat      both directions, with a timeout shorter than the network's
disconnect     detected by both sides, distinguished from idle
reconnect      exponential backoff with jitter, and a cap
resume         with a cursor or a sequence number, not from zero
give up        after a limit, the interface says the connection is lost and
               offers a manual retry
```

The interface must always tell the user which state it is in. A stale screen
that looks live is worse than a visible disconnection.

## 3. State recovery

The hard part, and the one usually skipped.

```
every client tracks the last message it processed
on reconnect it sends that cursor and receives what it missed
where a gap cannot be served, the server says so and the client refetches
  the full state rather than pretending continuity
the full refetch path is tested, because it runs after every long
  disconnection
a message that arrives twice after a resume is discarded by identifier
```

Without a cursor, a reconnection silently loses updates, and the client shows
a plausible, wrong screen.

## 4. Message contract

```
type            a documented enumeration
id              unique, for deduplication
sequence        per channel, for gap detection
timestamp       server assigned, not client
payload         identifiers plus the minimum data, or a signal to refetch
version         the shape version, since clients update slowly
```

Two styles: send the change, or send a signal to refetch. Sending a signal is
slower and far more robust, because it cannot desynchronise. Prefer it unless
the payload volume forbids it.

## 5. Authorization on every message

```
a subscription is authorised when it is created, and re-checked when
  permissions change
a permission revoked mid connection closes or downgrades the subscription
  immediately
a message is never broadcast to a channel whose members are not all entitled
  to every field in it
a client identifier in a message is never trusted; the server knows who is
  connected
tenancy is enforced on the channel name, and the channel name is derived
  server side
```

Live features are where authorization is most often forgotten, because the
check happened once at connection.

## 6. Ordering and conflicts

```
order per channel, never globally, and only if the feature needs it
gaps detected by sequence, and healed by refetch
concurrent edits: last write wins, per field merge, or a real algorithm,
  decided explicitly and told to the user
a conflict the user must resolve is shown, not resolved silently
clocks: never order by client time
```

Collaborative editing needs a designed algorithm. Anything less becomes a
sequence of silent overwrites that users describe as the application eating
their work.

## 7. Scaling

```
connections are state: a process holds them, so deploys disconnect everyone
fan out across processes needs a broker or a pub sub layer
a broadcast to a large channel is a burst: batch, throttle, or shard
per connection memory measured, and the maximum per process known
backpressure: a slow client must not grow an unbounded buffer, it is dropped
  or slowed deliberately
rolling deploys stagger reconnections, or every client reconnects at once
```

## 8. Offline and the browser

```
the tab is suspended, then resumed hours later
the device sleeps and wakes on a different network
two tabs hold two connections for one user
the connection survives the page but not a navigation
the user is genuinely offline: the interface says so and queues nothing it
  cannot deliver
optimistic updates are reconciled or rolled back visibly
```

## 9. Prohibitions

- Never treat a live channel as a substitute for a durable store: a missed
  message must be recoverable from state.
- Never authorise once at connection and never again.
- Never broadcast a payload containing fields some subscribers may not see.
- Never reconnect without backoff and jitter: a server restart becomes a
  self inflicted denial of service.
- Never leave the interface showing stale data as if it were live.
- Never resolve a concurrent edit silently when the user could lose work.
- Never let a slow consumer buffer without bound.

## 10. Protocol

1. State the requirement in latency terms and choose the cheapest transport.
2. Define the channels, and derive their names server side from identity.
3. Define the message contract, including identifiers, sequence and version.
4. Design the connection lifecycle, including give up and manual retry.
5. Design recovery: cursor, gap detection, and the full refetch path.
6. Enforce authorization per subscription and on permission change.
7. Decide ordering and conflict resolution explicitly.
8. Plan fan out, backpressure and deployment behaviour.
9. Handle suspension, multiple tabs and genuine offline in the client.
10. Test: drop, resume, duplicate, gap, revocation mid connection, deploy
    during use, and a slow consumer.

## 11. Auto-critique

Score from 0 to 5: transport justified, lifecycle complete including give up,
recovery with cursor and refetch path, authorization per message, ordering and
conflicts decided, fan out and backpressure planned, offline and suspension
handled, tests covering drop and revocation.

Threshold: no axis below 3, average at least 4. A feature with no tested
reconnection path is a demonstration, not a live feature.

## 12. Interfaces

- Upstream: `architecture-design` for the boundary, `api-design` for the
  message contract, `technology-selection` for the transport.
- Lateral: `backend-engineering`, `frontend-engineering`, `background-jobs`
  for the fan out, `caching-strategy` when state is served from a cache.
- Downstream: `reliability-testing` for disconnection drills,
  `security-testing` for channel authorization, `observability` for connection
  and lag metrics, `performance-engineering` for fan out cost.
