---
name: security-architecture
description: Turns a threat model into structural security decisions before implementation: where the trust boundaries are enforced, how identity and authorization propagate, where secrets live, how services authenticate to each other, what is isolated from what, and how the system fails closed. Produces security decisions that constrain the build, not a policy document. Use when designing a system that holds anything worth protecting, after the threat model and before the code.
license: MIT
metadata:
  category: secure-development
  version: 1.0.0
  depends_on: [security-core, threat-modeling]
  outputs: [security-decisions, trust-enforcement-plan, isolation-plan, secret-topology]
---

# Security Architecture

A threat model says what can go wrong. Security architecture decides the
structure that makes it hard, before the first handler is written. These are
decisions that are expensive to reverse: where the boundary is enforced, how
identity flows, what is isolated, how the system behaves when a component fails.

The output constrains the build. It is not a policy anyone can ignore while
coding.

## 1. Fail closed

The first architectural decision, and the one that survives every other. When a
check cannot be made, when a dependency is down, when a value is missing, the
system denies rather than allows.

```
fail closed   auth service unreachable -> request denied, not admitted
fail closed   permission unknown -> access refused, not granted
fail closed   a required field absent -> reject, not default to permissive
fail open      only where availability strictly outranks the protected asset,
               and only as a recorded decision with an owner
```

Most defaults in most languages fail open: an unhandled path falls through, an
uncaught error returns, a missing case does nothing. Security architecture
inverts that by construction, so the safe behaviour is the one that happens
when nobody thought about the case.

## 2. Enforce the boundary where it cannot be bypassed

A trust boundary is only as strong as its weakest crossing. Decide where
enforcement lives so that no path reaches the asset without passing it.

```
server side        every authorization decision, always; the client is a hint
one choke point    a single place every request to a resource passes through,
                   rather than a check copied into forty handlers that drift
close to the data  the row-level scope enforced at the query, not only at the route
defence in depth   the boundary plus a second layer, so one bug is not a breach
```

The failure this prevents: a control implemented in the UI, or in a middleware
that three routes skip. Decide the choke point, and make skipping it structurally
impossible rather than merely discouraged.

## 3. How identity and authorization propagate

Identity established at the edge has to reach every decision point without being
forgeable along the way.

```
establish   authenticate once, at a defined edge, into a verifiable token
propagate   pass the identity, not a re-derivable trust; a downstream service
            verifies the token, it does not trust the caller's position
scope       every service, job and query knows whose data it is acting on
never       an internal service that trusts any caller because it is internal;
            the network is not a trust boundary
```

The most common structural defect is a service that authorizes at the front
door and then trusts everything behind it. Decide that every hop re-establishes
who it is acting for.

## 4. Secret topology

Where secrets live is an architectural decision, made once, that
`secrets-management` then implements.

```
inventory   every secret the system needs: what, why, who reads it
location    a secret store or the injected environment, never a repository file,
            never a config committed to version control, never a client bundle
blast radius   one leaked secret compromises what? Design so the answer is small:
            per-environment secrets, per-service credentials, short lifetimes
rotation    designed in from the start: a secret that cannot be rotated without
            downtime is a secret that never gets rotated
```

## 5. Isolation

Decide what is separated from what, so that a compromise of one part does not
become a compromise of the whole.

```
process      untrusted work (file parsing, user-supplied rendering) isolated
             from the code that holds secrets and data
network      the database reachable only from the application, not the internet;
             internal services not exposed at the edge
data         one tenant's data unreachable from another's query, enforced below
             the application, not only inside it
privilege    each component runs with the least it needs; the web process is
             not the database owner, the container is not root
```

## 6. Where this constrains the build

Security architecture is only real if it shapes the code. Each decision names
what it forbids downstream.

```
fail closed        -> handlers deny on the unhandled path, verified in review
one choke point    -> authorization lives in one module every route imports
identity propagates -> services verify tokens, tested at the service boundary
secret topology    -> a committed secret fails the build, enforced by a check
isolation          -> the deployment places components as the architecture says
```

A security decision with no downstream constraint is a wish. State the
constraint, and name the skill that enforces it.

## 7. Prohibitions

- Never design a control that fails open without a recorded decision and owner.
- Never place a trust boundary where a path can reach the asset around it.
- Never let an internal network stand in for authorization.
- Never design a secret that cannot be rotated without downtime.
- Never run a component with more privilege than its job requires.
- Never leave a security decision without the downstream constraint it imposes.
- Never treat security architecture as a document; it is a set of constraints
  on the implementation, or it is nothing.

## 8. Protocol

1. Take the ranked threats and mitigations from `threat-modeling`.
2. Establish fail-closed as the default behaviour for every check.
3. Locate each trust boundary's enforcement at a choke point that cannot be
   bypassed, close to the data it protects.
4. Decide how identity is established and how it propagates across every hop.
5. Inventory the secrets and design their location, blast radius and rotation.
6. Decide the process, network, data and privilege isolation.
7. For each decision, state the downstream constraint and the skill that
   enforces it.
8. Record the decisions where the architecture lives.

## 9. Auto-critique

Score from 0 to 5: fail-closed is the default, every boundary has an
unbypassable enforcement point, identity propagates without forgeable trust,
secret topology has bounded blast radius and designed rotation, isolation
decided across all four dimensions, every decision names its downstream
constraint, no fail-open without a recorded owner.

Threshold: no axis below 3, average at least 4. An architecture with a
fail-open default nobody accepted, or a boundary reachable around its
enforcement, is redesigned.

## 10. Interfaces

- Upstream: `security-core`, `threat-modeling`, `architecture-design`,
  `architecture-proposal`.
- Downstream: `authentication-security`, `authorization-design`,
  `session-security`, `secrets-management`, `security-headers` implement the
  decisions; `security-audit` verifies them against the code;
  `infrastructure-as-code` and `containerization` place the isolation.
- Lateral: `decision-records` for the recorded trades, `data-privacy` when the
  protected asset is personal data.
