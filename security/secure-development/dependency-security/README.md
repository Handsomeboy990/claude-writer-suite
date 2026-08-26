# dependency-security

Secures the code a project did not write: the full resolved inventory including
the transitive tree, known-vulnerability scanning re-ranked by reachability,
safe upgrades, pinning and integrity, and supply-chain defence against
typosquatting and compromised packages.

- Inputs: the lockfile, the resolved tree, any vulnerability alert in scope.
- Outputs: dependency audit, reachability assessment, upgrade plan, supply-chain notes.
- Depends on: security-core.
- Downstream: ci-cd-pipelines, release-readiness, security-audit.

Complements dependency-selection, which decides whether to add a dependency;
this skill secures the ones already present. The truth is the lockfile, not the
manifest, and the vulnerable package is usually one nobody chose.
