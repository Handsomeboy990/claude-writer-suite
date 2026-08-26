# implementation-integrity

Detects and forbids fake functionality: stub handlers, mock saves, fake
success, simulated delays, hardcoded data, dead controls, placeholder business
logic, swallowed failures and TODOs on reachable paths.

- Inputs: the diff or the repository, the running application.
- Outputs: integrity scan, stub register, honest completion report.
- Depends on: engineering-core.
- Lateral: code-review-protocol, which treats these findings as blockers.
- Downstream: project-continuity, release-readiness.

The honesty rule: every path a user can reach either works, or visibly does
not exist. Three kinds of incompleteness are legitimate, each with a required
form and a register entry; everything else is a defect that is fixed, never
deferred.
