# Judging reachability of a dependency advisory

An advisory's published severity assumes the worst deployment. This project is a
specific deployment. Reachability re-ranks the advisory for this code.

## The three questions

1. Is the vulnerable code path actually invoked by this application, directly or
   through a transitive caller?
2. Can an attacker influence the input that reaches it?
3. Where does it run: on request input, at startup, in the build, in a test?

## The re-ranking table

| Invoked? | Attacker input? | Runs where | Re-rank |
|---|---|---|---|
| yes | yes | on request | advisory severity stands or rises |
| yes | yes | at startup, operator input only | lower; operator is trusted |
| yes | no | anywhere | lower; input cannot be steered |
| no | n/a | present but unreached | low; upgrade anyway for hygiene |
| yes | yes | build or test only | low for prod, real for the build |

## Verifying "we do not call that function"

The dangerous claim is that a path is unreached. Verify it, do not assert it:

- Search for direct calls to the vulnerable API in the codebase.
- Check whether a transitive dependency calls it on the application's behalf.
- Confirm the version installed is the vulnerable one, not a duplicate that is
  patched while another copy is not.

If reachability cannot be established, treat the advisory at its published
severity until it can. Unknown reachability is not the same as unreachable.

## What reachability never does

Reachability lowers urgency; it does not cancel the upgrade. A present-but-
unreached vulnerability is still upgraded, because the next code change may make
it reachable, and a clean scan is worth keeping. Record the reasoning so the low
ranking can be checked, not taken on faith.
