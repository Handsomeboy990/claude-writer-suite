# Example: sorting a list of complaints into a register

What the team produced in a thirty minute session, before any filtering:

```
1  the codebase uses callbacks in the notification module
2  tests are slow, 14 minutes
3  the ORM is old
4  authorization is copy pasted in every handler
5  there are two date formats in the database
6  the frontend has three ways to fetch data
7  the invoice module has no tests
8  we use snake_case in the database and camelCase in the API
9  the admin panel is ugly
10 the framework is two majors behind and loses support in March 2027
```

## Filtering by interest

```
1  callbacks in one module
   Interest?  Nobody has changed that module in 18 months. No defects.
   Verdict    preference. Not recorded.

2  14 minute test suite
   Interest   measured: 6 engineers, roughly 4 runs a day each. Also, three
              people admitted they push without running it.
   Verdict    debt. Interest is real and daily.

3  the ORM is old
   Interest?  it works, it is supported, no defect traced to it
   Verdict    preference, until support ends. Then it becomes item 10's kind.

4  authorization copy pasted
   Interest   2 High security findings in 12 months, both an omitted check.
              20 minutes per new endpoint.
   Verdict    debt, and the highest ranked.

5  two date formats
   Interest   one defect, six months ago, in a report. One hour of confusion
              per new developer.
   Verdict    debt, medium, rarely touched.

6  three data fetching approaches
   Interest   new frontend work costs a decision every time, and reviews argue
              about it. No defects.
   Verdict    debt, low interest, but touched often. Payable opportunistically
              by choosing one and migrating on contact.

7  invoice module has no tests
   Interest   every change is manual verification, roughly a day. Two defects
              reached customers in the last year.
   Verdict    debt, high.

8  snake_case and camelCase across the boundary
   Interest   the mapping is automatic and has never produced a defect.
   Verdict    preference. Not recorded.

9  the admin panel is ugly
   Interest   none stated. Support staff have not complained.
   Verdict    not debt. If it slows support work, that is a product item with
              a measurement, not a debt entry.

10 framework loses support 2027-03
   Interest   zero today, catastrophic after the date: no security patches.
   Verdict    debt with a trigger date, ranked by the calendar rather than by
              current interest.
```

Ten complaints became six register entries. The three preferences did not
disappear from the conversation; they simply stopped competing for the same
budget as a security exposure.

## The ranking that resulted

```
1  DEBT-04  authorization duplicated       high interest, often touched
2  DEBT-07  invoice module untested        high interest, often touched
3  DEBT-10  framework support ends 2027-03 calendar driven, plan it now
4  DEBT-02  14 minute test suite           daily interest, whole team
5  DEBT-05  two date formats               medium, rarely touched
6  DEBT-06  three fetching approaches      low, pay on contact
```

## What happened next

Items 1 and 2 were paid inside the next two features that touched those areas,
in separate commits, each with a before and after interest line. Item 3 became
a planned migration with a date, using `migration-engineering`. Item 4 was cut
from 14 minutes to 5 by moving 40 browser tests to the component layer, which
was measured rather than assumed. Items 5 and 6 stayed in the register.

Nobody ran a cleanup sprint, and four of the six items were closed in a
quarter.
