---
name: technical-documentation
description: Writes documentation that matches the implementation: readme, setup, architecture, API reference, runbooks, decision records and changelog, updated in the same change as the code. Forbids documenting behaviour that does not exist. Use whenever behaviour, contracts or setup change.
license: MIT
metadata:
  category: dev-skills
  version: 1.0.0
  depends_on: [engineering-core, project-exploration]
  outputs: [readme, api-reference, setup-guide, runbook, decision-record, changelog-entry]
---

# Technical Documentation

Documentation is part of the change, not a follow up task. Wrong documentation
is worse than none, because it is trusted.

## 1. The rule

Every statement describes the code as it exists at this revision. Nothing
describes an intention, a plan, or a behaviour that was removed.

Before writing a line, read the code that the line describes. Documentation
written from memory of the design is the primary source of documentation that
lies.

## 2. What to write, and when

| Change | Documentation |
|---|---|
| new endpoint or contract change | API reference, in the same commit |
| new environment variable | setup guide and the example environment file |
| new dependency with setup steps | setup guide |
| new subsystem or boundary | architecture note, decision record |
| new operational failure mode | runbook entry |
| user visible behaviour change | changelog entry |
| new command or script | readme |
| a decision that was expensive to make | decision record |
| an internal refactor with no external effect | usually nothing |

The last row matters. Documenting an internal change that no reader needs
produces noise that hides the entries that do matter.

## 3. Audiences

Write for one, and say which.

| Document | Reader | Question it answers |
|---|---|---|
| readme | someone arriving today | what is this, how do I run it |
| setup guide | someone with an empty machine | how do I get it working |
| architecture | someone about to change it | where does what live, and why |
| API reference | someone calling it | what do I send, what comes back, what fails |
| runbook | someone woken at three in the morning | it is broken, what do I do |
| decision record | someone questioning a choice | why is it this way, what did it cost |
| changelog | someone upgrading | what changed for me |

A document that serves two readers serves neither.

## 4. Standards per document

**Readme.** What the project is, in two sentences. How to run it. How to test
it. Where the deeper documentation is. Nothing else; a readme that grows into
a manual stops being read.

**Setup guide.** Every step, in order, from an empty machine. Every
prerequisite with its version. Every environment variable with what it is for,
whether it is required, and where to obtain it, never with its value. A
verification step at the end that proves the setup worked.

**Architecture.** The shape that exists. Which module owns which behaviour and
which data. The dependency direction. Where the failure paths are. Kept short
enough to stay true.

**API reference.** Per endpoint: method, path, authentication, request shape,
response shape, every error with its status and code, and a working example.
Generated from the schema where the project can generate it, because generated
references cannot drift.

**Runbook.** Per failure mode: how it presents, how to confirm it, what to do,
what to check afterwards, whom to inform. Written in the imperative, so it can
be followed by someone who is tired.

**Decision record.** Context with forces, options with honest advantages,
decision, consequences including the negative ones, reversal cost. Immutable
once accepted; superseded by a new record.

**Changelog.** User visible changes, grouped, newest first. Breaking changes
first within their release, with the migration step. Not a commit log.

## 5. Writing rules

- Present tense, active voice, second person for instructions.
- Every command is copy pasteable and was executed.
- Every example is real and was run.
- No placeholder left unresolved.
- No secret, no real credential, no real personal data in an example.
- Code examples compile against the current code.
- Link to the code rather than duplicating it; duplicated code in
  documentation is guaranteed to drift.
- Say what does not work as well as what does. A known limitation stated is
  worth more than a paragraph of description.
- No emoji, no em dash, per the repository constitution.

## 6. Prohibitions

- Never document a planned feature as existing.
- Never leave documentation describing a removed behaviour.
- Never copy a code block that will change without a way to notice.
- Never write a setup step that was not executed on a clean state.
- Never document an API from the handler's intention instead of its code.
- Never expand a readme into a manual.
- Never write a changelog entry that only repeats a commit message.

## 7. Verification

Before the documentation change is committed:

```
Setup steps      followed on a clean state, or the divergence stated
Commands         executed, output matches what is described
API examples     called, response matches what is documented
Links            resolved, no broken reference
Variables        every one listed exists in the code, and every one in the
                 code is listed
Removed          documentation for removed behaviour deleted in this change
```

The last check is the one that keeps documentation trustworthy over years.

## 8. Protocol

1. Determine which documents the change affects, from section 2.
2. Read the code the documentation will describe.
3. Update or write the document for its single audience.
4. Run every command and example.
5. Delete documentation for anything the change removed.
6. Verify with section 7.
7. Commit as `docs:`, separately when the change is documentation only.

## 9. Auto-critique

Score from 0 to 5: accuracy against the code, single audience per document,
commands and examples actually executed, completeness of environment variables
and errors, removal of stale content, absence of secrets, conciseness.

Threshold: no axis below 3, average at least 4. One statement that does not
match the code is an automatic failure, because it destroys trust in the rest.

## 10. Interfaces

- Upstream: every implementation skill, `architecture-design` for decision
  records, `playwright-automation` for screenshots.
- Downstream: `project-continuity`, `release-readiness`, `git-workflow`.
