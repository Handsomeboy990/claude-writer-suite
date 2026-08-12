# Testing contract template

Short by design. It exists so that two people disagree before the campaign
rather than after it. Anything not written here is out of scope.

```
CAMPAIGN
  Product          <name>
  Version          <commit or release under test>
  Date             <date>
  Requested by     <who>

SCOPE
  In               <surfaces, features, flows>
  Out              <explicitly excluded, with the reason>

ENVIRONMENT
  Name             <local | test | staging | production>
  Base URL         <url>
  Data             <seeded | anonymised copy | real>
  Accounts         <roles available, referenced by role, never by credential>

OBJECTIVES
  <the questions this campaign must answer, ordered>

CRITICAL FLOWS
  1 <flow whose breakage is an incident>
  2 <...>

DISCIPLINES
  In campaign      <selected skills>
  Not in campaign  <skill: reason>

ALLOWED ACTIONS
  <create accounts, write records, upload files, payments in test mode>

FORBIDDEN ACTIONS
  <every production side effect, mail to real addresses, deletion of shared
   data, load generation, anything the environment cannot recover from>

SECURITY BOUNDARY
  Authorised targets   <exact hosts, paths, applications>
  Out of scope         <third party services, shared infrastructure, other
                        tenants not owned by this campaign>
  Destructive tests    <permitted | forbidden>
  Authorisation        <who authorised, when, in what form>

DATA CONSTRAINTS
  <what may be created, what must be cleaned up, what must never be touched,
   what may never appear in evidence>

MATRIX
  Browsers         <the ones that will actually be exercised>
  Devices, widths  <from the project, not from a generic list>
  Locales          <if more than one>

DELIVERABLES
  <report, evidence, tests committed, continuity notes>

ACCEPTANCE
  <what a pass means here, in one or two sentences>
```

## Rules

1. The security boundary is written before any security test runs, and it
   names hosts, not intentions.
2. `Forbidden actions` is never empty. If it is, nobody thought about it.
3. Credentials never appear in the contract. Roles do.
4. A contract touching production, real data or destructive scenarios is
   confirmed by a human before execution.
5. The contract is attached to the report, so a reader knows what a pass
   covered.
