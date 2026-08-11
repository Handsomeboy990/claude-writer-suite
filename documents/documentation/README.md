# documentation

Four skills. The constitution of the `documents/` tree, and the three writing
skills separated by who reads them.

| Skill | Reader | Opens with |
|---|---|---|
| [document-core](document-core/) | the other skills | the audience model |
| [technical-writing](technical-writing/) | someone who can run commands | a working example |
| [user-documentation](user-documentation/) | someone who wants to finish a task | the task, by name |
| [report-writing](report-writing/) | someone who must decide | the conclusion |

## document-core

Loaded first, always. Carries the audience model, the separation of skill
language from output language, the evidence rule, the shared style standard
and the eight-point quality gate. The other three refer to it rather than
restating it.

## Which of the three

The split is by reader, never by subject. The same system produces a technical
reference, a user manual and an assessment report, and none of them can be
derived from another.

| Question the reader has | Skill |
|---|---|
| How do I integrate with this | `technical-writing` |
| How do I install and operate this | `technical-writing` |
| Why is it built this way | `technical-writing`, architecture document |
| How do I change my delivery address | `user-documentation` |
| A customer is asking me why their refund is late | `user-documentation`, support-facing |
| Should we migrate, and what does it cost | `report-writing` |
| What happened during the outage | `report-writing`, incident report |
| Is the project on track | `report-writing`, status report |

A document with two of these readers is two documents. The only sound
compromise is a layered one: a first page that stands alone for the less
technical reader, and depth after it, never interleaved.

## What each enforces

**technical-writing.** Every command run on a clean environment before it is
written. Every example a real request and a real response. Every success case
accompanied by its failure case.

**user-documentation.** Articles titled after tasks the reader could have
searched for. One action per step, with what they see afterwards. Error
messages quoted exactly. `simply`, `just` and `easily` banned.

**report-writing.** Conclusion in the first paragraph. Fact, inference,
opinion and unknown always distinguishable. Every figure with its source and
date. One recommendation, with the trade-off it accepts.

## Order

```
document-core -> one of the three -> document-design -> pdf-production
```

## Related

`engineering/dev-skills/technical-documentation` owns documentation that lives
in a codebase and changes in the same commit as the code. The test is
ownership, not subject.
