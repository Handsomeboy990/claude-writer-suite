---
name: refactoring
description: Changes structure without changing behaviour: establishes the behavioural contract first, works in small reversible steps with a green suite between each, separates refactoring commits from behaviour commits, and proves at the end that the observable behaviour is identical. Use when code must be restructured, extracted, renamed, deduplicated or simplified.
license: MIT
metadata:
  category: dev-skills
  version: 1.0.0
  depends_on: [engineering-core, testing-quality]
  outputs: [behaviour-contract, refactoring-steps, equivalence-evidence]
---

# Refactoring

Refactoring is a change in structure with no change in behaviour. The moment
behaviour changes, it is a rewrite wearing the word as a disguise, and it needs
the gates a rewrite needs.

The discipline is not the transformation. It is the ability to prove nothing
moved.

## 1. Entry conditions

```
1 a reason: a change that is hard to make, a defect that keeps returning, a
  duplication that has already caused a divergence
2 a behavioural contract: tests that cover what the code does today
3 a green suite before the first edit
4 a working tree with nothing else in it
```

No reason means no refactoring. Code is not improved because its shape offends
a reader; it is improved because a specific future change is expensive.

## 2. When there is no test

Write characterization tests first: tests that record what the code currently
does, right or wrong.

```
find the observable boundary: the function, the handler, the module edge
capture the current outputs for the inputs that matter, including odd ones
assert them exactly, including the behaviour that looks wrong
mark the ones that look wrong with a comment, and do not fix them here
```

A characterization test asserting a defect is correct: its job is to detect
change, not to endorse behaviour. Fixing the defect is a separate commit,
after the structure is safe.

## 3. Steps

Small, reversible, each ending green.

```
rename                  one symbol at a time, mechanically
extract function        move code, no logic change, call it where it was
inline                  when the indirection earns nothing
move                    to the module that owns the concept
introduce parameter     replace a hidden dependency with a passed one
replace conditional     with a lookup or a polymorphic call, when it repeats
split module            by responsibility, not by file size
deduplicate             only after the third occurrence, and only when the
                        three are genuinely the same thing
```

Run the suite between steps, not at the end of the afternoon. The value of a
small step is that when the suite goes red, the cause is the last thirty
seconds of work.

## 4. Commits

```
one commit per structural step, or per coherent group of them
never mix a behaviour change into a refactoring commit
a behaviour change gets its own commit, its own test, its own review
a commit message that says what moved, not that things are cleaner
```

A reviewer must be able to read a refactoring commit and check that nothing
changed, without reasoning about the feature.

## 5. Proving equivalence

```
the suite is green, and it was green before
the tests were not modified, or every modification is justified and named
coverage of the touched code did not fall
public interfaces are unchanged, or their change is deliberate and versioned
performance did not regress where the code is hot, measured, not assumed
the application still starts and the critical journey still runs
```

If a test had to change to accommodate the refactoring, the refactoring
changed behaviour. Stop and decide which of the two is wrong.

## 6. What is not refactoring

```
changing an error message a client parses
changing a status code
changing the order of side effects
changing what is logged, when something consumes the logs
changing a public signature, a payload or a database column
making something faster by doing less work
```

Each of those is a behaviour change. They may be right, and they go through
the normal gates.

## 7. Knowing when to stop

```
stop when the change that motivated the work is now easy
stop when the next step would require a new abstraction nobody needs yet
stop when the diff exceeds what a reviewer can verify in one sitting
stop when you cannot state the next step in one sentence
```

An unbounded refactoring becomes a rewrite, loses its safety net, and is
abandoned half done. Half refactored code is worse than either end state.

## 8. Prohibitions

- Never refactor without a covering test or a characterization test.
- Never mix behaviour and structure in one commit.
- Never weaken or delete a test to make a refactoring pass.
- Never introduce an abstraction for a second occurrence.
- Never rename across a public boundary without a deprecation path.
- Never refactor on top of uncommitted unrelated work.
- Never leave a refactoring half applied across a codebase.

## 9. Protocol

1. State the reason, in one sentence, and the change it makes cheap.
2. Establish the behavioural contract: existing tests, or characterization
   tests written now.
3. Run the suite and record the green baseline.
4. Perform one small step.
5. Run the suite. Red means undo the step and take a smaller one.
6. Commit the step.
7. Repeat until the motivating change is easy, then stop.
8. Prove equivalence with the checklist of section 5.
9. Make the motivating change, in its own commit, with its own tests.
10. Run the regression selection for the touched surface.

## 10. Auto-critique

Score from 0 to 5: reason stated, contract established before editing, step
size, suite green between steps, commit separation, tests unmodified,
equivalence proven, stopping discipline.

Threshold: no axis below 3, average at least 4. A refactoring whose tests were
edited to keep passing scores 0 on equivalence and is reverted.

## 11. Interfaces

- Upstream: `code-review-protocol` and `technical-debt` for what to refactor,
  `project-exploration` for unread code, `legacy-code` when there is no suite.
- Lateral: `testing-quality` for the characterization tests,
  `architecture-design` when the change crosses a boundary.
- Downstream: `regression-testing` for the re-run selection,
  `performance-engineering` when hot code moved, `git-workflow` for the commit
  discipline.
