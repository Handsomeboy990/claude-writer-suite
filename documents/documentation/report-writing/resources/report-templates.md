# Report templates

## Status report

```markdown
# <Project> status, <period>

**Status: on track | at risk | off track**

<One sentence: why that status.>
<One sentence: what the reader must do, or that nothing is needed.>

## Progress
| Planned this period | Delivered | Evidence |
|---|---|---|

## Deviations
| What changed | Why | Impact on scope, date or cost |
|---|---|---|

## Risks
| Risk | Likelihood | Impact | Mitigation | Owner |
|---|---|---|---|---|

## Decisions needed
| # | Decision | Options | Needed by | Blocked if late |
|---|---|---|---|---|

## Next period
```

At risk and off track appear in the status line, never only in the body.

## Audit report

```markdown
# <Subject> audit

## Summary
<Overall assessment. The single most important finding. The decision required.>

| Severity | Count |
|---|---|
| Critical | |
| High | |
| Medium | |
| Low | |

## Scope
Examined: <what>
Not examined: <what, and why; this section prevents false assurance>
Period: <dates>
Method: <how, so a reader can check the conclusions>

## Findings

### F1. <Title> [Critical]
Observed: <the fact, with evidence a reader can verify>
Evidence: <location, log, measurement, reference, date>
Impact: <what it allows or costs, concretely>
Recommendation: <action>
Effort: <estimate>
Owner: <role>

## Recommendations, ranked
| # | Action | Addresses | Effort | Owner | By |
|---|---|---|---|---|---|

## Annexes
<The evidence, in full.>
```

## Incident report

```markdown
# Incident <reference>, <date>

## Summary
What happened, who was affected, for how long, current state.

| Item | Value |
|---|---|
| Detected | <timestamp, and by what> |
| Mitigated | <timestamp> |
| Resolved | <timestamp> |
| Duration of impact | |
| Users affected | <number, and how it was counted> |
| Data lost | <yes or no, and what> |

## Timeline
| Time | Event | Source |
|---|---|---|

## Impact
Measured, not estimated. Say so where it is estimated.

## Cause
The condition that produced the failure, and the conditions that allowed it to
reach production undetected. Not a person.

## Detection
How it was found. How long that took. Why it was not found sooner.

## Response
What worked. What did not. What was missing when it was needed.

## Actions
| # | Action | Prevents | Owner | By | Status |
|---|---|---|---|---|---|
```

Actions without an owner and a date are not actions.

## Options report

```markdown
# <Decision>

## Summary
Recommendation: <option>. <The one reason it wins.>
Trade-off accepted: <what this costs>.
Decision needed by <date>.

## The question
What is being decided. Constraints. Criteria, in priority order.

## Options
### Option A: <name>
What it is. Cost. Effort. Risk. What it forecloses.

## Comparison
| Criterion | Weight | A | B | C |
|---|---|---|---|---|

## Recommendation
One option. The trade-off, stated. What would change this recommendation.

## Rejected
| Option | Why not |
|---|---|
```

## Executive summary

```markdown
# <Subject>: executive summary

<Conclusion, first two sentences.>

<What it means, in business terms.>

**Decision required:** <what, by when, by whom.>

| Key figure | Value | Source |
|---|---|---|

**Options:** <one line each, cost stated.>

**Recommendation:** <one, with its trade-off.>

**If no decision is taken:** <the consequence of delay.>
```

One page. Written last. Tested by reading it alone, with the report removed.

## The sourcing rule

Every number in every template carries where it came from and when.

| Written | Usable |
|---|---|
| Costs rose significantly | Monthly infrastructure cost rose from 4,100 to 6,350 euro between March and July, from the provider invoices |
| Most users are affected | 12,400 of 41,000 active accounts, 30 percent, counted from the error log for 3 to 10 August |
| Performance degraded | Median response rose from 180ms to 252ms, 1 June to 15 July, application metrics |

The left column cannot be checked, cannot be acted on, and will be quoted
anyway.
