# validation-gate

The hard stop before implementation. Presents a one screen approval package
covering architecture, stack, database, backend, frontend, infrastructure,
testing, deployment, scope, assumptions, open questions, risks and recurring
cost, then waits and records the decision verbatim.

- Inputs: the architecture proposal, the stack decisions, the assumptions.
- Outputs: approval package, approval record, revision log.
- Depends on: engineering-core, architecture-proposal, technology-selection.
- Downstream: delivery-planning, then implementation.
- Reopened only by: scope-and-change-control.

No production code exists before this gate returns an approval, scaffolding
included. After it, the gate does not reopen for ordinary work: the system
executes and reports at phase boundaries.
