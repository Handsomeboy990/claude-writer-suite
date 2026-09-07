---
name: report-writing
description: Produces reports that support a decision: status reports, project reports, audit and assessment reports, incident and post-mortem reports, analyses and executive summaries. Conclusion first, evidence attributed, recommendation singular, uncertainty stated rather than smoothed. Use when someone must act on what the document says.
license: MIT
metadata:
  category: documentation
  version: 1.0.0
  depends_on: [document-core]
  outputs: [report, executive-summary, findings-table, recommendation]
---

# Report Writing

A report exists because someone has to decide something. If nothing changes as
a result of reading it, it was a newsletter.

Governed by `document-core`. This skill adds the conclusion-first structure,
the separation of fact from inference, and the discipline that keeps a report
from becoming reassurance.

## 1. Before writing

Three questions. Without all three answered, the report has no shape.

```
Who decides, and what are they deciding?
What would change their decision?
When do they need it, and how long will they read?
```

If the answer to the first is nobody, the document is a record, not a report.
Write it as a record, file it, and do not spend a decision-maker's attention
on it.

## 2. Conclusion first

The reader gets the answer in the first paragraph. Everything after supports
it or is annex.

This inverts how the work was done, and that is the point. The reader does not
need your investigation sequence; they need your conclusion and the ability to
check it.

```markdown
## Summary

<The conclusion, in one or two sentences.>

<What it means for the reader, in one or two sentences.>

<The decision required, and by when. If none, say so explicitly.>
```

The summary stands alone. It is the only part a senior reader is guaranteed to
read, and it must survive being forwarded without the rest of the document.

Failure modes:

| Failure | What it produces |
|---|---|
| Chronological narrative | the conclusion on page four, unread |
| Summary that summarises the structure | *this report covers three areas* tells the reader nothing |
| Conclusion hedged into meaninglessness | the reader cannot act, so they ask you to write it again |
| Recommendation absent because the decision felt above your level | you had the evidence; withholding a recommendation is not neutrality |

## 3. Fact, inference, opinion

The three are never mixed in a sentence, and the reader can always tell which
they are reading.

| Category | Standard | Marker |
|---|---|---|
| Fact | observed, measured, cited, reproducible | stated plainly, with its source |
| Inference | derived from facts, with reasoning | *this indicates*, *which suggests*, with the reasoning shown |
| Opinion | professional judgement | *in my assessment*, owned explicitly |
| Unknown | not established | stated as unknown, with what would establish it |

Every figure carries its source and its date. `Response time increased 40
percent` is unusable. `Median response time rose from 180ms to 252ms between
1 June and 15 July, from the application metrics dashboard` can be checked and
acted on.

Never present an inference in the grammar of a fact. It is the most common way
a report misleads while containing nothing false.

## 4. Uncertainty

A report that hides uncertainty is more dangerous than one that admits it,
because it will be acted on with confidence it has not earned.

```
State what is not known.
State what would resolve it, and what that costs.
State the decision's sensitivity: does the recommendation change if the
unknown resolves the other way?
```

That last question is the one that matters. If the recommendation holds either
way, the unknown is noise and can be noted and dismissed. If it does not, the
unknown is the report, and resolving it is the recommendation.

## 5. Report types

### Status report

```
Summary: on track, at risk, or off track, with the reason
Progress since the last report, against what was planned
Deviations: what changed, why, what it costs
Risks: each with likelihood, impact, mitigation, owner
Decisions needed, with deadlines
Next period
```

At risk and off track are stated in the summary, never softened into progress
language. A status report whose only function is reassurance destroys the
value of every subsequent one: once a reader learns that green means nothing,
red arrives too late.

### Audit or assessment report

```
Summary: overall assessment and the single most important finding
Scope: what was examined, what was not, and how
Method: how conclusions were reached, so they can be checked
Findings, ranked by severity, each with evidence and impact
Recommendations, ranked, each with effort and owner
Annexes: the evidence
```

Findings are ranked by severity, never by the order examined. Every finding
carries evidence a reader can verify without you. A finding without evidence
is an opinion, and section 3 requires it to be labelled as one.

### Incident or post-mortem report

```
Summary: what happened, impact, duration, current state
Timeline: detection, response, mitigation, resolution, with timestamps
Impact: who and what was affected, measured
Cause: the actual cause, and the conditions that allowed it
Detection: how it was found, and how long that took
Response: what worked, what did not
Actions: each with an owner and a date
```

Causes are systems and conditions, not people. A report naming an individual
as the cause guarantees the next incident is concealed rather than reported.

`Human error` is never a cause. It is the point at which the analysis stopped.
Continue: what made the error possible, what made it undetected, what made it
recoverable or not.

### Analysis or options report

```
Summary: the recommendation, and the one reason it wins
Question: what is being decided, and the constraints
Options, each with: what it is, cost, effort, risk, what it forecloses
Comparison against the stated criteria
Recommendation: one, with the trade-off accepted stated plainly
What was rejected, and why
```

One recommendation. Presenting three balanced options and no recommendation
returns the work to the person who asked for it, having spent their budget.
The trade-off being accepted is stated: a recommendation with no cost has not
been examined.

## 6. Executive summary

A separate discipline, not a shortened report.

| Rule | Reason |
|---|---|
| One page, hard limit | the second page is not read |
| Conclusion in the first two sentences | it may be the only thing read |
| Numbers with their basis, no unsourced figures | the reader will quote them |
| No jargon, no acronym unexpanded | it will be forwarded outside the team |
| The decision and its deadline, explicit | this is what it is for |
| Survives being forwarded alone | it will be |

Write it last, from the finished report. Written first, it summarises what you
intended to find.

## 7. Protocol

1. Load `document-core`. Answer the three questions in section 1.
2. If nobody decides anything, write a record instead and say so.
3. Gather the evidence. Separate fact, inference, opinion and unknown as you
   go, not afterwards.
4. Verify every figure and attribute every source with its date.
5. Reach the conclusion before drafting. A report drafted while still
   deciding becomes a narrative of your thinking.
6. Choose the type from section 5.
7. Write the body: findings ranked by severity or impact, never chronological.
8. Write the summary last, and test that it stands alone.
9. Apply section 4: state the unknowns, and whether the recommendation is
   sensitive to them.
10. Run the eight-point gate, with the executive, subject matter expert and
    professional editor roles at minimum.
11. Deliver. Where actions have owners and dates, confirm each owner knows.

## 8. Auto-critique

Score 0 to 5: a decision is actually supported, conclusion in the first
paragraph, fact and inference distinguishable in every sentence, every figure
sourced and dated, findings ranked by severity, uncertainty stated with its
sensitivity, one recommendation with its trade-off, actions have owners and
dates, summary stands alone, length matched to the reader's time.

Threshold: no axis below 3, average at least 4. For a report leaving the
organisation or supporting a financial decision, average at least 4.3.

Automatic failure: an unsourced figure, an inference written as a fact, a
status softened to avoid an uncomfortable conversation, or `human error` given
as a cause.

## 9. Interfaces

- Upstream: `document-core`, `project-brief`, `security-audit`,
  `performance-engineering`, `production-verification`.
- Downstream: `document-design`, `pdf-production`, `self-critique`.
- Related: `technical-writing` for reference material rather than decisions.
