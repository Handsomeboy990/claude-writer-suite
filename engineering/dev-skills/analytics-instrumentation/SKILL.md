---
name: analytics-instrumentation
description: Designs product measurement before events are emitted: the questions the data must answer, an event schema with stable names and typed properties, identity and session handling, funnels and conversion definitions, error and performance signals, consent and minimisation, validation in the pipeline, and the deprecation path for events nobody reads. Use before adding a tracking call, and when the existing data cannot answer a question.
license: MIT
metadata:
  category: dev-skills
  version: 1.0.0
  depends_on: [engineering-core, data-privacy]
  outputs: [measurement-plan, event-schema, tracking-implementation, validation-rules, event-register]
---

# Analytics Instrumentation

Instrumentation added event by event, as each feature ships, produces a
warehouse full of data that answers no question. The work is not the tracking
call; it is deciding what must be answerable, then emitting the minimum that
answers it.

Analytics collects behaviour about people. `data-privacy` governs that, and
its rules are not relaxed here because the destination is a dashboard.

## 1. Start from the questions

```
what decision will this data inform, and who takes it
what would we do differently depending on the answer
what is the current best guess, so the data can contradict it
how will we know the measurement itself is wrong
```

An event with no question behind it is cost: pipeline volume, schema surface,
privacy exposure, and one more thing to maintain. Refuse it.

## 2. Event schema

```
naming        object then action, past tense: document_created, invite_sent
              one convention, applied everywhere, never renamed in place
properties    typed, documented, with a stated unit where relevant
required      the properties every analysis needs, always present
optional      declared, never silently added by one caller
versioning    a version on the event, or a new name for a changed meaning
no free text  a property whose values are unbounded cannot be analysed
```

Never encode a value in an event name. `plan_upgraded_to_business` becomes
`plan_upgraded` with a `plan` property, or every query needs a list of names
that grows with the catalogue.

## 3. Identity

```
anonymous identifier, stable per device, for pre-signup behaviour
user identifier, opaque and internal, never an email address
the moment the two are linked, and what happens to earlier events
tenant or organisation identifier where the product is multi-tenant
never a name, an address, a phone number or free text a user typed
logout, account switching and shared devices, each decided explicitly
```

Using an email as an analytics identifier makes every deletion request an
incident. It is the single most common defect in this area.

## 4. Where events are emitted

| Source | Fits | Cost |
|---|---|---|
| client | interface behaviour: views, clicks, abandonment | blocked, lost, or duplicated. Never authoritative |
| server | anything that must be correct: purchases, quota, state changes | no visibility into what the user saw |
| both | the same action, deliberately, to compare | duplicate counting if the identity is not shared |

Anything that will appear in a business figure is emitted server side. A
client event is a signal about behaviour, not a record of a fact.

## 5. Funnels and definitions

```
each funnel: the ordered steps, the window, the identity that joins them
each conversion: defined once, in one place, referenced everywhere
each metric: numerator, denominator, and the exclusions
write the definition before the query, so two dashboards cannot disagree
record the date a definition changed, since every trend crossing it is broken
```

Two dashboards showing different numbers for the same word is not a data
problem. It is two definitions and no register.

## 6. Consent and minimisation

```
events respect the consent state, checked at emission, not filtered later
a refusal means nothing is sent, not that it is sent and discarded
the minimum properties that answer the question, and nothing kept in case
no personal data in a property, including in a page path or a search term
page paths carrying identifiers are normalised before sending
retention set on the provider, matching the inventory in data-privacy
a user deletion propagates to the analytics provider, and is verified
```

## 7. Validation

Instrumentation rots silently: nobody notices a missing event until a
quarterly question cannot be answered.

```
schema enforced in code: a typed function per event, not a free form call
unknown events and unknown properties rejected or quarantined by the pipeline
a test that the critical events fire, at the layer that emits them
a monitor on volume per event, alerting on a drop as well as a spike
a release check: the events the release touches still arrive
```

## 8. The register, and deletion

```
one register: event, question it answers, owner, properties, source, status
review it on a schedule: an event nobody queried in six months is a candidate
deprecate deliberately: mark, announce, stop emitting, then drop
remove the tracking call as part of removing the feature it measured
```

## 9. Prohibitions

- Never add an event without the question it answers.
- Never use an email, a name or any personal value as an identifier.
- Never put user typed content in a property.
- Never emit a business figure from the client alone.
- Never encode a value in an event name.
- Never rename an event in place; a changed meaning is a new name.
- Never emit anything the consent state forbids.
- Never leave an event unowned and unreviewed.

## 10. Protocol

1. Collect the questions and the decisions they inform.
2. Derive the smallest event set that answers them.
3. Write the schema: names, properties, types, required, source, version.
4. Decide identity, linking, and behaviour on logout and account switching.
5. Emit business relevant events server side, interface signals client side.
6. Define funnels and metrics once, in a register.
7. Apply consent, minimisation and retention with `data-privacy`.
8. Enforce the schema in code and validate it in the pipeline.
9. Add volume monitoring and a release check.
10. Review the register, deprecate what nobody reads, and delete its code.

## 11. Auto-critique

Score from 0 to 5: questions before events, schema discipline, identity
without personal data, correct source per event, definitions registered,
consent and minimisation applied, validation and monitoring in place, register
maintained with deprecation.

Threshold: no axis below 3, average at least 4. A personal identifier used as
an analytics key, or a business figure emitted only from a client, fails
regardless of the rest.

## 12. Interfaces

- Upstream: `requirements-analysis` for the questions, `data-privacy` for what
  may be collected at all, `dependency-selection` for the provider.
- Lateral: `frontend-engineering` and `backend-engineering` for emission,
  `feature-flags` for experiment exposure, `observability` for the operational
  signals, which are a different concern from product measurement.
- Downstream: `testing-quality` for the emission tests,
  `technical-documentation` for the register, `data-privacy` for deletion
  propagation.
