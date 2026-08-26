---
name: lead-research
description: Deepens a qualified prospect into an approach: researches the organisation and the specific person from live sources, finds the real, current reason to reach out, identifies the right contact and channel, and drafts an outreach angle grounded in evidence rather than a template. Every fact is sourced, and outreach is prepared, never sent without confirmation. Use to turn a shortlisted prospect into a personalised, well-timed approach that a real person will actually read.
license: MIT
metadata:
  category: business
  version: 1.0.0
  depends_on: [opportunity-core]
  outputs: [prospect-dossier, outreach-angle, contact-path, timing-assessment]
---

# Lead Research

Client discovery found who fits and shows a signal. Lead research turns one of
those prospects into an approach that lands: the specific, current reason to reach
out, the right person, the channel, and an angle grounded in something real about
them. It is the difference between a personalised message a busy person reads and
a template they delete. Every fact is sourced, and outreach is prepared, not sent.

## 1. Research the organisation, currently

```
current     what is true about them now: a recent announcement, a launch, a hire,
            a change, a stated goal, a public problem; the recency is what makes the
            outreach timely
context     the situation the provider's offering fits into: the pain, the growth,
            the transition the organisation is in
sourced     every fact from a live source, per opportunity-core; never a guessed
            detail about the company that a recipient would know is wrong
```

## 2. Research the person

```
right person   the actual decision-maker or influencer for what the provider
            offers, not just any senior name; approaching the wrong role wastes the
            approach
real        the person is real, their role is current, and the detail used to
            personalise is real and public; never a fabricated name or an invented
            personal detail
respect     public professional information only; nothing that crosses from
            research into intrusion, per data-privacy principles
angle       what about this person's stated priorities, role, or public work
            connects to the offering
```

## 3. Find the real, current reason to reach out

```
reason      the specific, true reason this outreach makes sense now: the signal
            from discovery, deepened into a concrete opening; "I saw you just
            raised a Series A and are hiring backend engineers" is a reason,
            "I help companies like yours" is not
timing      why now: the reason is current, not months stale; a signal has a
            shelf life, and outreach on a fresh one is welcome where a stale one
            is noise
value       the reason connects to a value the provider can actually deliver, not
            a manufactured hook that leads nowhere
```

## 4. Identify the contact path

```
channel     the right channel for this person and context: a professional network,
            email, a mutual connection, a public form; the channel that fits how
            this person is actually reachable
real        a real contact point from a live source; never a fabricated or guessed
            email address, which bounces and burns the domain
sequence    the approach, prepared: the opening grounded in the real reason, the
            value, a light ask; handed over for the provider to send, or to send
            only on explicit per-message confirmation
```

## 5. Prepare, do not send

```
draft       the outreach is drafted and handed to the provider; grounded in the
            research, specific to this prospect, honest about what the provider offers
confirm     nothing is sent on the provider's behalf without explicit confirmation
            for that specific message, per opportunity-core and the delegation model
honest      the draft claims only what the provider can deliver; an outreach that
            oversells sets up a relationship that fails at the first meeting
```

## 6. Prohibitions

- Never invent a fact about the organisation or the person.
- Never fabricate a contact name, email, or channel; a guessed email bounces and
  damages the sender.
- Never personalise with an invented or intrusive personal detail; public
  professional information only.
- Never manufacture a reason to reach out that leads to no real value.
- Never approach the wrong role because the name is more senior.
- Never send outreach on the provider's behalf without explicit per-message
  confirmation.
- Never draft an outreach that oversells what the provider can deliver.

## 7. Protocol

1. Take a qualified prospect from `client-discovery`.
2. Research the organisation's current situation from live sources.
3. Identify the right person and research their public professional context.
4. Find the specific, current, true reason to reach out, connected to real value.
5. Identify the real contact channel and a real contact point.
6. Draft the outreach angle, grounded and honest; hand it over.
7. Send only on explicit per-message confirmation.

## 8. Auto-critique

Score from 0 to 5: organisation researched currently from live sources, the right
person identified with real public context, a specific and current and true reason
to reach out, a real contact channel and point, outreach drafted honestly and
grounded, nothing invented, nothing sent without confirmation.

Threshold: no axis below 3, average at least 4. A fabricated fact, contact, or
personal detail, or outreach sent without confirmation, is an automatic zero
regardless of the average, per opportunity-core.

## 9. Interfaces

- Upstream: `opportunity-core` for grounding, `client-discovery` supplies the
  qualified prospect and the signal.
- Downstream: the outreach message and `cover-letter` for the drafting;
  `market-research` for the wider context; a CRM or messaging connector to send,
  on confirmation.
- Lateral: `source-research` and `source-verification` in `research/` for the
  gathering; `data-privacy` in `engineering/` for the boundary between research
  and intrusion.

## 10. Live sources, connectors, and consent

This skill reads whatever business, professional-network, and search sources the
runtime exposes, and drafts using them. It prepares outreach; it does not send it
without explicit per-message confirmation, and it never uses a messaging or CRM
connector to contact a person on the provider's behalf silently. When a source
cannot be reached, it names what the provider should look up, rather than
inventing facts about a real person, because a personalised message built on a
wrong or invented detail is worse than a generic one: it signals carelessness to
exactly the person the provider wants to impress.
