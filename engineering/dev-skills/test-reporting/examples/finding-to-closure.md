# Example: one finding, from discovery to closure

## As first recorded, during the session

```
BUG-14  Export produces two files
Found   exploratory session, back roads tour, 00:26
Note    clicked Export twice by accident, two mails arrived
Status  open, not yet reproduced
```

That is all that was known at that moment, and writing it immediately is what
made the rest possible. A finding remembered at the end of the day loses its
steps.

## After reproduction

```
BUG-14  Duplicate export job on repeated submission
Severity     High
Category     functional, data
Confidence   Confirmed
Location     POST /api/v1/exports, and the Export button on /reports
Environment  staging, 4c17ab9, role admin, Chrome 141, 1440x900
Steps        1. sign in as admin
             2. open /reports
             3. click Export twice within one second
Expected     one export job, one file, one notification mail. The endpoint has
             no idempotency key, but the interface should not permit a second
             submission and the server should collapse duplicates.
Actual       two jobs, two files with different names, two mails. The second
             file overwrote the first in the download list.
Frequency    3 of 3 at normal speed, 5 of 5 on a throttled connection, because
             the button re-enables before the response arrives
Impact       the customer receives two mails and cannot tell which file is
             current. On a large account both jobs run, doubling the query
             cost of the report.
Evidence     evidence/findings/BUG-14-two-mails.png
             evidence/findings/BUG-14-network.txt (two POST, both 202)
Scope        the same button pattern is used on /invoices and /members, both
             confirmed to have the same behaviour
Status       open
```

Severity High rather than Critical: no data is lost and no boundary is
crossed, but the customer cannot tell which file is current and a large
account pays twice for the work.

## Fix and retest

```
Fix applied
  server: idempotency key derived from account, report type and range;
          a duplicate within the window returns the original job id
  client: the button is disabled while the request is in flight, with a
          pending state, which is the visible half of the defect

Test written first
  api: two concurrent identical requests, exactly one job created,
       second response returns the first job id
       observed red before the fix, green after
  browser: double click on Export, one row in the job list
       observed red before the fix, green after

Retest by hand
  the original reproduction, run again on 7d3f10a: one job, one file, one
  mail. Throttled connection: same. 3 of 3.

Regression
  impact set: exports, invoices, members, since they share the button and the
  submission helper. Critical set: sign in, create, pay, export.
  Result: 344 passed, 0 failed. Baseline was 341 passed, 3 failed, and the
  three failures were BUG-14 and its two siblings.
```

## As it appears in the report

```
BUG-14  Duplicate export job on repeated submission     High     fixed
        Fixed in 7d3f10a. Retested by hand and covered by two automated
        tests. The same pattern was corrected on /invoices and /members.
```

The finding stays in the report after being fixed, with the proof. A report
that only lists open defects tells the reader nothing about what the campaign
actually changed.

## What was not done, and is stated

The export job itself is still not idempotent at the worker level: a queue
redelivery would still produce a second file. That is a separate finding,
REL-04, raised by `reliability-testing`, and it is open with its own record.
It is named here rather than folded into BUG-14, because the causes and the
fixes are different.
