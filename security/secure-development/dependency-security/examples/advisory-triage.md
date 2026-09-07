# Example: triaging a vulnerability alert

CI reports three advisories on a Node service after a routine scan. Each is
triaged by reachability, not by its published severity alone.

## The three advisories

```
A  critical  prototype pollution in a deep-merge utility, transitive via a
             config loader used only at startup
B  high      ReDoS in a validation library, called on every request body
C  moderate  a path-traversal in an image resizer, called on user uploads
```

## Reachability assessment

```
A  the vulnerable merge is called once, at boot, on a config file the operator
   controls, never on request input.
   Re-ranked: low for the running system. An attacker cannot influence the
   input. Still upgraded, reasoning recorded.

B  the vulnerable regex path runs on every inbound request body, which is
   attacker-controlled.
   Re-ranked: high stands, and it is the priority. A crafted body hangs a worker.

C  the resizer runs on every user-uploaded image, attacker-controlled, and the
   traversal writes outside the intended directory.
   Re-ranked: moderate rises to high; combined with write access it approaches
   critical. Investigated and prioritised alongside B.
```

## Upgrade plan

```
B  patched in 6.4.2, a patch release. Upgrade, run the suite.
   Verified: the ReDoS reproduction (a pathological input that hung for seconds)
   now returns in milliseconds; the suite passes.

C  patched only in 3.0, a major with a changed API. Two-line call-site change.
   Upgrade with the migration, run the suite and the upload tests.
   Verified: the traversal payload (a filename with ../) is now rejected; uploads
   still work.

A  patched in a minor. Upgrade for hygiene even though it is unreachable, so the
   report is clean and the next scan does not re-raise it.
```

## Recorded

```
No accepted residuals this round: all three were fixable now. The scan stays in
CI as a blocking gate, so the next advisory is caught at the pull request, not
in a quarterly audit.
```

## The lesson

The moderate advisory (C) was the second most dangerous once reachability was
judged, and the critical one (A) was the least. Ranking by the published
severity alone would have inverted the priority.
