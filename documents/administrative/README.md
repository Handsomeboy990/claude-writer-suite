# administrative

One skill, deliberately. Formal and institutional documents are a distinct
discipline from technical documentation, and merging them produces a letter no
administration accepts and a manual no engineer can use.

| Skill | Produces |
|---|---|
| [administrative-writing](administrative-writing/) | letters, official correspondence, requests, notices, attestations, memoranda, meeting minutes, formal statements, application documents |

## Why one skill and not five

The document types differ in their required elements, not in their method.
Recipient, references, subject, four-movement body, closing, signature,
attachments: the same discipline every time. The variation lives in
`resources/letter-conventions.md` and in section 6 of the skill, which is
where variation belongs.

Splitting this into five skills would produce five copies of the same
evidence rule and the same register table, which would then drift.

## What makes this category different

These documents are filed by their recipient, quoted back, and occasionally
produced years later in a dispute. Two consequences run through the skill:

**The evidence rule is absolute.** No statute, article, registration number,
licence, institution, title, amount or prior exchange is written unless it was
taken from a source in front of you. A plausible article number in a formal
letter is quoted back and found wrong by the recipient rather than by you.

**Gaps are marked, never filled.** Missing elements appear in the delivered
draft as visible markers with what is needed and who holds it. Anything
touching legal effect or entitlement is marked for a qualified human.

The delivery threshold is raised accordingly: average at least 4.3, against 4
elsewhere in the suite.

## Limitations

This skill drafts. It does not advise. It will structure a letter around a
legal question and mark the question, rather than answer it.

## Configuration

| Field | Effect |
|---|---|
| `language.document_output` | output language, set to the recipient's |
| `identity.author_name` | signature block |
| `identity.organization` | letterhead |
| `documents.date_format` | overridden by the recipient's country convention |
