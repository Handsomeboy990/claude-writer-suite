# test-reporting

Turns a campaign into a document someone can act on: finding records, an
honest severity scale, the defect lifecycle through fix and retest, evidence
collection and redaction, artefact organisation, and one verdict.

- Inputs: findings from every discipline, the testing contract, the evidence
  collected during the campaign.
- Outputs: finding records, severity ranking, evidence set, campaign report,
  verdict.
- Depends on: engineering-core, quality-engineering.
- Lateral: debugging, regression-testing, report-writing, document-design.
- Downstream: release-readiness, project-continuity, client-handover.

The report names what passed and what was not covered, not only what failed.
No secret and no personal data reaches the evidence set, and redaction happens
before an artefact is saved.
