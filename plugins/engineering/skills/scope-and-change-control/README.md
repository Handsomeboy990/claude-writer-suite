# scope-and-change-control

Protects an approved scope and architecture from silent drift. Classifies every
discovery as in scope, follow up, urgent or a change, runs the change protocol
when implementation contradicts the approved design, and prices client requests
instead of absorbing them.

- Inputs: the approved architecture and scope, discoveries made while
  building.
- Outputs: scope decisions, follow up register, change requests, architecture
  updates.
- Depends on: engineering-core, validation-gate.
- Downstream: architecture-proposal, project-continuity, client-handover.

The default answer to a discovered improvement is register it, do not do it.
The urgent exception is narrow: security, data integrity, correctness. Every
accepted change updates the architecture document, always.
