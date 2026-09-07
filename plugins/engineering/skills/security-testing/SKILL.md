---
name: security-testing
description: Tests the security controls of a running application inside an explicitly authorized scope: the role matrix, object level access, tenant isolation, session and authentication behaviour, safe input probes, headers and cookies, information disclosure, upload handling, rate limiting and business logic boundaries. Complements the static sweep of security-audit. Use when roles, tenancy, payments, uploads or personal data exist, and only within a written authorization.
license: MIT
metadata:
  category: dev-skills
  version: 1.0.0
  depends_on: [engineering-core, quality-engineering, security-audit]
  outputs: [authorization-record, role-matrix-results, security-findings, remediation-list]
---

# Security Testing

`security-audit` reads the implementation. This skill exercises the running
system to find out which of those controls actually hold, using accounts and
targets the engagement owns.

It is verification work, not adversarial work against anyone else's system.
Everything here happens inside a boundary someone wrote down and approved.

## 1. Authorization comes first

No request is sent until `resources/engagement-boundary.md` is filled in and
confirmed. It records:

```
targets           exact hosts, applications and paths in scope
excluded          everything else, named where confusion is likely
environment       which one, and whether it is production
accounts          the accounts the engagement owns, and their roles
data              which records may be created, read, modified
destructive       permitted or forbidden, in writing
availability      whether anything that could degrade service is allowed
authorised by     who, when, and in what form
stop conditions   what makes the tester stop immediately and report
```

Rules that never bend:

- Only systems the engagement owns or is authorised to test are touched.
- Third party services, shared infrastructure and other customers are out of
  scope even when they are reachable from the target.
- Real user accounts and real personal data are never used as test material.
- Nothing that degrades availability runs without explicit written permission,
  and never against production.
- If a finding exposes real user data, testing stops there, the finding is
  reported immediately, and no further data is retrieved.

## 2. The order that finds the most

```
1  authorization: roles, object level access, tenancy
2  authentication and session lifecycle
3  input handling, verified as rejection rather than exploitation
4  information disclosure through errors, responses and headers
5  uploads and file handling
6  transport, headers, cookies and CORS
7  rate limiting and abuse resistance
8  business logic boundaries
```

Authorization is first because it is where real products fail, and where the
consequence is direct: someone reads someone else's data.

## 3. The role matrix

Build it once, from the roles the product defines, then test every cell. Full
template in `resources/role-matrix.md`.

```
rows      every protected resource and action
columns   anonymous, each role, and an account from another tenant
cells     expected: permitted or denied
result    observed, per cell
```

Every denied cell is verified twice: once through the interface, and once by
sending the request directly. A hidden button is not an authorization control,
and the second check is the only one that proves anything.

## 4. Object level access

For each resource reachable by identifier:

```
as an owner, note the identifier of a record you own
as a second account the engagement owns, request that identifier
repeat for read, update, delete, and any state transition
repeat through every route that reaches the same object: detail, list filter,
  export, print view, attachment, webhook callback, admin path
check sequential identifiers, and identifiers found in responses meant for
  another audience
```

The single most common real defect is one route that checks ownership and a
second route to the same object that does not.

## 5. Tenant isolation

For multi-tenant products, with two tenants the engagement owns:

```
read      tenant A cannot read any object of tenant B, through any route
write     tenant A cannot create, modify or delete inside tenant B
infer     counts, totals, search results, autocomplete, error differences and
          timing must not reveal that an object of tenant B exists
identify  changing a tenant identifier in a path, a body, a header, a token
          claim or a query parameter does not move the caller
invite    invitations, shared links and exports do not cross the boundary
admin     an administrator of tenant A is not an administrator of anything else
```

Isolation is checked on every read path, not on the main one. Reports,
exports, search indexes and background jobs are where it usually leaks.

## 6. Authentication and sessions

```
credentials    the same response for an unknown account and a wrong password
lockout        repeated failures are throttled, and the throttle is per account
               and per source
session        a token or cookie is invalidated on logout, on password change,
               and on role change
expiry         an expired session is rejected everywhere, including background
               refresh calls
fixation       the session identifier changes on privilege change
cookies        HttpOnly, Secure, SameSite as the application requires
recovery       a reset link is single use, time limited, and does not confirm
               whether an address exists
second factor  cannot be skipped by going directly to the post login route
```

## 7. Input handling

The purpose is to confirm that invalid input is rejected safely, not to
achieve an effect. Probes are minimal and non destructive: a value the
application should refuse, sent once, with the response examined.

```
what is checked
  the rejection status is correct and consistent
  the error names the field, not the storage layer
  no input is reflected into a page or a header unescaped
  no input reaches a query, a command, a path or a template unbound
  size limits are enforced before parsing
  encoding differences do not bypass a validator
```

Where a probe suggests a real weakness, it is confirmed once, with the
smallest possible evidence, and reported. Payload escalation, data extraction
and persistence of anything harmful are out of scope. `input-validation` holds
the constructive counterpart: what the code must do instead.

## 8. Disclosure and configuration

```
error responses: no stack trace, no SQL, no file path, no internal host
debug endpoints, source maps, directory listings, backup files, version banners
headers the application declares it sets, verified as actually present
CORS: which origins are allowed, whether credentials are allowed with them
caching of authenticated responses in shared caches
identifiers that leak sequence, volume or ownership
metadata in generated documents and images
```

## 9. Uploads and business logic

```
uploads   type verified by content, size limited, stored outside the web root
          or behind an authorising handler, filenames neutralised, downloads
          served with a safe content type and disposition
logic     price, quantity, role, status and owner never taken from the client
          state transitions that skip a required step are refused
          quotas and limits hold under repetition and concurrency
          refunds, credits and discounts cannot be applied twice
          webhooks verify their signature and refuse replays
```

## 10. Findings

Each finding carries the full record from `test-reporting`, plus:

```
confidence   Confirmed, Potential, or Informational
severity     Critical, High, Medium, Low, Info
category     authorization, authentication, disclosure, validation,
             configuration, business logic
impact       what an attacker with this access could do, stated plainly
evidence     the minimum that proves it, with secrets and personal data removed
fix          the control that should exist, not a general principle
```

Confidence is never inflated. `Potential` means the control looked wrong and
the confirmation was not run because the boundary forbade it, and that is a
respectable result. Severity reflects consequence, not effort.

## 11. Prohibitions

- Never touch a target outside the written boundary, even when it responds.
- Never run availability affecting tests without explicit permission.
- Never use, retrieve or store real user data as evidence.
- Never keep a foothold, a persistent artefact or a modified permission after
  the test.
- Never chain a finding further than proving it exists.
- Never report a theoretical weakness as confirmed.
- Never leave a credential, token or session in a report, a screenshot or a
  test file.
- Never disclose a finding outside the agreed channel.

## 12. Protocol

1. Fill in and confirm the engagement boundary. Stop if it is not confirmed.
2. Take the surface inventory from `project-exploration` and `api-testing`.
3. Read the static findings from `security-audit` and target their claims.
4. Build the role matrix and test every cell, interface and direct request.
5. Run object level access and tenancy checks on every route to each object.
6. Test authentication and session lifecycle.
7. Run the safe input probes and the disclosure checks.
8. Check uploads, headers, cookies, CORS and rate limiting.
9. Test the business logic boundaries the product's money and state depend on.
10. Record each finding with its confidence and its minimal evidence.
11. Clean up: remove created records, revoke created sessions, leave nothing.
12. Report through the agreed channel, and hand fixes to the owning skill.

## 13. Auto-critique

Score from 0 to 5: boundary respected and recorded, role matrix completed
including direct requests, object level and tenancy coverage across every
route, session lifecycle tested, evidence minimal and clean of secrets,
severity and confidence honest, environment left in its original state.

Threshold: no axis below 3, average at least 4. A campaign that tested
authorization only through the interface scores 0 on that axis and is rerun.

## 14. Interfaces

- Upstream: `quality-engineering` for the contract and the boundary,
  `security-audit` for the static findings, `api-testing` for the inventory.
- Lateral: `input-validation` for the constructive rules, `bug-hunting` for
  the non security abuse of the same surfaces, `devops-core` for anything that
  belongs to the environment rather than the code.
- Downstream: `backend-engineering` and `frontend-engineering` for fixes,
  `testing-quality` for the permanent authorization tests, `test-reporting`
  for the findings, `secrets-management` when a credential is exposed.
