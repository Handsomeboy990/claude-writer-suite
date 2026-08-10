# Approval package template

One screen for a small project, two for a large one. The architecture
document is linked, never pasted.

````markdown
## <project>, architecture for approval

**What this will be**
<one paragraph. What exists when this is done, in the reader's language.>

**Architecture**
<five to ten lines. The shape, not the detail.>

**Stack**
| Layer | Choice | Why, in half a line |
|---|---|---|

**Database**
<entities in one line. Then the one thing that is expensive to change later.>

**Backend**
<shape in two lines. The authorization rule in one sentence.>

**Frontend**
<shape in two lines. Accessibility target.>

**Infrastructure**
<where it runs, how code gets there, environments.>

**Testing**
<what is tested, at which layer, what is deliberately not.>

**Deployment**
<mechanism, and what a rollback does and does not restore.>

**Scope**
In: <list>
Out: <list, including what a reader would reasonably expect>

**Assumptions**
| # | Assumption | If wrong |
|---|---|---|

**Still open**
| # | Question | Blocks |
|---|---|---|

**Risks**
| Risk | Mitigation |
|---|---|

**Recurring cost**
<total per month, and what drives it as usage grows>

**Decision**
<the specific request, per SKILL.md section 3, naming the item that most
deserves attention>

Full architecture: <path>
````

## Worked example, small project

````markdown
## Support customer lookup, architecture for approval

**What this will be**
A page inside the existing internal app where a support agent enters a
customer email and sees that customer with their last ten orders. Read only.

**Architecture**
One route and one endpoint inside the existing Next.js application. Existing
database, existing session authentication, existing deployment. No new
service and no new infrastructure.

**Stack**
| Layer | Choice | Why |
|---|---|---|
| All of it | the existing application | same data, same auth, one page |

**Database**
No new entity. Two additions: a `support` role value, and a case insensitive
index on customer email. Both additive and reversible.

**Backend**
One GET endpoint. Authorization rule: the caller must hold `support` or
`admin`; there is no per customer scoping, because the role is defined as
access to any customer.

**Frontend**
One route in the existing authenticated layout. The searched email lives in
the URL so a lookup can be shared during an escalation. Accessibility: the
project's existing target, checked by the scan already in CI.

**Infrastructure**
Unchanged. Existing internal deployment, behind the VPN.

**Testing**
Integration tests on the endpoint including the two empty states and the
forbidden case. One browser journey. No load testing: fifty users.

**Deployment**
Existing pipeline. Migration runs before the code deploy. Rollback is revert
and redeploy, about six minutes; it does not remove audit rows written in the
meantime, which is intended.

**Scope**
In: lookup by exact email, last ten order headers, support role, audit trail.
Out: editing anything, support notes, export, search by name or phone.

**Assumptions**
| # | Assumption | If wrong |
|---|---|---|
| A1 | ten orders is enough | add pagination, cheap |
| A2 | order headers, not contents | a join and a permissions question |

**Still open**
None.

**Risks**
| Risk | Mitigation |
|---|---|
| the support role becomes broad customer data access | audit table, rate limit of 60 lookups per hour |

**Recurring cost**
Zero. No new service.

**Decision**
Approve and I build it in this order: migration, endpoint, page, tests. One
report at the end.

One thing deserves your attention: I have added an audit table that records
who looked up which customer. It is not in your brief. A tool that lets staff
read any customer's history without a trace is hard to explain during an
incident. It costs one table. Say if you would rather not have it.

Full architecture: docs/architecture/support-lookup.md
````

## Rules

**Length is the discipline.** A package that takes twenty minutes to read gets
approved without being read, which is worse than no gate.

**Out of scope is not optional.** It is the half of the scope that prevents an
argument at delivery.

**Assumptions are listed with consequences.** `If wrong` is what lets a
non technical reader spot the one that matters.

**Cost appears before approval.** Learning the monthly bill after the
architecture is built is not a decision the user got to make.

**The decision request names one thing.** Readers give one item real
attention. Choose which one, and it should be the item where their knowledge
beats the system's, not the item that was hardest to build.
