---
name: exploratory-testing
description: Uses the application the way a real person would, under a written charter and a time box, to find the defects scripted tests cannot see: dead ends, lost state, missing feedback, confusing validation, broken back navigation, incomplete features and unusable flows. Produces reproducible findings, never impressions. Use whenever a human facing surface must be judged, not merely executed.
license: MIT
metadata:
  category: dev-skills
  version: 1.0.0
  depends_on: [engineering-core, quality-engineering]
  outputs: [charters, session-notes, findings, reproduction-steps, usability-observations]
---

# Exploratory Testing

A scripted test can only fail in the way it was written to fail. Exploratory
testing exists to find everything else: the flow that works and is unusable,
the state that survives a reload it should not, the error message that tells
the user nothing, the feature that stops halfway.

It is not clicking around. It is designed exploration under a charter, with
notes, producing findings another person can reproduce.

## 1. The charter

Every session has one, written before it starts, in one sentence.

```
Explore <area> with <resources> to discover <information>.
```

```
Explore the invitation flow with two roles to discover what happens when the
same address is invited twice.

Explore the dashboard with an account holding no data to discover whether a
first time user can reach a useful state.

Explore the checkout with a slow network to discover what the user sees while
payment is in flight.
```

A charter names a target and a question. `test the app` is not a charter, and
a session without one produces anecdotes.

## 2. Time box

Sixty minutes at most, forty is usually better. When the box ends, the session
ends and the notes are written, whether or not the area feels finished. An
unfinished area becomes the next charter.

The time box exists because attention decays and because an open ended session
silently becomes a demonstration of the happy path.

## 3. Tours

A tour is a lens. Pick two or three per session, not all of them. The full
catalogue is in `resources/tour-catalogue.md`.

| Tour | The question it asks |
|---|---|
| newcomer | can someone arriving with no data and no training get to value |
| landmark | can every advertised feature be reached from the front door |
| back roads | what happens in the parts nobody demos: settings, exports, admin |
| interruption | reload, back, forward, second tab, session expiry, logout mid task |
| obsessive | do the same thing repeatedly, quickly, and out of order |
| money | anything with a price, a quantity, a quota or a limit |
| supporting actor | the empty state, the loading state, the error state, the disabled state |
| antisocial | give the interface what it did not expect, within the contract |
| continuity | leave an operation half done, come back tomorrow |

## 4. What is being looked for

```
dead ends: a page with no way forward and no way back
lost work: input discarded by a validation error, a reload, a back navigation
state that persists when it should not, and state that vanishes when it should not
actions with no feedback: nothing moved, nothing said, nothing changed
feedback that lies: a success message for an operation that failed
navigation that breaks: back returns to a stale page, a link reloads the app
duplicate effects from one intent
empty states that explain nothing
error messages that name a technology instead of a problem
features that exist in the interface and not in the system
flows that require knowledge the interface never gave the user
```

## 5. Usability is a finding, not an opinion

An observation becomes a finding when it is attached to behaviour that can be
reproduced. Keep the two apart:

```
Opinion   the dashboard feels cluttered
Finding   the primary action on the dashboard is below the fold at 1366x768,
          and three testers used the secondary action first
```

The questions that produce findings rather than opinions are in
`resources/usability-questions.md`. Each one ends in an observable fact:
what the user did, what the system did, what the user then believed.

## 6. Notes, written during the session

Notes are taken while testing, not reconstructed afterwards. Minimum per
finding:

```
what I did          the exact sequence, from a known starting state
what I expected     and why: the requirement, the convention, the other screen
what happened       observed, not inferred
evidence            screenshot, console line, network entry, URL
reproducible        yes, no, or intermittent with the ratio observed
```

Anything not reproducible is recorded as intermittent with the number of
attempts, never silently dropped and never reported as certain.

## 7. When a finding is found

Stop. Reproduce it from a clean state before continuing, because a finding
discovered in a messy session and not reproduced will be argued away later.

Then decide whether to follow it or note it and return to the charter.
Following one interesting defect for the whole hour is how the rest of the
area stays untested.

## 8. Prohibitions

- Never report a finding that was not reproduced, without saying so.
- Never fix while exploring: the session becomes a repair job and the area
  stays unexplored. Findings go to the report, fixes happen after.
- Never explore production with real user data unless the contract authorises
  it explicitly.
- Never use real personal data, real cards or real addresses as test input.
- Never treat an unfamiliar behaviour as a defect before checking the
  requirement; unexpected is not the same as wrong.
- Never let the session drift into the happy path because it is comfortable.

## 9. Protocol

1. Read the contract from `quality-engineering` and take the area assigned.
2. Write the charter and set the time box.
3. Pick two or three tours.
4. Establish a known starting state: which account, which role, which data.
5. Explore, taking notes as you go, not afterwards.
6. Reproduce each finding from the clean state before moving on.
7. Close the box, write the session notes, rank the findings by consequence.
8. Hand the findings to `test-reporting`, and the reproducible ones that
   deserve permanent protection to `testing-quality`.
9. Propose the next charter from what was left unexplored.

## 10. Auto-critique

Score from 0 to 5: charter quality, coverage of the area within the box, tour
variety, reproduction of findings, separation of opinion from finding,
evidence attached, honesty about what was not reached.

Threshold: no axis below 3, average at least 4. A session that produced only
happy path confirmation scores 0 on coverage and is rerun with a sharper
charter.

## 11. Interfaces

- Upstream: `quality-engineering` for the contract and the area,
  `project-exploration` for what the surface contains.
- Lateral: `bug-hunting` for the systematic adversarial pass,
  `accessibility-testing` for keyboard and assistive technology,
  `ui-ux-engineering` for what the experience was supposed to be.
- Downstream: `test-reporting` for the findings, `testing-quality` to turn a
  reproducible finding into a permanent test, `debugging` for root cause.
