# Severity scale

The scale every finding in the security tree is ranked on. Severity is a
function of two things only: the impact if the finding is exploited, and the
reachability of the finding from where an attacker actually stands. Novelty,
effort to find, and how clever the bug is do not enter into it.

## The five levels

| Severity | Impact | Reachability |
|---|---|---|
| critical | full compromise, mass data exposure, auth bypass, RCE, payment manipulation | reachable by an unauthenticated remote attacker |
| high | privilege escalation, cross-tenant data exposure, account takeover, stored injection | reachable by any authenticated user, or by an attacker with one common precondition |
| medium | single-user data exposure, reflected injection, a missing control that enables another finding | needs user interaction, or a less common precondition |
| low | defence in depth missing behind a control that already stands, verbose errors, weak setting with no shown path | not currently reachable, or fully mitigated by another layer |
| info | an observation with no current impact | not applicable |

## Reachability moves severity

The same defect is not the same severity in two places. Rank by what an
attacker can do from where they are.

```
SQL injection on a public search endpoint            critical
the same injection in an admin-only report builder   high, at most
the same injection behind a feature flag off in prod low, until the flag ships
```

```
missing rate limit on the login endpoint             high, enables credential stuffing
missing rate limit on a static marketing page        info
```

```
secret committed to a public repository              critical, rotate now
secret in a private repo, in history, still valid    high, rotate now
secret in history, already rotated                   low, record and move on
```

## What does not change severity

```
how hard the bug was to find        a trivially found critical is still critical
how elegant the exploit is          impact is impact
whether a scanner or a human found it   the finding is ranked on its path, not its source
how embarrassing it is              rank it, do not soften it
whether it is likely to be exploited    likelihood informs priority, not severity;
                                        record both, but do not downgrade a
                                        critical to medium because it feels unlikely
```

## Using the scale

1. Establish the impact assuming the finding is exploited fully.
2. Establish the reachability: who can reach it, and what they need first.
3. Take the level where both the impact column and the reachability column
   match. When they disagree, reachability caps the severity: an unreachable
   critical-impact finding is not critical until the path is shown.
4. Record the reasoning in one line, so the ranking can be checked and repeated.

A ranking that cannot be explained in one sentence of impact and one of
reachability is a guess. Write both sentences.
