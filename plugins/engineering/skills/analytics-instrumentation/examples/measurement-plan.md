# Example: a measurement plan that replaced forty events with nine

The situation: an existing product with 412 events, a warehouse bill nobody
could justify, and a product team unable to answer whether the new onboarding
worked.

## Why 412 events answered nothing

```
94 events emitted from the client only, including "subscription_started",
   which disagreed with the billing system by 11 percent
71 events never queried, added during a feature and never removed
38 pairs of events measuring the same action with two names
17 events with a user's email in a property
5  events named after a value: plan_upgraded_to_starter, _to_team, _to_business
1  event, "click", with a free text label property containing 2,300 distinct
   values, including some the user had typed
```

The team was not short of data. They were short of definitions.

## The question first

```
Question   does the new onboarding increase activation
Decision   keep the new flow, revert it, or iterate
Definition activation = at least one document created within 7 days of
           account creation, excluding internal domains
Guess      current activation is around 30 percent, and the new flow moves it
           to 40 percent. If it moves less than 3 points, it is noise.
Wrong how  if account_created fires twice per signup, activation looks lower.
           If document_created fires on drafts, it looks higher.
```

That last line produced two validation tests before any dashboard was built.

## The nine events

```
account_created         server   plan, source, organisationId
onboarding_started      client   variant, step count
onboarding_step_viewed  client   step, variant
onboarding_completed    client   variant, durationMs
onboarding_skipped      client   step, variant
document_created        server   source (blank, template, import), templateId
invite_sent             server   role
invite_accepted         server   role, hoursSinceSent
subscription_started    server   plan, amountMinorUnits, currency, interval
```

Four client events, because interface behaviour is only observable there. Five
server events, because every one of them appears in a business figure and a
client event is a signal, not a record.

`subscription_started` moved from the client to the server, and the 11 percent
disagreement with billing disappeared. It was ad blockers and closed tabs.

## Identity

```
anonymous  a device identifier, before signup
user       the internal opaque id, never the email
link       at account_created, earlier anonymous events are attributed
tenant     organisationId on every event, since analysis is per organisation
logout     the anonymous identifier is regenerated, so a shared device does
           not attribute one person's behaviour to another
```

The 17 events carrying an email were the reason the previous deletion request
took a week and involved a support ticket to the provider.

## Enforcement in code

```ts
// one typed function per event, no free form emit
track.documentCreated({
  documentId, organisationId,
  source: "template",        // enum, checked at compile time
  templateId,
})
```

The generic `track(name, props)` call was deleted from the codebase. That
single change made 71 unused events impossible to recreate, because adding one
now requires an entry in the register and a typed function.

## Validation

```
pipeline    unknown event names and unknown properties are quarantined, not
            silently accepted. First week: 3 quarantined, all from a stale
            client version, which was the point.
tests       account_created fires exactly once per signup, verified at the
            handler. document_created does not fire for a draft.
monitors    volume per event, alert on a 50 percent drop over a day. It fired
            twice in six months: once a real release defect, once a provider
            outage.
release     the events touched by a release are checked in staging before it
            ships
```

## Result

```
before  412 events, no answer to the question, 11 percent disagreement with
        billing, personal data in the warehouse
after   9 events, the question answered in three weeks, figures reconciled
        with billing to the unit, no personal data, warehouse cost down by an
        order of magnitude
```

The activation figure was 31 percent before and 34 percent after: inside the
noise band the team had defined in advance. They iterated instead of
celebrating, which is what defining the threshold beforehand is for.
