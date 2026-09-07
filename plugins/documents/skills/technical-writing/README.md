# technical-writing

Standalone technical and developer deliverables for a competent reader who has
never seen the system: architecture documents, API and integration references,
installation and configuration guides, operational and maintenance
documentation, troubleshooting guides, process documents.

- Inputs: the system, its source, its operators, the audience profile.
- Outputs: the document, a verification log, a list of marked gaps.
- Depends on: `document-core`.
- Downstream: `document-design`, `pdf-production`, `self-critique`.

## When to use

The document is handed to someone and versioned as a deliverable.

## When not to use

The document lives in the codebase and should change in the same commit as the
code. That is `technical-documentation` in the engineering tree. The test is
ownership, not subject.

## What it enforces

Every command is run before it is written. Every example is a real request and
a real response. Every failure mode is documented alongside its success case.
Unverifiable facts are marked as gaps with an owner, never filled with
plausible text.

## Configuration

| Field | Effect |
|---|---|
| `language.documentation` | default output language |
