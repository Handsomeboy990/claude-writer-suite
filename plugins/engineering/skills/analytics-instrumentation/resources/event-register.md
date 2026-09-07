# Event register

One file, reviewed on a schedule. An event absent from it is not instrumented,
it is emitted.

## Entry

```
event        document_created
question     does the onboarding change increase first week activation
owner        product, growth
source       server
properties   documentId (string), templateId (string, optional),
             organisationId (string), source (enum: blank, template, import)
identity     userId, organisationId
consent      required category: analytics
version      1
status       active
added        2026-03-04
last queried 2026-08-02
```

## Naming rules

```
object_action, past tense, lower snake case
one convention across the product
never a value inside the name
never a rename in place: a changed meaning is a new event with a new name
```

```
good     invite_sent, invite_accepted, plan_upgraded, export_completed
bad      sentInvite, invite, user_clicked_the_invite_button_v2
bad      plan_upgraded_to_business        the plan belongs in a property
```

## Property rules

```
typed, documented, with a unit in the name where relevant: durationMs
enumerations declared, and their values listed
identifiers opaque and internal
no free text, no user typed content, no path containing an identifier
no personal data, ever, including in a referrer or a search term
```

## Metric definitions

```
metric       activation rate
numerator    accounts with at least one document_created within 7 days of
             account_created
denominator  accounts created in the period, excluding internal domains and
             accounts deleted within 24 hours
window       7 days from account_created
owner        product
defined      2026-03-04
changed      2026-06-01, exclusion of internal domains added. Every trend
             crossing that date is discontinuous and the dashboard says so.
```

The `changed` line is what stops a team from reading a definition change as a
product improvement.

## Review

Every quarter, per event:

```
still queried in the last six months        keep
never queried since it was added            deprecate
duplicated by another event                 merge, keep the older name
volume dropped to zero unexpectedly         defect: the emission broke
volume rose sharply with no release         defect: duplicate emission
owner has left and nobody claims it         deprecate
```

## Deprecation

```
1 mark as deprecated in the register, with the replacement if there is one
2 announce, with a date
3 stop emitting, and remove the call from the code in the same commit
4 keep the historical data until its retention expires
5 remove the entry from the register once the data has expired
```

Removing the tracking call is part of removing the feature it measured. A
codebase accumulating dead tracking calls is how a schema reaches four hundred
events, of which thirty are queried.
