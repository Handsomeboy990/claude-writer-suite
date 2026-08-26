# threat-modeling

Builds a threat model that ends in decisions, not diagrams: what is protected,
who the adversary is, where trust boundaries sit, what can go wrong at each
crossing, and whether each threat is mitigated, accepted or transferred.

- Inputs: the system or planned feature, its assets, its data flow.
- Outputs: threat model, trust boundaries, ranked threats, mitigation plan.
- Depends on: security-core.
- Downstream: security-architecture, authentication-security, authorization-design, security-audit.

Every threat gets a severity and a decision. An accepted risk is recorded with
the role that accepted it, the way decision-records records any other trade. A
threat nobody decided about is an unmodelled threat.
