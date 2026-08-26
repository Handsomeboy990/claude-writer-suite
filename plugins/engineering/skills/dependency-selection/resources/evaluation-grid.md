# Evaluation grid

One column per candidate. Every cell holds evidence, not an opinion.

```
Need: format and compare dates across timezones for a scheduling feature

|  | Candidate A | Candidate B | Platform |
|---|---|---|---|
| 1 solves the need | yes, timezone aware | yes, timezone aware | partially, Intl covers formatting, not arithmetic |
| 2 compatibility | ESM, works with the bundler | ESM, works | native |
| 3 maintenance | last release 3 weeks ago, 4 maintainers | last release 14 months ago, 1 maintainer | platform |
| 4 security | no open advisories | no open advisories | platform |
| 5 licence | MIT | MIT | none |
| 6 size | 12 kB minified, tree shakeable | 71 kB, not tree shakeable | 0 |
| 7 transitive | 0 dependencies | 3 dependencies | 0 |
| 8 types | ships types, strict | ships types | native |
| 9 accessibility | n/a, not UI | n/a | n/a |
| 10 documentation | complete, examples for our case | sparse on timezones | good |
| 11 escape cost | low, thin wrapper possible | high, its objects spread everywhere | none |
| 12 alternatives | this grid | this grid | this grid |

Measured
  bundle before 284 kB, with A 296 kB, with B 355 kB
  lockfile diff: A adds 1 package, B adds 4

Decision: Candidate A.
Deciding criterion: 11, escape cost. B's date objects would appear in the
domain model and in stored data, which makes leaving it a data migration.
Escape: A is used behind lib/time.ts, so replacing it touches one file.
```

## Filling the grid honestly

**Criterion 3, maintenance.** Read the release history and the issue tracker.
A single maintainer is not disqualifying by itself; a single maintainer plus
no releases in a year plus open security issues is.

**Criterion 6, size.** Build with and without. Reported package sizes are
frequently wrong for a specific bundler configuration, and tree shaking claims
are frequently untested.

**Criterion 7, transitive tree.** Read the lockfile diff. This is the number
that matters for install time, audit surface and supply chain exposure, and it
is the number the manifest hides.

**Criterion 11, escape cost.** The single most predictive criterion, and the
one least often asked. The question is whether the library's types and objects
leak into the domain model, the database, or the public API. A library used
behind one module is replaceable; a library whose objects are stored is not.

## The platform column

Always present, even when it obviously loses. Filling it forces the question
to be asked, and it wins more often than expected as runtimes gain features.

## When there is only one candidate

Then the grid compares that candidate against writing the code and against
doing nothing. A grid with one column and no alternatives is a decision that
was made before it was evaluated.
