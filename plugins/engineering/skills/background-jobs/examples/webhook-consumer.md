# Example: a webhook consumer that survives reality

The provider sends payment events. The first implementation is four lines and
works in every demonstration.

```ts
app.post("/webhooks/payments", async (req, res) => {
  const event = req.body
  await orders.markPaid(event.data.orderId)
  res.sendStatus(200)
})
```

Everything wrong with it appears within a month of real traffic.

## What real delivery looks like

```
the same event arrives 3 times, because our first response was slow
events arrive out of order: payment.succeeded before payment.created
an event arrives for an order created 200 ms ago, not yet visible to the
  replica this process reads from
the provider retries for 3 days on any non 2xx, including our own 500s
an event arrives signed by a key we rotated last week
a replayed event from six months ago arrives during a provider incident
```

## The version that holds

```
1  verify the signature before parsing, reject with 400, no processing
2  reject events older than the tolerated window, to refuse replays
3  write the raw event to a table with the provider event id as a unique key
   insert conflict means already received: respond 200 immediately
4  respond 200 as soon as it is durably stored, not after processing
5  enqueue processing from an outbox in the same transaction
6  process in a worker, idempotently, ordered per order id
```

Steps 3 and 4 together are the whole design: acknowledge fast, process later,
and let the unique key absorb duplicates.

## The handler

```
guarded transition, not a blind write

update orders
   set status = 'paid', paid_at = $2
 where id = $1 and status = 'pending_payment'

zero rows updated means the order was already paid, or is not payable. That is
not an error and does not retry. It is logged with the event id and the
current status, because that log line is what answers the support question
three weeks later.
```

Out of order delivery is handled by the same guard: a `payment.succeeded`
arriving before `payment.created` finds no pending order, records the event,
and a reconciliation job matches it when the order appears. The event is never
discarded.

## Retry policy

```
retryable    database unavailable, replica lag, our own dependency timeouts
permanent    unknown event type, malformed payload, unknown order after the
             reconciliation window
backoff      2s base, factor 2, jitter, maximum 5 minutes
attempts     8, then dead letter
dead letter  owned by the payments team, alert at one message, replay path
             tested on staging with a real dead lettered event
```

The classification matters: retrying an unknown event type eight times
produces eight identical alerts and no information.

## What the tests cover

```
the same event delivered three times: one order transition, one mail
two events for one order arriving concurrently: one wins, one is a no-op
payment.succeeded before payment.created: recorded, reconciled, no error
an event with a bad signature: 400, nothing stored, nothing processed
an event older than the window: rejected as a replay
the handler failing after the order update but before the mail: the retry
  sends the mail and does not re-transition the order
the provider retrying after our 500: the second attempt succeeds and produces
  no duplicate effect
```

Seven tests, each derived from a real delivery behaviour rather than from the
happy path.

## Observability that ended an incident in four minutes

```
metric   webhook_events_received, by type
metric   webhook_processing_age, oldest unprocessed event
metric   dead_letter_count, alert at 1
log      every event id, its type, and the transition it caused or did not
```

When the provider changed a field name, the dead letter count went to 1 within
a minute, the alert named the event type, and the raw event was already stored
and replayable. The fix was deployed and the stored events were replayed. No
payment was lost, and nobody had to ask the provider for a resend.
