# Engagement boundary

Filled in and confirmed before the first request. Without a confirmed boundary
there is no security testing, only trespass.

```
ENGAGEMENT
  Application        <name>
  Build under test   <commit or version>
  Requested by       <name and role>
  Authorised by      <name and role>
  Authorisation      <where it is recorded: ticket, message, contract clause>
  Date and window    <start, end, and the hours testing may run>

TARGETS IN SCOPE
  <exact hosts>
  <exact applications and paths>
  <APIs, including versions>

EXPLICITLY OUT OF SCOPE
  production, unless named above
  identity providers, payment providers, mail providers, CDNs
  shared infrastructure, monitoring, CI systems
  any account, tenant or record not created by this engagement
  any host that merely resolves from a target

ACCOUNTS OWNED BY THE ENGAGEMENT
  role            purpose
  admin A         tenant A administrator
  member A        tenant A member
  admin B         tenant B, for isolation checks
  anonymous       no credentials

  Credentials are held in the project secret store. They never appear in this
  document, in evidence, or in a report.

DATA RULES
  may create      <records, of which types>
  may modify      <only records created by the engagement>
  never touch     <production data, real customer records, shared fixtures>
  cleanup         <who removes what, and when>

ACTIVITY RULES
  destructive tests           permitted | forbidden
  availability affecting      permitted | forbidden
  automated scanning          permitted | forbidden, and at what rate
  social engineering          forbidden
  physical                    forbidden
  third party interaction     forbidden

STOP CONDITIONS
  real personal data is reached
  a production system responds to a request meant for staging
  a finding suggests an active compromise
  the environment becomes unstable
  anything outside the target list responds

  On any of these: stop, preserve what is needed to report, notify the
  authorising contact through the agreed channel, and wait.

REPORTING
  channel         <where findings go, and to whom>
  urgency rule    <what is reported immediately rather than in the report>
  retention       <how long evidence is kept, and where it is destroyed>
```

## Confirmation

```
Confirmed by <name> on <date>, through <channel>.
```

An unconfirmed boundary is treated as forbidden. A verbal `go ahead` recorded
nowhere is not a boundary; ask for one line in writing, which nobody has ever
refused.

## Why the exclusions are explicit

Reachability is not permission. A staging application usually shares an
identity provider, a mail provider and a payment provider with production, and
all three are someone else's system. Naming them in the excluded list prevents
the most common accident in this discipline.
