# Example: a severity 2, handled twice

The same incident, run badly and run well. The system, the cause and the
people are identical.

## Run badly

```
13:52  errors begin
14:01  a customer emails support
14:06  support asks in the engineering channel: "is checkout ok?"
14:08  an engineer starts reading logs
14:15  a second engineer starts reading the same logs, independently
14:22  the first engineer changes a timeout value in production to see if it
       helps. Does not announce it.
14:26  the second engineer restarts the payment service, believing it is
       hung. Does not announce it.
14:29  errors change shape. Neither engineer knows which change caused it.
14:41  someone asks whether anything was deployed. Yes: 13:48.
14:52  rollback started
15:04  errors stop
15:20  the timeout change is still in place, undocumented
next day, someone notices the timeout and reverts it, causing a second brief
       incident
```

Seventy two minutes, two unrecorded changes, no customer communication, and a
follow up incident created by the response.

## Run well

```
13:52  errors begin
14:04  alert fires on the payment error rate
14:05  the on call engineer declares, severity 2, and takes the lead
14:06  first update: "Investigating checkout failures. Next update 14:20."
14:07  roles: lead, operator, and support acts as communicator. Scribe is the
       lead's own timeline document, since the team is three people.
14:08  the lead asks what changed. Deployment at 13:48.
14:10  decision announced: roll back. One change, one operator.
14:12  rollback started
14:18  error rate normal
14:20  second update sent
14:22  the lead asks the question that mattered: were any of those customers
       charged? The operator checks the provider rather than the application.
       Answer: no. That is now a fact rather than an assumption.
14:33  cause confirmed by reading the diff: the client began sending the
       amount as a decimal string
14:40  third update
15:05  verification: 20 real checkouts exercised against production, queues
       drained, 214 failed orders identified and their customers mailed
15:05  resolved, fourth update sent
```

Thirteen minutes to declaration, six minutes to mitigation, one change at a
time, and a fact about charges instead of a hope.

## The difference, in three behaviours

```
1  declaring created a lead, and the lead did not type. In the bad run, both
   engineers were operators and nobody held the picture.
2  every change was announced before it was made. In the bad run, two
   simultaneous changes made the symptom uninterpretable for twelve minutes.
3  the question "what changed" was asked at minute three instead of minute
   thirty six. It is the highest yield question in this discipline and it is
   free.
```

## The postmortem that followed the good run

Four contributing factors, of which two were about detection and deployment
rather than about the defect:

```
the alert needed 12 minutes of sustained errors before firing
the payment service deployed to 100 percent of traffic immediately
no test exercised the client and the handler together
the client's serialisation change was deliberate and unannounced
```

Four actions, all scheduled in the normal queue. Six months later, a similar
serialisation change was caught by the contract test in the pipeline, which is
the only measure of a postmortem that matters.
