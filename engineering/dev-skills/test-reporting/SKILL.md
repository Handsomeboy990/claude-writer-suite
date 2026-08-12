---
name: test-reporting
description: Turns a test campaign into a document someone can act on: the finding record, an honest severity scale, the defect lifecycle through fix and retest, evidence collection and redaction, screenshot and artefact organisation, and the campaign report with its metrics, its passes, its gaps and one verdict. Use whenever testing produces findings, which is every time.
license: MIT
metadata:
  category: dev-skills
  version: 1.0.0
  depends_on: [engineering-core, quality-engineering]
  outputs: [finding-records, severity-ranking, evidence-set, campaign-report, verdict]
---

# Test Reporting

A report exists so that someone decides: ship, fix, or accept. Everything that
does not serve that decision is noise, and everything that hides a risk from it
is a defect in the report.

Two failures are common and both are avoidable: a wall of low value findings
that buries the one that matters, and a summary that says quality is good
without saying what was executed.

## 1. The finding record

Every finding, from every discipline, carries the same fields. A finding
missing `steps` or `evidence` is not reportable yet.

```
ID           stable, referenced everywhere afterwards
Title        the defect, in one line, not the symptom
Severity     from section 2
Category     functional, authorization, data, accessibility, reliability,
             performance, usability, contract, security
Confidence   Confirmed, Potential, Informational
Location     page, endpoint, component, job
Environment  name, base URL, build or commit, role used
Steps        the minimal reproduction, from a clean state
Expected     and why: requirement, contract, convention, sibling behaviour
Actual       observed, not inferred
Frequency    3 of 3, or 2 of 5, as observed
Impact       what it costs the user, the data, or the business
Evidence     screenshot, log line, request, trace, video timestamp
Scope        where else the same code path is used
Fix          proposed, or applied with the reference
Status       open, fixed, retested, accepted, by design, not reproducible
```

## 2. Severity

Severity is about consequence, never about how surprising the defect was or
how long the fix takes.

| Severity | Meaning |
|---|---|
| Critical | data loss or corruption, exposure of data across a boundary, money moved wrongly, a critical flow unusable with no workaround |
| High | a critical flow broken with an awkward workaround, a feature unusable for a whole role, a silent failure the user cannot detect |
| Medium | a secondary feature broken, a defect with a reasonable workaround, a barrier that makes a task hostile but possible |
| Low | cosmetic, rare, or easily avoided, with no effect on data or access |
| Info | an observation, a risk, a question, a note for the next campaign |

The deciding questions are in `resources/severity-scale.md`: what it costs,
how often, to whom, whether a workaround exists, and whether the user can even
tell it happened. A silent failure is always at least High.

Inflation destroys the report. If everything is High, the reader picks by
title, which is worse than no ranking at all.

## 3. Defect lifecycle

```
1  discovered        recorded immediately, with what was known at the time
2  reproduced        from a clean state, with a frequency
3  minimised         the shortest sequence that still produces it
4  located           file and mechanism, through debugging, when fixes are in
                     scope
5  fixed             with a test that failed before the fix
6  retested          the original reproduction, run again, by hand
7  regression        the impact set of the fix, through regression-testing
8  closed            status updated, evidence kept, report updated
```

Steps 6 and 7 are not optional. A defect marked fixed without rerunning its
own reproduction is a defect marked hopefully.

When fixes are out of scope, the lifecycle stops at step 3 and the record says
so. That is a complete result, not an abandoned one.

## 4. Evidence

Collect what supports a conclusion, and nothing else.

```
screenshot        of the state that proves the finding, not of the whole flow
video             only for sequences a still cannot show, kept short
console output    the relevant lines, with the surrounding context
network entry     method, path, status, and the response fields that matter
trace             where the tooling produces one and it aids diagnosis
logs              the correlated request, not the whole file
environment       name, build, browser and version, viewport, role, timestamp
```

Redaction is mandatory and is done before the evidence is saved, never after:

```
no credentials, tokens, cookies or authorization headers
no personal data, real names, addresses, phone numbers or payment details
no customer content from a real account
no internal host names or infrastructure detail beyond what the reader needs
```

Where a value must appear to make the finding intelligible, it is truncated to
the minimum that proves the point.

## 5. Artefacts

A deterministic layout, so a reader finds an image from its reference:

```
evidence/
  <campaign>/
    findings/BUG-14-duplicate-export.png
    findings/BUG-14-network.txt
    accessibility/keyboard-pass-settings.mp4
    responsive/checkout-360.png
    responsive/checkout-1440.png
    passing/invitation-journey.png
    traces/checkout-concurrent.zip
    report.md
```

Rules: the file name contains the finding identifier where one exists, states
are named rather than numbered, and volume is resisted. Two hundred
screenshots nobody opens are not evidence; they are a habit.

## 6. The campaign report

Structure, in this order, because it is the order a reader needs.

```
1  Verdict and why, in three lines or fewer
2  What was tested: scope, environment, build, disciplines, dates
3  Metrics: executed, passed, failed, findings by severity
4  Findings: critical and high in full, the rest as a table
5  What passed: the important things that were verified and work
6  What was not covered, and why
7  Evidence index
8  Recommendation: ship, ship with named risks, fix first, or blocked
```

Section 5 is skipped in most real reports and it is the one that makes the
document trustworthy. A reader who sees only failures cannot tell a thorough
campaign from a shallow one.

Section 6 is not an apology. It is the boundary of what the verdict covers.

## 7. Format

Markdown by default, because it lives in the repository and stays diffable.

HTML when the audience is outside the team and evidence must be embedded:
skeleton in `resources/report-template.md`, self contained, no external
dependency, readable when opened from a file system.

For a document that is delivered as a formal artefact, the presentation rules
belong to the documents tree: `report-writing` for the structure of a report
to a client, `document-design` and `pdf-production` when it is paginated. This
skill owns the content, not the typography.

## 8. Metrics that mean something

```
executed        count, and against what: cases, journeys, endpoints, criteria
passed, failed  same denominator, always stated
findings        by severity, and by status
coverage        of requirements or flows, never a bare code coverage percentage
duration        of the suite, when stability or cost is at issue
stability       consecutive identical runs, when browser tests are involved
```

Never publish a percentage without its denominator, and never present code
coverage as a measure of quality.

## 9. Prohibitions

- Never write `everything works` or `no issues found` without listing what was
  executed.
- Never inflate severity to attract attention, or deflate it to protect a date.
- Never report a finding that was not reproduced without labelling it.
- Never include a secret, a token or real personal data in evidence.
- Never leave a finding as fixed without a retest reference.
- Never delete a finding because it was fixed; mark it fixed, with the proof.
- Never present a subjective preference as a defect.
- Never summarise away a critical finding into a bullet list of minor ones.

## 10. Protocol

1. Open a finding record at the moment of discovery, not at the end.
2. Reproduce, minimise, and attach the minimum evidence, redacted.
3. Assign severity with the questions from the scale, and record the reasoning
   where it is not obvious.
4. Track the lifecycle to its real end, including retest and regression.
5. Assemble the report in the order of section 6.
6. Write the passes and the gaps before writing the verdict.
7. Issue one verdict, with its reason in a sentence.
8. Index the evidence and check every reference resolves.
9. Confirm no secret and no personal data survived into the report.
10. Store what the next campaign needs through `project-continuity`.

## 11. Auto-critique

Score from 0 to 5: completeness of the finding records, severity honesty,
lifecycle followed to retest, evidence sufficiency, redaction, presence of the
passes and the gaps, verdict supported by what is in the document,
reproducibility by another engineer.

Threshold: no axis below 3, average at least 4. A report whose verdict is not
derivable from its own contents scores 0 and is rewritten.

## 12. Interfaces

- Upstream: every testing discipline, `quality-engineering` for the contract
  and the verdict criteria.
- Lateral: `debugging` for root cause, `regression-testing` for the retest
  scope, `report-writing` and `document-design` when the report is a delivered
  document.
- Downstream: `release-readiness` for the go decision, `project-continuity`
  for what the next campaign inherits, `client-handover` when the report ships
  with the product.
