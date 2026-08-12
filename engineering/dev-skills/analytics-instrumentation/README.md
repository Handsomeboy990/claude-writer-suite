# analytics-instrumentation

Designs product measurement before any event is emitted: the questions the
data must answer, a typed event schema, identity without personal data,
funnels and metric definitions in one register, consent and minimisation,
pipeline validation, and deprecation of events nobody reads.

- Inputs: the decisions the data must inform, the product surfaces, the
  consent model, the privacy inventory.
- Outputs: measurement plan, event schema, tracking implementation, validation
  rules, event register.
- Depends on: engineering-core, data-privacy.
- Lateral: frontend-engineering, backend-engineering, feature-flags,
  observability.
- Downstream: testing-quality, technical-documentation, data-privacy.

An event with no question behind it is cost. Anything that becomes a business
figure is emitted server side, and an email address is never an analytics
identifier.
