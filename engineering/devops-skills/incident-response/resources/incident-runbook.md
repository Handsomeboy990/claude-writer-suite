# Incident runbook

## First five minutes

```
1  declare, in the agreed channel, with a severity guess
2  name the lead. If nobody is named, the person who declared is the lead
   until relieved
3  send the first update, and state the next update time
4  open the timeline document and start recording with timestamps
5  ask the one question that resolves most incidents:
      what changed in the last hour
```

## What changed, in order of likelihood

```
a deployment, ours
a configuration or feature flag change
a migration, or a long running data job
a scheduled job that runs at this time
a third party provider's status
a certificate or a key that expired
a quota, a limit or a plan boundary reached
traffic: a campaign, a crawler, a customer's batch job
infrastructure maintenance by the platform
time itself: a month boundary, a daylight change, a leap day
```

## Mitigation menu

Ordered by speed, not by elegance.

```
roll back the last deployment
disable the feature flag
revert the configuration change
stop the job that is writing
scale up or add capacity
fail over to another region or replica
shed non essential traffic
restrict to read only
maintenance page
```

Each of these is a decision the lead announces before the operator performs
it, and the scribe records with a timestamp.

## Update template

```
[14:05] INVESTIGATING. Checkout is failing for some customers since 13:52.
We are rolling back the 13:48 deployment. Next update 14:20.

[14:20] MITIGATING. The rollback is complete and error rates are falling.
Some checkouts between 13:52 and 14:12 failed and were not charged.
Next update 14:40.

[14:40] MONITORING. Error rates are normal. We are verifying the affected
orders. No further customer action is needed. Next update 15:10 or when
resolved.

[15:05] RESOLVED. Checkout has been normal since 14:18. 214 checkouts failed
during the incident, none were charged, and the affected customers have been
mailed. A postmortem will follow this week.
```

Four updates, no speculation, no cause named until it is established.

## Timeline entries

```
13:48  deployment 4c17ab9 released
13:52  first payment error, visible in the dashboard afterwards
14:01  first customer report
14:04  alert fired: payment error rate above threshold
14:05  declared, severity 2, lead named
14:09  hypothesis: the deployment. Not verified, but the correlation is
       strong enough to act on
14:12  rollback started
14:18  error rate normal
14:33  cause confirmed: the new client sends the amount as a decimal string
       and the handler rejected it
15:05  resolved and verified
```

Recording what people believed and when, including the wrong beliefs, is what
makes the timeline useful later.

## Postmortem structure

```
Summary            three sentences, plain language
Impact             214 failed checkouts, 26 minutes, no incorrect charges
Detection          alert at 14:04, 12 minutes after the first error. Customer
                   reported first, which is the detection finding.
Timeline           as above
What went well     rollback took 6 minutes and was rehearsed
                   communication was on rhythm and accurate
Contributing       1 the handler validated the amount format strictly and the
  factors            client changed its serialisation
                   2 no contract test covered the client and server together
                   3 the deployment went to 100 percent immediately
                   4 the alert threshold needed 12 minutes of errors to fire
Lessons            a change on either side of a contract can break it, and
                   nothing in the pipeline exercised both sides
Actions            1 contract test between client and handler   owner, date
                   2 canary deployment for the payment service  owner, date
                   3 alert on the payment error ratio, faster    owner, date
                   4 the client's serialisation change gets a
                     record, since it was deliberate and nobody
                     told the server team                        owner, date
```

Four contributing factors, four actions, and none of them is a person's name.
Factor 3 and factor 4 are the ones that turn one incident into a class of
incidents prevented.

## Closing checklist

```
service verified against production, not only on a dashboard
queues and backlogs drained
data written during the incident verified or scheduled for correction
affected customers handled
temporary mitigations listed, each with an owner and a removal date
severity confirmed for the record
postmortem scheduled within days
```
