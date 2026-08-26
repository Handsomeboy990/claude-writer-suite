# session-security

Owns the session lifecycle after login: representation and storage, cookie
attributes, fixation and rotation, idle and absolute timeout, concurrent
sessions, revocation on logout and password change, and CSRF defence. The bridge
between a correct login and a correctly protected request.

- Inputs: the session and cookie implementation, the auth model, the logout flow.
- Outputs: session findings, session design, cookie policy, applied fixes.
- Depends on: security-core.
- Downstream: authorization-design, security-audit, security-headers.

A session cookie without HttpOnly and Secure is a finding. A logout that only
deletes the client cookie, for a token the server cannot revoke, is a lie.
