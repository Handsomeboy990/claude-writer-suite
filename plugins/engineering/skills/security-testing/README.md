# security-testing

Exercises the security controls of a running application inside a written,
confirmed boundary. Authorization first: the role matrix, object level access
and tenant isolation, then sessions, input handling, disclosure, uploads,
headers and business logic.

- Inputs: the engagement boundary, accounts the engagement owns, the surface
  inventory, the static findings from security-audit.
- Outputs: authorization record, role matrix results, findings with confidence
  and severity, remediation list.
- Depends on: engineering-core, quality-engineering, security-audit.
- Lateral: input-validation, bug-hunting, api-testing.
- Downstream: backend-engineering, testing-quality, test-reporting,
  secrets-management.

No request is sent before the boundary is confirmed. Nothing outside it is
touched, availability is never affected without written permission, real user
data is never used as test material, and a finding that exposes real data stops
the session and is reported immediately.
