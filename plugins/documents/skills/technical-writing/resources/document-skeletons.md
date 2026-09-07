# Document skeletons

Copy, delete what does not apply, fill. Every skeleton carries a front matter
block, because a technical document with no owner and no date is wrong within
a year and nobody knows when it became wrong.

## Front matter, all types

```markdown
Document:     <title>
Version:      <n>
Date:         <yyyy-mm-dd>
Owner:        <role or team, not a person who may leave>
Applies to:   <system and version range>
Invalidated by: <the event that makes this wrong>
Audience:     <profile>
Status:       draft | current | superseded by <n>
```

## Architecture document

```markdown
# <System> architecture

## 1. Purpose and scope
What this covers. What it deliberately does not.

## 2. Context
What surrounds the system. What it depends on. Who depends on it.

## 3. Components
| Component | Responsibility | Owns | Does not own |

## 4. Data
| Store | Contents | Owner | Retention | Cost of loss |

## 5. Key flows
One subsection per flow. Diagram, then the sequence in words, then the
failure behaviour at each step.

## 6. Decisions
| # | Decision | Alternatives rejected | Reason | Cost accepted |

## 7. Failure behaviour
| Dependency unavailable | Effect | Degradation | Recovery |

## 8. Limits
| Dimension | Current | Limit | Source of the number |

## 9. Open questions
```

## API reference

```markdown
# <API> reference

## Authentication
Complete, with one working example including the header.

## Base URL and versions

## Conventions
Identifiers. Pagination. Dates and time zones. Errors. Idempotency.
Rate limits. Ordering guarantees.

## Operations

### <Operation name>
<One line: what it does.>

Request
```
METHOD /path
```
| Parameter | In | Type | Required | Constraints |

Example request, real.
Example response, real.

Errors
| Status | Meaning | Caller action |

Notes
Side effects. Limits. Whether it is safe to retry.

## Webhooks
Payload. Signature verification, with a code example. Retry policy.
Ordering and duplicate guarantees.

## Changelog
| Version | Date | Change | Breaking |
```

## Installation guide

```markdown
# Installing <system>

## Result
What exists at the end, and the command that proves it.

## Prerequisites
| Requirement | Version | How to check | If missing |

## Procedure
1. <One action.>
   ```
   command
   ```
   Expected:
   ```
   real output
   ```
2. ...

## Configuration
| Variable | Required | Default | Meaning | Effect if wrong |

Never a value. Only the contract.

## Verification
Commands that prove it works, with expected output.

## Common failures
| Symptom | Cause | Fix |

## Rollback
The procedure, or an explicit statement that there is none and what that
implies.
```

## Runbook

```markdown
# <Service> runbook

## What this is
Three lines.

## Where it runs
Environment, region, entry point, dashboard links.

## Health
| Check | Command or URL | Healthy | Unhealthy |

## Alerts
### <Alert name>
Means: <one line>
First command:
```
command
```
Then: <interpretation of each likely output>
Escalate when: <numeric threshold or elapsed time>

## Routine maintenance
| Task | Frequency | Duration | Impact | Procedure |

## Incidents
| Symptom | Diagnosis | Mitigation | Resolution |

## Backups
What, where, retention, last restore rehearsal and its date.

## Dependencies
| Depends on | Effect if down | Depended on by |

## Escalation
| Level | Who | When |
```

## Troubleshooting guide

```markdown
# Troubleshooting <system>

Indexed by symptom, in the reporter's words.

## <Symptom, as reported>
Confirm it is this: <the check that distinguishes it from similar symptoms>
Cause: <what is actually happening>
Resolution:
1. ...
Escalate instead when: <condition>
```

## Process document

```markdown
# <Process name>

## Purpose
## Trigger
## Roles
| Role | Decides | Does |
## Steps
| # | Step | Owner | Input | Output |
## Decision points
| Point | Criteria | Outcomes |
## Exceptions
| Exception | Who authorises | Record kept |
## Artefacts
```
