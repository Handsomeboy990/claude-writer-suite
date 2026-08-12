---
name: legacy-code
description: Works safely in code that is untested, undocumented or written by people who left: maps it before touching it, finds the seams, adds characterization tests around the change site, makes the smallest possible change, and improves only what the change requires. Use when inheriting a codebase, fixing a defect in unfamiliar code, or resisting a rewrite.
license: MIT
metadata:
  category: dev-skills
  version: 1.0.0
  depends_on: [engineering-core, project-exploration]
  outputs: [system-map, seam-analysis, characterization-tests, change-plan, risk-register]
---

# Legacy Code

Legacy code is code without tests you trust, whatever its age. The difficulty
is never the syntax; it is that nobody can tell you what will break.

The default answer to legacy code is not a rewrite. A rewrite trades a system
with unknown defects for a system with unknown defects and no users.

## 1. Before touching anything

```
run it: build, start, exercise the main flow, and record what actually works
read the entry points, not the whole codebase
map the boundaries: database, network, filesystem, clock, queue, third parties
find the tests that exist and run them, and note which fail today
read the last two hundred commits for the shape of past changes
find the defect reports, the workarounds and the comments that warn
identify what nobody dares to touch, and why
```

`project-exploration` produces the map. This skill decides what to do with it.

## 2. Establish what it does today

Truth comes from execution, never from reading alone.

```
observe the behaviour at the boundary you intend to change
capture real inputs and outputs where you safely can, redacted
write characterization tests: assert what happens, not what should
include the behaviour that looks wrong, marked and unfixed
```

Anything surprising is recorded as a question, not corrected on sight. In
legacy code, the strange branch is usually a customer requirement nobody wrote
down.

## 3. Seams

A seam is a place where behaviour can be changed without editing the code
around it. Finding one is the whole game.

```
parameter        the dependency is already passed in: use it
constructor      inject a double at construction
factory          replace what a factory returns
module boundary  intercept the import or the network call
network          stub at the HTTP or database boundary
configuration    switch behaviour by environment for the test only
subclass         override the method under test, where the language allows
```

When no seam exists, create the smallest one: extract the untestable part into
a function, and inject it. That extraction is itself a refactoring and follows
`refactoring`.

## 4. The change

```
1 make the smallest change that solves the problem
2 keep the local style, even when you dislike it: consistency beats taste
3 leave the surrounding code better only where you already had to read it
4 do not reformat files you did not change: it destroys history and review
5 commit the safety net separately from the change
```

The boy scout rule has a limit in legacy code: cleaning three files around
your fix makes the diff unreviewable and the bisect useless.

## 5. Risk register

Legacy work produces knowledge that must not evaporate:

```
what is undocumented but load bearing
what looks dead and is not, with the evidence
what is genuinely dead, with the evidence
what has no test and cannot get one without a seam
what fails today and has always failed
what depends on a service, version or machine nobody controls
what would break if a common assumption changed: timezone, locale, encoding
```

This goes into the repository through `project-continuity`, not into a message.

## 6. Deciding to rewrite

A rewrite is justified only when all of these hold:

```
the system cannot be changed incrementally, demonstrated by an attempt
the behaviour is understood well enough to reproduce, and written down
there is a way to run both systems and compare their outputs
the migration path exists, including the data
someone will pay for the parallel run and the second migration of edge cases
```

Otherwise: strangle it. Route one capability at a time to new code, keep the
old path until traffic is zero, then delete it. Each step ships and each step
is reversible.

## 7. Prohibitions

- Never change behaviour and structure in one commit here, where nobody can
  reason about the blast radius.
- Never delete code because it looks unused; prove it with usage data first.
- Never fix an unrelated defect discovered mid change; record it.
- Never reformat, reorder imports or upgrade syntax across files you did not
  otherwise touch.
- Never trust a comment over the code, or the code over observed behaviour.
- Never start a rewrite because reading is unpleasant.
- Never leave the system in a half migrated state without a written plan to
  finish.

## 8. Protocol

1. Run the system and record what works today.
2. Map the entry points, the boundaries and the existing tests.
3. Locate the change site and the behaviour it affects.
4. Find or create a seam.
5. Write characterization tests at that seam, green.
6. Make the smallest change, with its own test.
7. Run the characterization tests: anything that changed is either the intent
   or a regression, and you say which.
8. Record the risk register and the questions raised.
9. Hand the structural improvements you did not make to `technical-debt`
   rather than doing them now.

## 9. Auto-critique

Score from 0 to 5: system exercised before editing, seam found rather than
forced, characterization coverage at the change site, minimality of the
change, style consistency, risk register recorded, rewrite resisted or
justified.

Threshold: no axis below 3, average at least 4. A change made in untested
legacy code with no characterization test scores 0 and is reverted.

## 10. Interfaces

- Upstream: `project-exploration` for the map, `debugging` when the entry
  point is a defect.
- Lateral: `refactoring` for the seam extraction, `testing-quality` for the
  characterization tests, `migration-engineering` when the plan is to move off
  the system.
- Downstream: `technical-debt` for what was left, `project-continuity` for the
  risk register, `technical-documentation` for what was learned.
