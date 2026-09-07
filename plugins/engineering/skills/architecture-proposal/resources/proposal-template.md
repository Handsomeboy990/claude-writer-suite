# Architecture proposal template

Sized per `SKILL.md` section 1. Sections that do not apply are kept with a
reason, never deleted.

````markdown
# Architecture: <project>

Revision: <date>
Specification: <link or path>
Status: proposed | approved | superseded

## 1. Executive summary

<one paragraph, readable by a non engineer>

Stack: <one line>
Shaping decisions:
1. <the decision that constrains everything else, and why>
2. <the second one, if there is one>

## 2. Requirements mapping

| Requirement | Component | Notes |
|---|---|---|
| R1 | | |
| R2 | | |

Uncovered requirements: <none, or listed with the reason>
Components serving no requirement: <none, or justified>

## 3. System architecture

| Piece | Choice | Why | If it fails |
|---|---|---|---|
| Frontend | | | |
| Backend | | | |
| Database | | | |
| Authentication | | | |
| File storage | | | |
| External services | | | |
| Queue and workers | none | no asynchronous need in the requirements | |
| Caching | none | no measured need yet; trigger recorded in the risk register | |
| Infrastructure | | | |
| Monitoring | | | |

## 4. Application architecture

```
<ascii diagram, modules and dependency direction, one diagram only>
```

| Module | Owns behaviour | Owns data | May be called by |
|---|---|---|---|

Dependency direction: <one sentence>
Known violations: <none, or named>

## 5. Database architecture

Engine: <and why>

Entities:
| Entity | Purpose | Owner module |
|---|---|---|

Relationships: <listed, with cardinality>

Indexes planned:
| Table | Columns | Serving which query |
|---|---|---|

Constraints that enforce invariants: <listed>
Transaction boundaries: <where, and what must be atomic>

Data lifecycle:
| Data | Created | Updated | Deleted | Retained |
|---|---|---|---|---|

Migration strategy: <expand and contract, ordering, reversibility>

## 6. API architecture

Style: <and why>
Authentication: <mechanism>
Authorization rule: <how the system decides, stated once as a rule>

| Operation | Method and path | Auth | Notes |
|---|---|---|---|

Error contract: <the single shape, and the status code table>
Pagination: <shape, default, maximum>
Filtering and sorting: <what is allowed, and how it is validated>
Idempotency: <which operations, keyed how>

## 7. Frontend architecture

Routing: <mechanism, route list or shape>
Components: <organisation, design system>
State placement: <policy, per frontend-engineering section 3>
Data fetching: <mechanism, caching, invalidation>
Forms and validation: <library, where server rules are mirrored>
The five states: <how loading, empty, partial, error, success are handled>
Responsive: <breakpoints, and what changes at each>
Accessibility target: <level, and how it is measured>

## 8. Security architecture

Threat model:
- Who would attack this:
- For what:
- What stops them:

| Control | Decision |
|---|---|
| Authentication | |
| Session or token lifetime | |
| Authorization enforcement point | |
| Input validation strategy | |
| Rate limiting | |
| Secret handling | |
| Security headers | |
| Data protection | |
| Personal data handling | |

## 9. DevOps architecture

| Concern | Decision |
|---|---|
| Environments | |
| Local development | |
| CI | |
| CD | |
| Deployment mechanism | |
| Secret delivery | |
| Migration execution | |
| Backups | |
| Monitoring and logging | |
| Rollback | |

Rollback does not restore: <sent mail, moved money, dropped columns, ...>

## 10. Risks

| Risk | Likelihood | Impact | Mitigation | Trigger to revisit |
|---|---|---|---|---|

## 11. Assumptions still in force

| # | Assumption | If wrong | Cost to change |
|---|---|---|---|

## 12. Out of scope

- <restated from the specification, so approval covers it>
````

## Rules for filling it

**Section 2 first.** Writing the mapping before the prose exposes gaps while
they are still cheap. A proposal written in order tends to describe a system
and only later discover it misses a requirement.

**Section 3, absent pieces stay.** `Queue and workers: none, no asynchronous
need in the requirements` is a decision the reader can challenge. Deleting the
row hides it.

**Section 5, the lifecycle table is mandatory** for any project storing
personal data or anything a user can delete. It is the field that turns into a
migration and a legal question six months later.

**Section 6, one authorization rule.** If the rule cannot be stated in one
sentence, the model is not designed yet.

**Section 9, the rollback line.** Naming what a rollback does not restore is
what turns a deployment plan into an honest one.

**Section 11, assumptions restated.** The reader approving this document is
approving these assumptions. Burying them in an earlier file means they were
never approved.
