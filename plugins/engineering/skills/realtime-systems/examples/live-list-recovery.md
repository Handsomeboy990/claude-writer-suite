# Example: a live document list, and the reconnection nobody tested

Requirement: when a colleague creates or renames a document, everyone viewing
the list sees it within a few seconds.

## What was built first

A websocket, a channel per organisation, and a message carrying the new
document. It demonstrated beautifully.

## What happened on real networks

```
a user on a train reconnects every few minutes. Each reconnection loses every
  document created during the drop. The list is wrong until a manual refresh,
  and nothing tells them.
a deploy disconnects 400 clients, all of which reconnect within the same
  second, and the process spends its first minute doing handshakes.
a member removed from the organisation keeps receiving document titles for
  eleven minutes, until their socket happens to close.
two tabs produce two connections and two toast notifications per event.
```

None of these appear in a demonstration, and all four are design omissions
rather than bugs.

## The redesign, in four decisions

```
1  messages carry a signal, not the entity
   { type: "documents.changed", seq: 1487, data: { documentId: "doc_148" } }
   the client refetches that document, or the list if it has fallen behind.
   Slower by one request, and it cannot desynchronise.

2  every channel has a sequence, and the client tracks the last one processed
   on reconnect: subscribe with seq=1487
   server: sends 1488 to 1502, or replies { gap: true } if the buffer no
   longer holds them
   on gap: the client refetches the whole list and resets its cursor

3  authorization re-evaluated on membership change
   removing a member publishes an internal event that closes their
   subscriptions within a second, tested with two accounts

4  reconnection backoff with jitter, and the tab pauses attempts when hidden
   the 400 client deploy now spreads reconnections over 30 seconds
```

## The interface change that mattered most

A single indicator with three visible states: live, reconnecting, and
disconnected with a retry control. It cost an afternoon.

The support tickets that motivated the whole redesign were not `the list is
wrong`. They were `the list is wrong and I did not know`. A screen that admits
it is stale converts a trust problem into a minor inconvenience.

## The drills, run before shipping

```
1  drop mid session                     resumes from seq, no gap, no refetch
2  disconnect 20 minutes                gap reported, full refetch, correct
3  duplicate message after resume       discarded by id, one visual update
4  revoke membership while connected    subscription closed in 0.8s
5  deploy with 400 connected clients    reconnections spread over 31s
6  two tabs                             both correct, one notification each,
                                        deliberate: they are two views
7  tab suspended one hour               refetch on resume, correct in 1.2s
8  slow consumer simulated              buffer capped at 200 messages, then
                                        the client is told to refetch rather
                                        than buffered indefinitely
```

Drill 4 is the one that was a security finding, and it was found by a checklist
rather than by an incident.

## What stayed simple

The notification badge in the header still polls every 60 seconds. It was
never moved to the socket, because its requirement is `within a minute` and
polling has one failure mode. Adding it to the live channel would have grown
the fan out for no requirement.

That decision is in the record, so the next engineer does not helpfully
migrate it.
