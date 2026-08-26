# authentication-security

Builds and audits how a system establishes identity: password storage and
policy, the login flow and its rate limits, credential recovery, multi-factor,
and token issuance, lifetime and revocation. Covers the flows attackers probe
first.

- Inputs: the login, signup, reset and token flows, built or existing.
- Outputs: auth findings, auth design, credential policy, applied fixes.
- Depends on: security-core.
- Downstream: session-security, authorization-design, security-audit.

Authentication answers who you are; authorization-design answers what you may
do. This skill never grants a capability. A general-purpose password hash, an
enumerable login, or an unrevocable token is a critical finding.
