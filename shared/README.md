# shared

Two skills that belong to no single domain and are called by all of them.

Everything else in this repository is specialised: a tree for creative
writing, a tree for professional documents, a tree for software. These two are
not. Framing work before it starts, and reviewing it before calling it
finished, are the same discipline whether the artefact is a chapter, a letter
or a migration.

| Skill | Runs | Produces |
|---|---|---|
| [project-brief](project-brief/) | before the work | the agreement the work is measured against |
| [self-critique](self-critique/) | after the work | the corrected result, and the record of what was found |

They are the two ends of the same loop.

```
project-brief  ->  the work, in whichever tree owns it  ->  self-critique
      |                                                          |
      +--------------- measured against ------------------------+
```

## project-brief

Inspects what already exists, asks the decision-critical questions once in a
single batch, records an assumption for everything it did not ask, and writes
the short agreement that becomes the operational source of truth.

It frames; it does not analyse. For software delivery it hands to
`requirements-analysis` and `clarification-gate`, which go far deeper.

## self-critique

Selects the professional roles that will actually receive the work, runs one
pass per role, checks the result against what was requested, ranks findings by
severity, fixes them, and re-reviews what the fixes touched.

It chooses who looks and enforces the loop; it does not replace the deep
domain reviews. Code goes to `code-review-protocol`, security to
`security-audit`, fiction to `self-critique-protocol`.

Its section 4, the user vision check, belongs to no domain and is therefore
never delegated. No domain reviewer asks whether the user was answered.

## Installation

```bash
bash install.sh --shared      these two only
```

They are also installed with every other scope, because every tree calls them.
A scoped removal such as `--writing --remove` leaves them in place, so
removing one tree never breaks another. Only an unscoped removal or
`--shared --remove` takes them out.

## Configuration

None required. `project-brief` follows `language.document_output` when the
agreement is written for a client.

## Dependencies

Neither depends on anything. Both are usable on their own, in any project,
without installing the rest of the suite.
