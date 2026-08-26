---
name: threat-modeling
description: Builds a threat model before code is written or on a system that exists: what is being protected, who the adversary is, where trust boundaries sit, how data flows across them, what can go wrong at each crossing, and which threats are accepted, mitigated or transferred. Produces a ranked, actionable model, not a diagram nobody reads. Use before designing a sensitive feature, and when a system has never been reasoned about as a target.
license: MIT
metadata:
  category: secure-development
  version: 1.0.0
  depends_on: [security-core]
  outputs: [threat-model, trust-boundaries, ranked-threats, mitigation-plan]
---

# Threat Modeling

A threat model answers four questions in order: what are we protecting, who
wants it, where do they cross into the system, and what do we do about each way
they can. A model that stops at a diagram has answered none of them.

The output is a ranked list of threats, each with a decision: mitigate,
accept, or transfer. An unranked model is a list of fears.

## 1. What is being protected

Name the assets before the attacks. An attack has no severity until it lands on
something worth protecting.

```
data        what data, whose, and what its exposure costs the user and the business
function    what the system does that an attacker would want to abuse or deny
identity    the accounts, roles and sessions that gate everything else
trust       the reputation and legal position that a breach damages
```

Rank the assets. The model spends its attention on the crown jewels, not
equally on everything.

## 2. Who the adversary is

Different adversaries reach different places and want different things. Name the
ones that apply; ignore the ones that do not.

```
unauthenticated remote    the internet, hitting every public surface
authenticated user        a real account, probing what it should not reach
malicious insider         legitimate access, abused
compromised dependency    code you shipped, working for someone else
the user's own device     malware, a shared computer, a stolen session
a determined targeted actor   only if the assets justify modelling them
```

A model that assumes a nation-state for a hobby project wastes effort. A model
that assumes only accidental misuse for a payment system is negligent. Match
the adversary to the assets.

## 3. Trust boundaries and data flow

A trust boundary is a line where data or control passes from something you trust
less to something you trust more. Every serious threat lives on a boundary.

```
client to server          nothing from the client is trusted, ever
service to service         is the caller authenticated, is the call authorized
application to database    is the query parameterised, is the row scoped
your system to a third party   what leaves, what returns, what you now trust
user to user               content one user submits that another user renders
```

Draw the flow: where data enters, where it is stored, where it is rendered,
where it leaves. Mark every boundary crossing. The crossings are the model.

## 4. What can go wrong: the six categories

At each boundary crossing, walk the six. They are a checklist for generating
threats, not a taxonomy to file them under.

```
spoofing        can the attacker pretend to be someone they are not
tampering       can they change data in transit or at rest
repudiation     can they deny an action with no record to contradict them
disclosure      can they read what they should not
denial          can they make it unavailable to legitimate users
elevation       can they gain a capability they were not granted
```

For each crossing, ask each question. A yes is a candidate threat. Write it as
a sentence: an attacker who is X can do Y because Z.

## 5. Ranking and deciding

Every candidate threat gets a severity from `security-core` and a decision.

```
mitigate    add a control that closes or narrows the threat; name the control
accept      the cost of mitigation exceeds the risk; record who accepted it
transfer    insurance, a third party who owns the risk, a contractual boundary
```

An accepted threat is a decision, not an omission. It is recorded with the
reasoning and the accepting role, the way `decision-records` records any other
trade. A threat nobody decided about is an unmodelled threat.

## 6. Keeping it alive

A threat model written once and never revisited describes a system that no
longer exists. Tie it to change.

```
revisit   when a new trust boundary appears: a new integration, a new role,
          a new data type, a new entry point
revisit   when an asset's value changes: the feature that now handles payments
revisit   at a security review before a significant release
retire    a mitigation whose threat is gone, so the model stays readable
```

## 7. Prohibitions

- Never model attacks before naming assets; an attack on nothing is noise.
- Never assume an adversary the assets do not justify, in either direction.
- Never produce a model without a decision on every threat.
- Never record a diagram alone and call it a threat model.
- Never let an accepted risk be silent; name it and the role that accepted it.
- Never model only the happy boundaries; the third party integration and the
  user-to-user content path are where the serious threats hide.

## 8. Protocol

1. List and rank the assets worth protecting.
2. Name the adversaries the assets justify.
3. Draw the data flow and mark every trust boundary crossing.
4. At each crossing, walk the six categories and write each candidate threat as
   a sentence.
5. Rank each threat with the `security-core` scale.
6. Decide each: mitigate with a named control, accept with a recorded reason,
   or transfer.
7. Hand the mitigations to the skills that implement them.
8. Record the model where the design lives, and tie it to the changes that
   should revisit it.

## 9. Auto-critique

Score from 0 to 5: assets named and ranked, adversaries matched to assets,
every trust boundary marked, six categories walked at each crossing, every
threat written as a concrete sentence, every threat ranked, every threat
decided, accepted risks named with their owner, the model tied to change.

Threshold: no axis below 3, average at least 4. A model with an undecided
threat, or with attacks but no assets, is rewritten.

## 10. Interfaces

- Upstream: `security-core` for posture and severity, `architecture-design` and
  `architecture-proposal` for the system the model reasons about.
- Downstream: `security-architecture` turns mitigations into design,
  `authentication-security`, `authorization-design`, `session-security`,
  `input-validation`, `security-headers` implement specific controls,
  `security-audit` verifies the controls exist in the code.
- Lateral: `decision-records` for accepted risks, `data-privacy` when the
  assets are personal data.
