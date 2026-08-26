# security-assurance

Finding what is wrong in a system that exists. Two skills: one non-intrusive and
broad, one active and tightly gated.

| Skill | Purpose | Gate |
|---|---|---|
| [vulnerability-assessment](vulnerability-assessment/) | a structured, non-destructive sweep of an owned system, ranked findings, remediation plan | ownership or a written scope |
| [authorized-pentesting](authorized-pentesting/) | active exploitation to prove impact from a confirmed finding | written, specific, in-scope authorization on record |

Both refer to [../secure-development/security-core](../secure-development/security-core/)
for the authorization boundary and the severity scale.

`authorized-pentesting` is the only skill in the suite that crosses into
offensive technique. Its first step is always the authorization gate, and the
refusal on a system without authorization is not negotiable by rephrasing.
