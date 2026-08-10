# Example: a change request that took fifteen lines

Week three of the marketplace build. Task T44, the payout job.

## The discovery

The approved architecture, section 3, says payouts go through the chosen
payment provider on a weekly schedule, for all seventeen target countries.

Implementing T44 against the provider sandbox produced a rejection for three
of them.

## What was not done

Three tempting responses, all forms of drift:

```
1  Work around it with a manual export for those three countries, and mention
   it in the handover. The architecture document would still claim automatic
   weekly payouts everywhere.

2  Add a second provider for the three countries. A technology decision, made
   during implementation, that changes the cost note and the operational
   burden, decided by whoever happened to be writing the payout job.

3  Quietly restrict to fourteen countries and move on. The client believes
   they are launching in seventeen.
```

Each is a defensible engineering decision and none of them is the engineer's
to make alone.

## The change request, as sent

```
Discovery
  Assumed:  the provider supports weekly payouts in all 17 target countries
            (architecture section 3, payouts)
  Actual:   14 supported. CH, NO and IS require a local entity or a partner
            arrangement the provider does not offer for our account type.
  Found:    sandbox rejection on payout creation, error account_country_
            unsupported; confirmed against the provider's country matrix, and
            with their support, ticket 88214.

Impact
  Blocks:   T44 payout job, T45 payout reconciliation
  Affects:  seller onboarding, which currently accepts sellers from all 17

Options
  A  Launch in the 14 supported countries. Onboarding rejects the other 3 with
     a waiting list.
     Cost: two days, mostly onboarding and copy.
     Consequence: three markets delayed. Adding them later needs a second
     payout rail, roughly two weeks at that point.

  B  Add a second payout rail now for the 3 countries.
     Cost: two weeks, plus a second reconciliation path to operate forever.
     Consequence: launch moves by two weeks. Ongoing operational burden for
     three markets that may be a small share of volume.

Recommendation
  A. The three countries are 4 percent of your stated target market and the
  reversal cost is bounded and known.

Decision needed by
  Thursday. Seller onboarding, T39, is blocked behind this and it is on the
  critical path.
```

Fifteen lines. The client answered in one sentence the same day.

## What happened after the answer

```
Decision   option A, recorded with the client's words
Updated    docs/architecture/payments.md section 3: supported countries list,
           with the reason and the reversal cost
Updated    docs/architecture/architecture.md, requirements mapping: R9 now
           maps to "14 countries at launch", with a note
Updated    the scope document: the three countries moved to out of scope,
           with the trigger for revisiting
Registered FU21, second payout rail for CH, NO, IS, effort two weeks,
           recommended when those markets are commercially justified
Resumed    T44, same day
Continued  everything not behind the payout decision never stopped
```

Step 2 and 3 are the ones that would have been skipped under time pressure.
Without them, the architecture document claims seventeen countries and the
system supports fourteen, and the discrepancy is found by whoever inherits
the project.

## The same week, three discoveries that were not changes

```
FU18  the seller dashboard query has no index on seller_id
      Class: follow up. Measured 8ms at current seed volume. Registered,
      recommended before 100k orders. Not implemented.

Urgent  GET /api/sellers/:id/orders returned orders for any seller id
      Class: urgent, object level authorization. Fixed the same hour, in its
      own commit, reported in the daily note. Not registered as a follow up,
      because it was fixed.

Client  "could sellers also upload a shop banner?"
      Class: client scope growth. Priced at half a day, offered as: add it and
      the milestone moves half a day, swap it for the shop description field
      of similar size, or register it. Client chose to add it and accept the
      half day. Recorded.
```

Three discoveries, three different handling paths, none of them absorbed
silently.

## What the discipline cost

The change request took twenty minutes to write. The document updates took
another twenty. The follow up register entries take under a minute each.

What it bought: an architecture document that still describes the system, a
client who made the country decision themselves, and a handover where the
second payout rail is a known, costed, deliberately deferred piece of work
rather than a surprise.
