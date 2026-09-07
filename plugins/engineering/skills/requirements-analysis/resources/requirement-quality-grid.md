# Requirement quality grid

A requirement is usable when a test can be written from it without asking a
further question. Apply the grid to every extracted requirement.

## Six tests

| Test | Question | Fails when |
|---|---|---|
| Testable | can I write a passing and a failing case | no observable outcome |
| Bounded | does it say how much, how many, how long | an adjective stands in for a number |
| Attributed | which role does this | the word `user` covers three roles |
| Complete | what happens when it fails | only the happy path is described |
| Consistent | does it contradict another requirement | two rules cannot both hold |
| Owned | who decides if it changes | nobody named |

## Rewrite table

| Source says | Problem | Rewritten as |
|---|---|---|
| the system must be fast | unbounded | search returns in under 500ms at 100k rows, 95th percentile |
| the interface must be intuitive | untestable | a first time user completes onboarding unaided, verified on five people |
| it should be secure | unbounded, unattributed | only the order owner and an administrator may read an order |
| users can manage their profile | unattributed, incomplete | a signed in user can view, edit and delete their own profile; an administrator can view any profile and cannot edit it |
| the app must handle load | unbounded | 500 concurrent sessions, 2M rows in `orders`, no request above 2s |
| notify the user | incomplete | on order dispatch, send one email to the buyer within five minutes; a send failure is retried twice then logged, and never blocks dispatch |
| sellers get paid weekly | incomplete | see the payout requirement, which needs the base, the window, the minimum and the failure path |
| admins can moderate content | unattributed, unbounded | a moderator can hide a review; the author sees it as hidden with the reason; hiding is reversible for 30 days |
| the data must be backed up | untestable | daily backup, 30 day retention, restore verified quarterly, RPO 24h, RTO 4h |
| support multiple languages | unbounded | French and English at launch, content translated by the client, dates and currency formatted per locale |

## The adjective list

These words in a requirement mean a number is missing:

fast, slow, quick, responsive, scalable, robust, reliable, secure, intuitive,
simple, clean, modern, seamless, flexible, lightweight, heavy, large, small,
soon, regularly, frequently, occasionally, most, several, many, a few.

Each occurrence is either replaced with a number, or converted into a
clarification question, or recorded as an assumption with the number the work
will use.

```
Source:     "the dashboard should load quickly"
Assumption: A7, quickly means under 2 seconds to interactive on the reference
            network profile, since no target was given. If the client means
            under 500ms, the data access design changes.
```

That is a usable outcome from an unusable sentence. Deleting the sentence, or
silently deciding it means whatever the implementation happens to achieve, is
not.

## The role test

Read every requirement and ask: which of the named roles does this apply to?

A specification whose requirements all say `the user` has one of two problems:
there is genuinely one role, which is worth stating explicitly, or the
authorization model has not been thought about, which is worth discovering
now rather than during the security audit.

## Consistency sweep

After extraction, read the requirement set as a whole and look for pairs that
cannot both be true.

Common contradictions:

```
"anyone with the link can view"        versus  "only invited members can view"
"orders are immutable once placed"     versus  "buyers can change the address"
"payouts are weekly"                   versus  "disputes are open for 30 days"
"deleted accounts are removed"         versus  "orders keep the buyer name"
"the client hosts it"                  versus  "we manage the deployments"
```

Each pair goes to `clarification-gate` as one question, not two.
