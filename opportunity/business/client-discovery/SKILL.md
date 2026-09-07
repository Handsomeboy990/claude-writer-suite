---
name: client-discovery
description: Finds real prospective clients for a service or product from live sources, never invented: defines the ideal client profile from what the provider actually offers, searches the reachable sources for organisations that fit and show a real signal of need, qualifies each against fit and reachability, and reports a shortlist with the evidence and a real point of contact or channel. Use to find who to approach, and to qualify a list of prospects before spending outreach effort.
license: MIT
metadata:
  category: business
  version: 1.0.0
  depends_on: [opportunity-core]
  outputs: [ideal-client-profile, qualified-prospects, fit-evidence, outreach-shortlist]
---

# Client Discovery

Finding the right clients to approach is the difference between outreach that
converts and effort sprayed at everyone. This skill defines who actually fits what
the provider offers, finds real organisations that match and show a signal of
need, and qualifies them, so the provider spends limited outreach on prospects
worth approaching. Every prospect is real and sourced, because a fabricated one
wastes real outreach.

## 1. Define the ideal client profile from the real offering

```
offering    what the provider actually does well, for whom; the profile follows
            the real capability, not an aspiration to serve everyone
who fits    the organisation type, size, sector, and situation that genuinely
            needs and can pay for this offering
signal      the observable sign that an organisation needs it now: a hiring
            pattern, a recent funding round, a product launch, a public problem, a
            technology they use; the signal is what separates a prospect from a name
exclude     who does not fit, so the search does not waste effort on organisations
            that will not convert
```

A profile that describes everyone describes no one, and produces a prospect list
that converts at random.

## 2. Search live sources for real organisations

```
sources     the business directories, professional networks, news, and connectors
            the runtime can reach
real        every prospect is a real organisation, found at a real source
signal      each is included because it shows the signal of need, not because it
            exists; a company that fits the profile but shows no signal of need now
            is a lower-priority prospect, marked as such
unreachable if no live source can be reached, say so and give the provider the
            exact search and directories to use; never invent prospect organisations
```

This is opportunity-core's grounding rule for business: a prospect that cannot be
traced to a live source is not a prospect.

## 3. Qualify against fit and reachability

```
fit         how well the organisation matches the ideal profile, with the evidence:
            the size, the sector, the situation, the signal
reachability   is there a real way to reach a real decision-maker or a real channel;
            a perfect-fit organisation with no reachable contact is a weaker
            prospect than a good-fit one the provider can actually reach
timing      the signal suggests a need now, soon, or someday; now outranks someday
priority    fit times reachability times timing; a strong fit, reachable, with a
            current signal is the top of the list
```

## 4. Report the shortlist with evidence

```
prospect    the organisation, with the fit evidence and the signal that qualified it
contact     a real point of contact or channel, from the source; never a fabricated
            name, email, or phone number
why         the specific reason to approach this organisation now: the signal, the
            fit, the angle
approach    a suggested angle for the outreach, grounded in the signal; handed to
            the outreach or proposal step
effort      where the provider's limited outreach is best spent; ten well-qualified
            prospects beat a hundred names
```

## 5. Prohibitions

- Never invent a prospect organisation, a contact name, an email, or a phone number.
- Never report a prospect that cannot be traced to a live source.
- Never build a client profile that fits everyone; it must follow the real offering.
- Never include an organisation with no signal of need at the same priority as one
  with a current signal.
- Never present an unreachable prospect as a strong lead.
- Never contact a prospect on the provider's behalf without explicit confirmation.
- Never fabricate a signal of need; report the real one or mark its absence.

## 6. Protocol

1. Define the ideal client profile from the provider's real offering, with the
   signal of need and the exclusions.
2. Search live sources for real organisations that fit and show the signal.
3. Qualify each on fit, reachability, and timing, with the evidence.
4. Prioritise by fit times reachability times timing.
5. Report the shortlist with the fit evidence, a real contact or channel, and the
   approach angle.
6. Guide where the outreach effort is best spent.
7. Where a source cannot be reached, hand over the search rather than inventing.

## 7. Auto-critique

Score from 0 to 5: ideal profile follows the real offering, every prospect from a
live source with a real signal, qualified on fit and reachability and timing with
evidence, contacts real not fabricated, shortlist prioritised, effort guidance
given, nothing invented.

Threshold: no axis below 3, average at least 4. A single invented organisation,
contact, or signal is an automatic zero regardless of the average, per
opportunity-core.

## 8. Interfaces

- Upstream: `opportunity-core` for the grounding rule.
- Downstream: `lead-research` deepens a qualified prospect into an approach,
  `market-research` sizes the field the prospects come from, `cover-letter` and
  the outreach message adapt to the prospect.
- Lateral: `source-research` and `source-verification` in `research/` for the
  gathering and checking; `company-research` in `career/` shares the sourced-facts
  discipline.

## 9. Live sources and connectors

This skill reads whatever business and professional sources the runtime exposes: a
directory, a professional-network connector, news and search, a freelance-platform
connector. It reads and prepares; it does not send outreach on the provider's
behalf without explicit confirmation. When a source cannot be reached, it names
the directories and searches the provider should run themselves, rather than
inventing organisations, because the provider will spend real outreach on what it
reports.

## 10. Note on the signal of need

The difference between a name and a prospect is the signal: an observable reason
to believe this organisation needs the offering now. A list of organisations that
merely fit the profile, with no signal, is a directory, not a prospect list, and
it converts at the base rate. The signal (a recent raise for a service that scales
with growth, a hiring spree for a tool that helps teams, a public problem the
offering solves) is what makes outreach timely and welcome rather than cold and
generic. Discovery without the signal is half done.
