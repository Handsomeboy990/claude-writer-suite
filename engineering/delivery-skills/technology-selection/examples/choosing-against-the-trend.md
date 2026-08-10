# Example: the stack that was not chosen

Project: the training platform. 400 trainees, 30 trainers, one organisation,
French only, delivered before September, maintained afterwards by a two person
internal team who know PHP and some JavaScript.

That last clause is a requirement, not a footnote.

## The stack that gets proposed by reflex

```
Next.js + tRPC + Prisma + PostgreSQL + Redis + S3 + Kubernetes
+ a queue for certificate generation + Elasticsearch for course search
+ a separate admin dashboard + Terraform
```

Every piece is defensible in isolation. Together they are a system that the
two person team cannot operate, for a load of 400 users.

## Decision 1, asked honestly

```
D0  Is a new project required?

Considered:  an existing learning platform, self hosted.
Rejected:    the attestation requirement (R4) needs the client's template and
             their numbering scheme, and the completion tracking (R5) needs to
             match their internal reporting. Both are configuration in some
             products and code in others; the evaluation showed two weeks of
             adaptation against six weeks of building, but the client also
             requires ownership of the code as a constraint (C4).
Decision:    build, driven by C4 rather than by the effort comparison.
```

Asking the question cost an afternoon and produced a decision that is now
defensible instead of assumed.

## Decision 4, where the reflex stack fails

```
D4  Application framework

Decision:     the framework the maintaining team already uses
Requirement:  C5, a two person internal team maintains this after delivery,
              with PHP and JavaScript experience
Why:          the operational and maintenance criteria dominate here. A
              codebase the maintaining team cannot change is a delivered
              project that dies at the first bug report.

Alternatives:

  Next.js     genuinely a good fit for the product shape, and the team can
              read JavaScript. Rejected: the team has no React experience and
              no server component experience, and the client has no budget for
              training. The product would be better and unmaintainable, which
              is worse.

  A PHP       chosen. Mature, the team knows it, the hosting the client
  framework   already runs supports it, and every requirement in the
              specification is ordinary work in it.

  Plain PHP   rejected. No routing, no migrations, no CSRF handling out of the
              box, which means writing security infrastructure by hand for a
              system holding personal data.

Trade-off:    the frontend will be server rendered with light interactivity
              rather than a rich client application. Course following (U1,
              answered as reading pages) does not need more. If the client
              later wants a video player with progress tracking, this decision
              is revisited.
Cost:         none beyond hosting.
Reversal:     expensive but bounded, and the trigger is written down.
```

## What the defaults table removed

```
Redis           removed. No measured cache need, 400 users, one process.
                Trigger recorded: revisit if a page exceeds the 2s budget.
Queue           removed. Certificate generation takes under a second and
                happens at most 400 times per course. It runs in the request.
                Trigger: if generation exceeds 3 seconds or batch issuance
                appears in the requirements.
Elasticsearch   removed. Course search is 30 rows. Database search is not
                merely sufficient, it is better, because it cannot go stale.
Kubernetes      removed. One artefact, one process, an existing server.
Terraform       removed. Infrastructure is one server the client already runs.
Separate admin  removed. Administration is three read only screens behind a
                role check, not an application.
Object storage  kept. Course materials are files and the requirement is real.
```

Seven pieces removed, one kept. Each removal carries a trigger, so the
decision can be revisited on evidence rather than relitigated on preference.

## The cost note that changed a decision

```
| Item | Monthly | Notes |
|---|---|---|
| Existing server | 0 EUR | the client already runs it |
| Object storage | 4 EUR | course materials, 50 GB |
| Mail | 0 EUR | under the free tier at this volume |
| Total | 4 EUR | |

Compared with the reflex stack: roughly 180 EUR per month for managed
Kubernetes, managed Redis, managed Elasticsearch and a second hosting
environment, for a system serving 400 users.
```

The client read this table and asked one useful question: what would it cost
if enrolment reached 5,000. The answer, driven by storage and mail, was around
30 EUR, and it settled the scalability discussion with a number rather than an
adjective.

## The record of what was not evaluated

```
D2  Persistence

Decision:     PostgreSQL
Source:       partly inherited. The client's server runs PostgreSQL for
              another application and their backup process already covers it.
Consequence:  MySQL and SQLite were not evaluated on the merits. The existing
              backup and monitoring coverage outweighed a comparison that
              would not have changed the outcome for this workload.
Risk:         none identified.
```

Honest, four lines, and it stops a future reader from believing an evaluation
happened that did not.

## The rule this illustrates

The maintaining team is a project requirement with the same standing as a
performance target. A stack that the people who inherit it cannot operate has
failed a requirement, regardless of how good the architecture diagram looks.
