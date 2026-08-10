# ui-ux-engineering

Specifies the rendered experience before it is built: design system
extraction, hierarchy decisions, spacing, typography, colour, a ten entry
state inventory per component, interaction rules, motion parameters,
responsive behaviour per breakpoint and measured accessibility targets.

- Inputs: the request, the existing design system, existing screens.
- Outputs: design decisions, state inventory, accessibility targets, motion
  spec.
- Depends on: engineering-core, project-exploration.
- Downstream: frontend-engineering, playwright-automation,
  performance-engineering.

Generated and third party UI is treated as a draft: reviewed for
accessibility, token consistency, dependency cost, maintainability and the
five data states before any of it is committed.
