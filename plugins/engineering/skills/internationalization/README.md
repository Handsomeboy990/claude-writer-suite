# internationalization

Prepares a product for more than one language and region: locale model,
externalised strings with stable keys, plurals and gender through a message
format, locale aware numbers, dates and currencies, timezone correctness,
right to left layout, negotiation and persistence, and the translation
workflow.

- Inputs: the locales in scope, the interface and its strings, the documents
  and mails, the regional rules.
- Outputs: locale model, message catalogue, formatting rules, translation
  workflow, RTL plan.
- Depends on: engineering-core, frontend-engineering.
- Lateral: ui-ux-engineering, design-system, seo-engineering,
  backend-engineering.
- Downstream: testing-quality, accessibility-testing,
  technical-documentation.

Locale is not language: a price, a date format and a legal notice can differ
between two regions sharing one. Sentences are never assembled from translated
fragments, because word order is not universal.
