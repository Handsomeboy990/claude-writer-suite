# delivery-planning

Turns an approved architecture into ordered, atomic engineering tasks grouped
into demonstrable milestones, with dependencies by identifier, a
parallelisation map built around named contract tasks, and tests attached to
every task that changes behaviour.

- Inputs: the approved architecture and its requirements mapping.
- Outputs: milestone plan, task breakdown, dependency order,
  parallelisation map.
- Depends on: engineering-core, architecture-proposal, validation-gate.
- Downstream: engineering-orchestrator executes each task.

Feature milestones are vertical, never horizontal: all backends followed by
all frontends is a plan that finds its integration problems last, when they
cost the most.
