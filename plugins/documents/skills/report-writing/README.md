# report-writing

Reports that support a decision: status, project, audit and assessment,
incident and post-mortem, analysis and options, executive summaries.

- Inputs: evidence, measurements, findings, and the decision to be made.
- Outputs: report, executive summary, ranked findings, one recommendation.
- Depends on: `document-core`.
- Downstream: `document-design`, `pdf-production`, `self-critique`.

## When to use

Someone must act on what the document says.

## When not to use

Nobody decides anything. Write a record and file it, rather than spending a
decision-maker's attention on it. The skill says this in section 1 and means
it.

## What it enforces

Conclusion in the first paragraph. Fact, inference, opinion and unknown always
distinguishable. Every figure carries its source and date. Findings ranked by
severity, never chronologically. One recommendation, with the trade-off it
accepts. Uncertainty stated along with whether the recommendation is sensitive
to it. `Human error` is never accepted as a cause.

## Configuration

| Field | Effect |
|---|---|
| `language.document_output` | output language |
| `identity.organization` | organisation line on the cover |
| `documents.date_format` | date rendering in the report and its evidence |
