---
name: technology-selection
description: Chooses the stack for a project with a written justification per decision: choice, reason, alternatives considered, why each was rejected, and the trade-off accepted. Refuses popularity as a reason and complexity without a requirement behind it. Run after clarification, before the architecture proposal.
license: MIT
metadata:
  category: delivery-skills
  version: 1.0.0
  depends_on: [engineering-core, requirements-analysis]
  outputs: [technology-decisions, rejected-alternatives, operational-cost-note]
---

# Technology Selection

Decides the stack, and writes down why, including what was rejected and what
the choice costs.

`dependency-selection` decides whether to add one library to an existing
project. This skill decides the foundations of a new one, where each choice
constrains everything above it and is expensive to reverse.

## 1. Order of decision

Decide in this order. Each decision narrows the next.

```
1  Is a new project even required, or does something existing do this
2  Runtime and language
3  Persistence
4  Application framework
5  Authentication approach
6  Hosting and deployment target
7  Everything else: UI system, testing, tooling, observability
```

Deciding the UI library before the persistence model is how projects acquire a
stack that nobody chose.

## 2. The decision record

Every major decision produces this, with nothing omitted:

```
Decision       what was chosen
Requirement    the requirement or constraint that drives it
Why            the reason, specific to this project
Alternatives   at least two, named
Rejected       why each one was rejected, honestly
Trade-off      what is worse because of this choice
Cost           licence, hosting, operational burden, recurring money
Reversal       what it costs to change this in six months
```

The `Rejected` lines are the test of the record. If every alternative was
rejected for being obviously bad, the alternatives were straw men and the
decision was made before it was evaluated.

The `Trade-off` line is mandatory. A choice with no downside was not analysed.

## 3. Criteria

Applied to each candidate, weighted by what the project actually needs.

| Criterion | Question |
|---|---|
| Fit | does it solve this project's problem, not a general one |
| Maturity | is it stable, and how long has it been |
| Maintenance | recent releases, responsive issues, more than one maintainer |
| Security | advisory history, response time, current known issues |
| Ecosystem | are the adjacent things the project needs available |
| Compatibility | does it work with the decisions already taken |
| Team | can whoever maintains this afterwards work with it |
| Operations | what does running it cost in attention, not only money |
| Performance | is it adequate at the stated volumes |
| Scalability | does it stop working at a volume this project will reach |
| Licence | compatible with how this is distributed |
| Exit | how hard is it to leave |

`Team` and `Operations` are the two that get skipped and the two that
determine whether the project survives handover.

## 4. Defaults, and when to leave them

The boring choice is the default. Leaving it requires a stated reason.

| Need | Default | Leave it when |
|---|---|---|
| relational data | a mainstream relational database | the data is genuinely not relational |
| session identity | server side sessions | a third party must verify tokens |
| file storage | object storage from the hosting provider | files are small and few |
| background work | a database backed queue | volume or latency demands a broker |
| search | database full text search | relevance ranking is a product feature |
| cache | none, until measured | a measurement exists |
| real time | polling | the product is collaborative or live |
| deployment | one artefact, one process | a stated reason to split |
| monorepo split | one repository | independent release cycles exist |

Each row is a place where projects acquire complexity that no requirement
justified. The default is not always right; it is always the thing to argue
against rather than around.

## 5. Refusals

Refused, with the reason stated once:

- a technology chosen because it is popular, new, or on a conference stage;
- a distributed architecture for a load that one process handles;
- a message broker with no asynchronous requirement;
- a cache before a measurement;
- a second database for a shape the first one handles;
- a framework the maintaining team has never used, without a stated reason
  that outweighs it;
- a technology whose licence conflicts with the project's distribution;
- an unmaintained project chosen out of familiarity;
- anything whose operational burden exceeds the team that will carry it.

## 6. Inherited stacks

When the stack is imposed by the client or by an existing system, the decision
is still recorded, as inherited:

```
Decision     PostgreSQL
Source       imposed, the client's operations team runs PostgreSQL only
Consequence  no evaluation performed, and none needed
Risk         if the project later needs a document store, the constraint is
             renegotiated rather than worked around with a JSON column
```

Recording an inherited decision costs four lines and prevents the next
engineer from assuming it was chosen freely.

## 7. Cost note

Every stack carries recurring cost. State it before approval, not after the
first invoice.

```
| Item | Monthly | Scales with | Free tier |
|---|---|---|---|
```

Include hosting, database, object storage, mail, error tracking, any managed
service, and any per seat tooling the project requires. A stack that is cheap
at zero users and expensive at a thousand is a decision the user should make
knowingly.

## 8. Protocol

1. Read the specification, the constraints and the surviving assumptions.
2. Ask question 1 of section 1 honestly.
3. Decide in the order of section 1.
4. For each decision, apply section 3 to at least two real candidates.
5. Write the record from section 2, including trade-off and reversal cost.
6. Check against the defaults table, section 4, and justify every departure.
7. Check against the refusals, section 5.
8. Produce the cost note, section 7.
9. Hand the decisions to `architecture-proposal`.

## 9. Auto-critique

Score from 0 to 5: decision order respected, real alternatives rather than
straw men, trade-off stated for every choice, reversal cost stated, departures
from the defaults justified, operational burden considered, cost note honest,
inherited decisions recorded as such.

Threshold: no axis below 3, average at least 4. A decision whose only stated
reason is popularity, familiarity or novelty is an automatic failure.

## 10. Interfaces

- Upstream: `requirements-analysis`, `clarification-gate`.
- Lateral: `dependency-selection` for individual libraries inside the chosen
  stack.
- Downstream: `architecture-proposal`, `validation-gate`, `devops-core`.
