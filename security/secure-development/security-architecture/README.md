# security-architecture

Turns a threat model into structural decisions before implementation: fail
closed by default, trust boundaries enforced at unbypassable choke points, how
identity propagates, where secrets live and how they rotate, and what is
isolated from what.

- Inputs: the threat model, the system architecture, the assets to protect.
- Outputs: security decisions, trust-enforcement plan, isolation plan, secret topology.
- Depends on: security-core, threat-modeling.
- Downstream: authentication-security, authorization-design, secrets-management, security-audit.

Every decision names the downstream constraint it imposes and the skill that
enforces it. A security decision with no downstream constraint is a wish.
