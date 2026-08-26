---
name: company-research
description: Researches a prospective employer before a candidate applies or interviews: what the company actually does and how it makes money, its size, stage, and health from real signals, its culture and reputation from balanced sources, the team and the role's real context, and the red flags a candidate should weigh. Every fact is sourced live, never invented. Use before applying to a shortlisted company, before an interview, and before accepting an offer.
license: MIT
metadata:
  category: career
  version: 1.0.0
  depends_on: [career-core]
  outputs: [company-profile, health-signals, culture-assessment, interview-intelligence]
---

# Company Research

A candidate applies to and joins a company, not a job posting. Company research
tells them what they are actually walking into: what the company does, whether it
is healthy, what it is like to work there, and what to ask. Every fact is from a
live source, because a candidate makes a real decision on it, and an invented
fact about an employer is worse than none.

## 1. What the company actually does, and how it earns

```
product      what the company makes or does, in plain terms, from its own site
             and product, not its marketing tagline
model        how it actually makes money: who pays, for what; a company whose
             revenue model is unclear is itself a signal
market       who its customers and competitors are, from real sources
stage        startup, scale-up, or established; each is a different bet for the
             candidate, with different risks and rewards
```

## 2. Health signals from real evidence

```
funding      for a startup: the last raise, when, how much, from whom, from real
             announcements; a long-ago raise with heavy hiring is a runway question
growth       hiring trends, product launches, customer announcements, from live
             sources; expansion and contraction both show
stability    layoffs, leadership churn, public trouble, from reporting; named if
             found, not speculated if not
caveat       these are signals, not verdicts; a candidate weighs them, and the
             research presents them with their source and their date, not as a
             prediction
```

## 3. Culture and reputation, from balanced sources

```
sources      employee reviews, the company's own statements, reporting, and where
             possible people the candidate can actually talk to; each weighed by
             its bias
balance      review sites skew to the aggrieved and the coached-positive; read the
             pattern across many, not one dramatic entry
specific     "several reviews mention long hours during releases" is useful;
             "the culture is bad" is not, and neither is repeating one anonymous rant
signal       consistent themes across independent sources carry weight; a single
             unverifiable claim is a question to ask, not a fact to report
```

## 4. The role's real context

```
team         where the role sits, who it reports to, the team's size and remit,
             from the listing and any reachable source
why open     is it growth (new headcount) or backfill (someone left), and what
             that suggests; a role open for many months is a question
stack        the technologies and tools the role really uses, for the technical
             interview prep
challenge    the real problem the role exists to solve, which the cover letter and
             interview both use
```

## 5. Red flags a candidate should weigh

```
name         the signals worth a candidate's attention: unclear revenue with a
             long-past raise, high leadership churn, a role reposted repeatedly,
             a review pattern of the same specific complaint, a hiring process
             that itself behaves badly
frame        as a weighted concern with its source, not a verdict; the candidate
             decides, and some flags are acceptable for the right role
verify       distinguish a sourced pattern from a single anonymous claim; report
             the first as a concern and the second as a question to raise
```

## 6. Prohibitions

- Never invent a fact about a company: a funding round, a revenue figure, a
  headcount, a customer, a piece of news.
- Never report an unsourced rumour as a fact; mark it as a question to verify.
- Never repeat a single dramatic review as the company's culture; read the pattern.
- Never present a signal as a prediction; a candidate weighs signals, they are not
  verdicts.
- Never let the candidate's hope for the role suppress a real red flag.
- Never speculate about trouble not found; absence of a signal is stated as such.

## 7. Protocol

1. Establish what the company does and how it earns, from its own sources.
2. Gather health signals from real, dated evidence; present with source, not
   prediction.
3. Assess culture from balanced sources, reading patterns not single entries.
4. Establish the role's real context: team, reason open, stack, challenge.
5. Name the red flags as weighted, sourced concerns, distinguished from single
   rumours.
6. Produce the profile the candidate uses to decide, tailor, and prepare.
7. Where a live source cannot be reached, say so and name what the candidate
   should check themselves.

## 8. Auto-critique

Score from 0 to 5: what the company does and how it earns established from real
sources, health signals dated and sourced not predicted, culture read as a
pattern across balanced sources, role context real, red flags weighted and
sourced, single rumours kept distinct from patterns, nothing invented.

Threshold: no axis below 3, average at least 4. Any invented company fact, or a
single anonymous review reported as the culture, caps the score until fixed, per
career-core.

## 9. Interfaces

- Upstream: `career-core` for the source and honesty rules.
- Downstream: `cover-letter` uses the real reason and register, `interview-
  preparation` uses the role context and the candidate's questions, `job-search`
  uses the health assessment to rank a shortlist.
- Lateral: `source-research` and `source-verification` in `research/` for the
  gathering and checking discipline; `competitive-analysis` when comparing
  several prospective employers.

## 10. Live sources

Company research reads live sources: the company's own site and product, funding
and news databases, employee-review sites, and any connector the runtime exposes.
It presents each fact with its source and date. When a source cannot be reached,
it names the gap and tells the candidate exactly what to look up themselves,
rather than filling the company's profile with plausible invention, because the
candidate is about to make a real decision on it.
