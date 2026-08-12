# Payment test matrix

Every row exists because it has happened to someone. Run in test mode, with
the provider's simulation cards and events.

## Amount integrity

```
1  client sends a lower amount in the body               ignored, server amount
2  client sends a different currency                     ignored or rejected
3  client sends a plan or price identifier               validated against the
                                                         catalogue, never trusted
4  discount code applied twice in one request            applied once
5  discount code applied in two concurrent requests      applied once
6  cart modified between preview and confirm             amount recomputed, the
                                                         customer sees the change
7  rounding: three items at an odd unit price            total matches the
                                                         documented rule exactly
8  tax rate changed between quote and charge             the quoted rate applies,
                                                         or the customer is asked
                                                         again, decided and tested
```

## Idempotency and duplication

```
9   double click on pay                                  one charge
10  two tabs, same cart, simultaneous pay                one charge
11  client retries after a timeout                       one charge
12  provider retries the webhook 5 times                 one order transition
13  worker redeployed mid processing                     one effect
14  same idempotency key, different amount               conflict, no charge
15  replay of a six month old webhook event              rejected by the window
```

## Provider failure

```
16  timeout before the provider received it              no charge, retry safe
17  timeout after capture, response lost                 status queried, order
                                                         recorded, no second charge
18  provider returns 500 at capture                      unknown, resolved by query
19  provider declines                                    clear message, cart kept,
                                                         retry possible
20  provider unavailable for 10 minutes                  queue or refuse cleanly,
                                                         never a silent success
21  webhook never arrives                                reconciliation finds it
22  webhook arrives before the redirect returns          order already correct when
                                                         the customer lands
23  signature invalid                                    rejected, alerted
```

## State machine

```
24  capture an already captured charge                   refused
25  refund an uncaptured charge                          refused
26  refund more than the captured amount                 refused
27  two partial refunds summing above the charge         second refused
28  refund a refunded charge                             refused, idempotent
29  transition from a terminal state                     refused
30  unknown provider status                              mapped deliberately,
                                                         never to success
```

## Subscriptions

```
31  upgrade mid period                                   one proration, one invoice
32  upgrade twice in one minute                          one subscription, one charge
33  downgrade then upgrade in the same period            correct final state
34  renewal job runs twice                               one charge
35  renewal fails                                        dunning schedule starts,
                                                         access rule applied as
                                                         documented
36  cancel at period end                                 access until the exact
                                                         recorded moment
37  cancel then resubscribe                              no double billing overlap
38  trial converting                                     once, even on a rerun
39  card expires before renewal                          customer warned before,
                                                         not after
```

## Data and audit

```
40  no card number, security code or full bank detail stored anywhere
41  no payment payload in any log, including error logs and traces
42  every money action has an actor, a timestamp and a provider reference
43  the audit records are append only, verified by a test that attempts an update
44  an accountant question answered from the application alone
```

## Authorization

```
45  a customer requests another customer's invoice       404
46  a customer refunds their own charge                  refused, unless the
                                                         product permits it
47  a support role issues a refund                       permitted, recorded with
                                                         the actor
48  a webhook endpoint called directly without signature  rejected
```

## Reconciliation

```
49  a charge with no order, created manually in the provider  reported
50  an order with no charge                                   reported
51  amounts differing by one minor unit                       reported, not
                                                              auto-corrected
52  a refund recorded on one side only                        reported
53  the reconciliation report on a clean day                  produced, empty,
                                                              and its absence
                                                              would be noticed
```

Row 17 is the one to run first on any payment integration. It is the most
expensive failure and the least often tested.
