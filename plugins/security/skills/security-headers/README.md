# security-headers

Configures and audits the response headers and transport settings that harden a
web app in the browser: Content-Security-Policy, HSTS, nosniff, frame
protection, Referrer-Policy, Permissions-Policy, CORS, and cookie flags. Turns
the browser into an ally instead of an open door.

- Inputs: the live HTTP responses, the CORS needs, the HTTPS posture.
- Outputs: header policy, header findings, CSP, CORS policy, applied fixes.
- Depends on: security-core.
- Downstream: security-audit, deployment-engineering, infrastructure-as-code.

Missing a header is a finding; misconfiguring one is worse, because it looks
like protection. A credentialed wildcard CORS, or a CSP carrying unsafe-inline
on script, is theatre and ranked as such.
