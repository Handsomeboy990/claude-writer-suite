# Example: two briefs, two very different plans

## Brief A

> We need an internal tool so the support team can look up a customer by email
> and see their last ten orders. Read only. Around fifty users. It can live
> behind the existing VPN.

### Ownership

A project, not a task: it needs a stack decision and a deployment target, both
of which the user must accept. Delivery orchestrator owns it.

### Sizing

Small. One surface, one existing database, no new integration, no write path.
Phases 1 to 6 fit on one page.

### The phases, sized

```
01 requirements    six lines: one role, one workflow, read only, VPN, 50 users
02 clarification   two blocking questions, batched
03 technology      inherited stack, decision recorded as inherited
04 architecture    one page: one read endpoint, one page, existing database
05 validation      the one page proposal, approved in a minute
06 planning        four tasks
07 implementation  two days
08 integration     one journey, one failure path
09 devops          n/a for infrastructure, the existing pipeline covers it
10 deployment      the existing internal deploy path
11 production      the page loads behind the VPN and returns real orders
12 documentation   a section in the internal handbook
13 handover        n/a, the team owns it already
14 release         internal, notes only
```

Nine phases with real content, three sized to a paragraph, two marked `n/a`
with a reason. The validation gate still happened, because the answer to
question 2 changed the design.

### The two questions that were worth asking

```
1 Does read only include the order contents, or only the order headers?
  The two differ by a join and by what support staff can see about a
  customer's purchases.
2 Is the lookup by exact email, or partial match? Partial match on a table of
  this size needs an index strategy and a rate limit, exact match needs
  neither.
```

Both are blocking: they change the schema access and the endpoint contract.
Nothing else was asked. The colour of the table header was not asked.

## Brief B

> We want a marketplace where independent sellers list products, buyers order
> and pay, sellers get paid out weekly minus a commission, with reviews and
> a dispute process. Launch in three months.

### Ownership

A project. Payments, payouts and disputes each carry an irreversible failure
mode.

### Sizing

Large. Multiple surfaces, money movement, external providers, a schema that
will not be cheaply changed later.

### Phases, sized

```
01 requirements    a document: 4 roles, 11 workflows, 3 money paths
02 clarification   nine blocking questions in one batch, listed below
03 technology      payments provider, hosting, database, queue, each with
                   alternatives and a rejection reason
04 architecture    a document per area: system, application, database, API,
                   frontend, security, devops
05 validation      the proposal, approved before any code
06 planning        six milestones, 84 atomic tasks, dependency ordered
07 implementation  the bulk
08 integration     every money path exercised end to end, including refunds
09 devops          environments, secrets, pipeline, containers
10 deployment      staging first, production behind an approval
11 production      real payment in test mode, real payout in test mode
12 documentation   operations runbook included, disputes included
13 handover        the client operates this, so the handover is a deliverable
14 release         go or no go with named blockers
```

### The clarification batch that saved the project

Nine questions, one message, grouped by area:

```
Money
  1 Who is the merchant of record, the platform or the seller? This decides
    the payment provider model, the tax position and the refund path. It is
    not a preference, it is the foundation of the payment architecture.
  2 When is a seller paid: at order, at delivery, or after the dispute window?
  3 What happens to the commission when an order is refunded after payout?

Disputes
  4 Who decides a dispute, and within what window?
  5 Can a buyer dispute after the payout has been sent?

Roles
  6 Can one account be both buyer and seller?
  7 Who can suspend a seller, and what happens to their open orders?

Data
  8 What happens to reviews when a seller is removed?
  9 Which country's rules apply to seller onboarding checks?
```

Question 1 is the one that matters. Answered wrong, or assumed, the payment
architecture is rebuilt in month two. Answered before phase 3, it costs a
sentence.

Everything else was recorded as an assumption and did not block: currency
list, review length limit, whether sellers can edit a listing after an order.

### Parallelisation, once the contracts existed

```
Safe, after phase 4
  seller onboarding UI  +  seller onboarding API      contract fixed
  review module         +  dispute module             no shared file
  documentation of the settled payment flow  +  frontend work elsewhere

Unsafe, refused
  checkout UI before the payment provider was chosen
  payout job before the money model question was answered
  security audit of the payment path while it was still being written
```

### Change control fired once

In week five, implementing payouts revealed that the chosen provider does not
support the payout schedule the requirements describe for one country.

```
Stopped        the payout module only
Discovery      provider supports weekly payouts in 14 of the 17 target
               countries, stated in its documentation, verified against the
               API sandbox
Proposal       either restrict launch to the 14 supported countries, or add a
               second payout rail for the remaining 3
Consequence    option A costs nothing now and a migration later; option B
               costs two weeks and a second reconciliation path
Asked          yes, significant, it changes scope and cost
Decision       option A, with the 3 countries recorded as a follow up
Updated        docs/architecture/payments.md, and the scope document
Resumed        payout module, same day
```

Ten lines. The alternative, silently shipping a payout module that fails for
three countries, would have been discovered by a seller who was not paid.

## What the two briefs share

Both passed the validation gate. Both produced a proposal the user read before
code existed. The small one took four minutes to write and one to approve.

Sizing is the adjustment. Skipping is not.
