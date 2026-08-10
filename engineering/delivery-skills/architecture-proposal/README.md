# architecture-proposal

Produces the document the user approves and the implementation obeys. Nine
sections, sized to the project: executive summary, requirements mapping,
system, application, database, API, frontend, security and DevOps
architecture, plus a risk register and the restated assumptions.

- Inputs: the specification, the assumption register, the stack decisions.
- Outputs: architecture document, requirements mapping, risk register,
  proposal summary.
- Depends on: engineering-core, requirements-analysis, architecture-design,
  technology-selection.
- Downstream: validation-gate, then delivery-planning.

The requirements mapping is written first: a requirement with no component is
uncovered, a component with no requirement is unnecessary. After approval the
document is the technical contract, and leaving it needs change control.
