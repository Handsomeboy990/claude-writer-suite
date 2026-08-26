# exploratory-testing

Designed exploration under a written charter and a time box. Uses the product
as a person would, through a small set of tours, and turns what it finds into
reproducible findings with evidence rather than impressions.

- Inputs: the testing contract, the area assigned, a known account and role.
- Outputs: charters, session notes, findings with reproduction steps,
  usability observations attached to observable behaviour.
- Depends on: engineering-core, quality-engineering.
- Lateral: bug-hunting, accessibility-testing, ui-ux-engineering.
- Downstream: test-reporting, testing-quality, debugging.

A finding is reproduced from a clean state before it is reported. An
observation that cannot be attached to behaviour is labelled an opinion and
kept out of the defect list.
