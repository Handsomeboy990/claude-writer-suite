# legacy-code

Works safely in code nobody trusts: run it before reading it, map the
boundaries, find a seam, write characterization tests at the change site, make
the smallest change, and record what was learned.

- Inputs: the inherited codebase, the change or defect that brought you here.
- Outputs: system map, seam analysis, characterization tests, change plan,
  risk register.
- Depends on: engineering-core, project-exploration.
- Lateral: refactoring, testing-quality, migration-engineering, debugging.
- Downstream: technical-debt, project-continuity, technical-documentation.

Legacy means untested, not old. The default answer is not a rewrite: a rewrite
trades known defects for unknown ones and loses every undocumented requirement
the old code encodes.
