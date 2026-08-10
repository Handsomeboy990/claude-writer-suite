# Handover package template

Sections that do not apply are removed, not filled with `n/a`. A handover is
read once, by someone deciding whether they can own this.

````markdown
# <project>, handover

Version: <the released version>
Date:
Prepared for: <the client, and the maintaining team>

---

# Part one, for the product owner

## What this system does

<one paragraph, no technical vocabulary>

## Features as built

| Feature | State | Notes |
|---|---|---|

Differences from the original specification:
| Specified | Delivered | Why |
|---|---|---|

## What it does not do

| Limitation | Consequence | Trigger to address |
|---|---|---|

## Recurring cost

| Item | Monthly | Scales with |
|---|---|---|

## Administration

<how to perform the privileged tasks: create a user, grant a role, correct
data, export, close an account>

## Support

Covered: <what>
Not covered: <what>
Until: <when>
Contact: <who, how>

---

# Part two, for the maintaining engineer

## Architecture

<three lines, then a link to docs/architecture/>

## Stack

| Layer | Technology | Version | Decision record |
|---|---|---|---|

## Installation

Prerequisites:
- <tool, version>

```bash
<every command, in order, executed on a clean machine before writing>
```

Verification:
```bash
<the command that proves it works>
```
Expected: <what a healthy result looks like>

## Configuration

| Variable | Purpose | Required | Format | Source |
|---|---|---|---|---|

Values are never in this document. They come from <the client's vault or
console>.

Rotation:
| Secret | How to rotate | What must restart |
|---|---|---|

## Development

```bash
<run, test, lint, typecheck, build>
```

Conventions: <link to the contribution guide or the architecture document>
Adding a feature: <the path through the codebase, in five lines>

## Testing

| Layer | Framework | Command | Covers |
|---|---|---|---|

Not covered, deliberately:
- <what, and why>

## Deployment

How a change reaches production:
1.

Rollback:
1.
Does not restore: <sent mail, moved money, dropped data>

## Operations runbook

### <failure mode>

Presents as:
Confirm:
Act:
1.
Afterwards:
Escalate:

## Follow ups

| # | What | Effort | Recommended |
|---|---|---|---|

## Known open items

| # | What | Why it is open | Blocker |
|---|---|---|---|
````

## Rules

**Two parts, not one.** A product owner reading module boundaries stops
reading. An engineer reading a feature tour skips to the commands and misses
the configuration section.

**Features as built.** Build the table by exercising the running system, not
by copying the specification. Where they differ, the difference table is the
most important content in the package.

**Installation from zero.** Executed on a clean machine, or a clean container,
before it is written. A guide that starts from a state the author already had
is the most common defect in a handover.

**Variables in both directions.** Every variable the code reads is
documented, and every documented variable exists in the code. Checking one
direction leaves either an undocumented requirement or a stale instruction.

**Limitations with triggers.** `The course list is not paginated` is an
apology. `The course list is not paginated, which is slow above roughly 500
courses; address it when the catalogue passes 300` is a plan.

**No values, ever.** Not in the document, not in an example, not in a
screenshot. The format of a token is documentation; the token is a leak.
