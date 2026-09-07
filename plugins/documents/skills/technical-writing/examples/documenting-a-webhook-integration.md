# Documenting a webhook integration for a partner

Deliverable: an integration guide for a partner engineering team that must
receive our order webhooks. They have never seen our system and we will not be
in the room when they build against it.

Audience profile, from `document-core` section 3: developer integrating.
Output language English. Cost of misreading: a broken integration discovered
in their production, and a support relationship that starts badly.

## The first draft, and why it failed

The first draft opened with two pages on our order lifecycle, then the event
catalogue, then authentication on page four.

Followed by an engineer who had not seen it, using nothing but the document:
eleven minutes before the first request could be attempted, and they gave up
on signature verification because the example was pseudocode.

Rewritten to the shape in section 2, and to two rules from section 4: working
example first, and answer the second question.

## What verification produced

Twenty-three claims. The log, abridged:

| Claim | Verified by | Result |
|---|---|---|
| Signature header is `X-Signature` | read the sending code | it is `X-Order-Signature`; the draft was wrong |
| Signature is HMAC-SHA256 of the body | read the sending code | correct, but over the raw body before JSON parsing, which the draft did not say |
| Retries: 3 attempts | searched the codebase | 5 attempts, exponential, 1s to 16s |
| Retries stop after a 4xx | tested against a stub returning 400 | correct, except 429, which is retried |
| Events arrive in order | reasoned about the queue | false; the queue is not ordered per key |
| `order.updated` fires on any change | traced the emitters | fires on status change only; a shipping address edit emits nothing |
| Payload includes `customer.email` | called it against staging | present, but null for guest orders |

Two of these would have broken the partner in production. Ordering, because
they would have applied a cancellation before the creation it referred to.
Null email, because their handler would have thrown on every guest order,
which is a third of the volume.

Neither was discoverable by reading our draft. Both came from running it.

## The delivered structure

```
1. Receive your first webhook          working end to end in under five minutes
2. Verify the signature                 real code, three languages, over the raw body
3. Respond correctly                    what a 2xx means, what a 4xx and 5xx cause
4. Retries and duplicates               five attempts, at-least-once, dedupe by event id
5. Ordering                             not guaranteed; reconcile by version, not arrival
6. Event catalogue                      per event: when it fires, when it does not, payload
7. Failure modes                        what you see when it goes wrong, and what to do
8. Going live                           checklist, limits, contacts
9. Changelog
```

Sections 4 and 5 exist because of section 4 of the skill: answer the second
question. The reader asks how to receive an event. They immediately need to
know whether it can arrive twice and whether it can arrive out of order. Both
answers are yes. Burying that under a catalogue would be technically complete
and practically negligent.

## An entry from the catalogue

```markdown
### order.updated

Fires when an order's status changes.

Does not fire when: the shipping address, the customer note or an internal
tag changes. If you need those, poll `GET /orders/{id}`. This is a known
limitation, not an oversight.

Payload:

{
  "id": "evt_01J8X2M4",
  "type": "order.updated",
  "created_at": "2026-07-14T09:31:22Z",
  "version": 7,
  "data": {
    "order_id": "ord_9c1f",
    "status": "shipped",
    "previous_status": "processing",
    "customer": { "id": "cus_4a20", "email": null }
  }
}

Captured from staging on 2026-07-14. `customer.email` is null for guest
orders, which is roughly a third of volume. Treat it as optional.

Use `version` to order events for one order. Do not use `created_at`: two
events for the same order can share a timestamp, and arrival order is not
delivery order.
```

Real payload, captured and dated. The null is shown rather than described, and
the reason it is null is stated. The ordering trap is named where the reader
hits it, not only in section 5.

## Failure modes section

The section that most drafts omit, and the one partners actually use.

| What you see | What happened | What to do |
|---|---|---|
| Signature never matches | verifying the parsed and re-serialised body | verify over the raw body, before parsing |
| Signature never matches, raw body used | using `X-Signature` | the header is `X-Order-Signature` |
| Same event twice | at-least-once delivery, or you returned 5xx after processing | dedupe on `id`, persist before responding |
| Events stop entirely | five failures exhausted the retries | check your endpoint, then request a replay |
| A cancellation before its creation | ordering is not guaranteed | reconcile on `version`, ignore lower versions |
| 429 from us on replay | replays are rate limited to 100 per minute | back off, the retry is automatic |

## Gate record

```
Document: Order webhooks integration guide, v1, English
Audience: partner developer integrating
1 Content     pass  23 claims, 21 verified by running, 2 corrected from source, 0 gaps
2 Structure   pass  working webhook in section 1, catalogue after the guarantees
3 Language    pass  event, not notification or message, throughout
4 Formatting  pass  document-design applied
5 Audience    pass  no internal architecture, no product narrative
6 Consistency pass  order id format identical in all seven examples
7 Requirement pass
8 Self critique  pass  technical writer, new developer, subject matter expert, support agent
Gaps remaining: none
```

The support agent role was added to the panel deliberately. It asked what
ticket this document generates, and the answer was the failure modes table:
the six rows are the six tickets the previous partner integration produced.
