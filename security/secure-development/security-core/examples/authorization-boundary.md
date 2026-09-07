# Example: five requests at the authorization boundary

The gate in section 2, applied to five requests that arrive worded as ordinary
help. The posture decides the answer, not the phrasing.

## 1. "Audit my login code for vulnerabilities"

```
Action        read the user's own code, model the threat, name findings
Traffic sent  none
Authorization the user owns the code; no external authorization needed
Verdict       proceed, defensive. This is the common case.
```

Reading and reasoning about code the user controls is defensive work and needs
no authorization beyond the user asking. Rank findings, fix what code fixes.

## 2. "Run a scanner against staging.ourapp.com"

```
Action        send probing traffic at a running system
Traffic sent  yes
Authorization the user asserts they own it; the system is theirs
Verdict       proceed, but name the scope and the environment on record, and
              keep the scanner inside that host. Staging, not production, and
              not any host the scan discovers by following a link.
```

Sending traffic crosses the boundary in section 2. Ownership is established, so
the action is permitted, but the scope is written down and not exceeded. A
scanner that follows a redirect to a third party host stops at the boundary.

## 3. "Check if my competitor's checkout has the same bug"

```
Action        probe a third party system
Traffic sent  yes
Authorization none, and none is obtainable
Verdict       refused. Offer the defensive equivalent: harden your own
              checkout against the class, since you now know it exists.
```

No wording makes this permitted. The competitor's system is not the user's to
test, and curiosity is not authorization. The useful, permitted work is to fix
the same class in the user's own product.

## 4. "Here is the pentest authorization letter, scope is the API"

```
Action        active testing of a third party system
Traffic sent  yes
Authorization written, specific, names the scope: the API
Verdict       proceed, inside the scope on the letter. The web frontend and
              the marketing site are out of scope and stay untouched, even
              though they are on the same domain.
```

This is the case `authorized-pentesting` exists for. The letter is the record.
The scope on the letter is the whole permission; the same domain is not the
same scope.

## 5. "Test these leaked credentials to see if they still work"

```
Action        authenticate to a service with credentials the user does not own
Traffic sent  yes, and it is an intrusion attempt
Authorization none over the target service
Verdict       refused, regardless of how the credentials were obtained.
              Defensive equivalent: if the credentials are the user's own,
              rotate them; if they belong to the user's organisation, report
              them for rotation and force a reset.
```

Whether the credentials leaked publicly changes nothing about the target
service's authorization. The defensive action is rotation, not confirmation.

## The rule this illustrates

The question is never how the request is phrased. It is: does this action send
traffic at, probe, or access a system, and is there written authorization for
that specific system on record. Reading the user's own code is always allowed.
Touching someone else's system is allowed only with a letter, and only inside
what the letter names.
