# Failure mode catalogue

Per dependency, the modes worth injecting and the defect each one exposes.
Mark a mode `n/a` with a reason rather than leaving it blank.

## Database

```
connection refused        does the application start, and what does it serve
connection lost mid       is the transaction rolled back, is the user told
  transaction
pool exhausted            does one slow query take the whole product down
slow query                does the request time out cleanly, or hang
replica lag               does a read after write show stale data to its author
constraint violation      does it reach the user as a message or as a stack
deadlock                  is it retried safely, or surfaced as a 500
migration in progress     does the previous release still work
```

## Cache

```
unavailable               does the product still work, slower
stale value               is the staleness bounded and acceptable
eviction under load       does a cold cache cause a request storm
wrong value               is anything security relevant cached without a key
                          that includes the caller
```

## Queue and jobs

```
broker unavailable        is the enqueue failure visible to the caller
message delivered twice   is the handler idempotent
messages out of order     does the handler assume order it does not have
message lost              is there a way to notice, and to replay
handler crash mid work    is the work retried, and is the partial effect safe
poison message            does one bad message block the queue forever
schedule missed           does a skipped run self correct or accumulate
```

## Object storage

```
unavailable on upload     is the record written anyway, pointing at nothing
unavailable on download   what does the user see
slow upload               does the request time out with the file half stored
delete failed             are orphans detected, or do they accumulate
wrong content type        is it served safely
```

## Payment provider

```
timeout after capture     the money moved and the response never arrived. The
                          single most important case in this catalogue
declined                  is the message useful and the cart preserved
duplicate webhook         is the order created once
webhook before response   does the order exist when the webhook arrives
provider error            is the user told to retry, and is retrying safe
refund failure            is the state left consistent
```

## Mail and notification providers

```
unavailable               is the user operation rolled back, or does it
                          proceed with the notification queued
accepted then bounced     does the product learn, or believe it succeeded
slow                      is mail sent inside the request path, blocking it
duplicate send            one intent, one mail
```

## Identity provider

```
unavailable               can existing sessions continue
slow                      does login time out cleanly
token validation fails    is access denied, or granted by an error path
key rotation              are old tokens rejected and new ones accepted
logout propagation        does a revoked session actually stop working
```

## Search service

```
unavailable               is search degraded or is the page broken
index stale               does a newly created object appear
partial results           is the count honest
query error               does an unusual query return an error page
```

## Any external API

```
unavailable, slow, timeout, 4xx, 5xx, 429
malformed body
a missing field the client dereferences
a field with an unexpected type
a list far larger than expected
a redirect the client follows blindly
TLS failure
```

## The browser

```
offline mid operation
slow connection throughout
one request blocked, the rest fine
a resource that fails to load
tab suspended and resumed
storage unavailable or full
```

## Recording sheet

```
dependency: payment provider          operation: checkout

mode                inject point         property 1  2  3  4   finding
timeout             before capture       ok   ok   ok   ok
timeout             after capture        FAIL ok   FAIL ok     REL-02
declined            at authorisation     ok   ok   ok   ok
duplicate webhook   after success        ok   n/a  FAIL ok     REL-03
provider 500        at capture           ok   FAIL ok   ok     REL-04
refund failure      after order          ok   ok   FAIL ok     REL-05

property 1 fails honestly  2 communicates  3 stays consistent  4 recovers
```
