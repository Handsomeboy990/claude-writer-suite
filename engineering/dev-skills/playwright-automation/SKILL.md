---
name: playwright-automation
description: Drives a real browser for end to end journeys, visual verification, responsive checks, screenshots, console and network audits and error state proof, through the project test runner or through an interactive browser CLI. Uses role and label based selectors, never brittle ones, and never captures secrets. Use when a change has a browser surface and browser tooling is available or justified.
license: MIT
metadata:
  category: dev-skills
  version: 1.1.0
  depends_on: [engineering-core, testing-quality]
  outputs: [journey-tests, screenshots, responsive-report, visual-evidence, console-audit, network-audit]
---

# Playwright Automation

The browser is the only place where the whole stack is observed at once. This
skill uses it for the small number of checks that only a browser can make, and
for nothing else.

## 1. Availability

| Situation | Action |
|---|---|
| Playwright is configured | use it, follow the existing config and layout |
| another browser runner is configured | use that one, the protocol below still applies |
| no browser tooling, and the change has a critical journey | propose adding it, with the cost, before adding it |
| no browser tooling, and the change is small | skip, and say so in the plan |

The skill degrades gracefully. Its absence never blocks a change, and its
presence never becomes a reason to move unit level assertions into the
browser.

## 2. What belongs in a browser test

```
Yes   critical journeys end to end: sign up, sign in, purchase, invite,
      the two or three paths whose breakage is an incident
Yes   states that only exist in a browser: focus, scroll, viewport, media
Yes   visual verification of a redesign
Yes   proof that an error state renders, not that an error is thrown
No    every field permutation of a form
No    business rules, which belong in unit or integration tests
No    API behaviour, which belongs in contract tests
```

A browser suite that grows past a handful of journeys becomes the slowest and
flakiest part of the pipeline, and the team starts ignoring it.

## 3. Selectors

Ordered preference. Descend only when the level above is impossible.

1. **Role and accessible name.** `getByRole("button", { name: "Invite" })`.
   Fails when the element stops being reachable by assistive technology, which
   is a feature, not a nuisance.
2. **Label.** `getByLabel("Email address")`.
3. **Text.** `getByText`, for content that is genuinely part of the contract.
4. **Test identifier.** A stable attribute, added deliberately, for elements
   with no accessible identity, such as a chart container.

Never: CSS class chains, generated class names, `nth-child`, XPath through the
layout, or any selector that a styling change breaks.

A selector that is hard to write is usually pointing at markup that is hard to
use. Fix the markup.

## 4. Waiting

- Use web first assertions, which retry until a timeout.
- Wait for a condition, never for a duration.
- `waitForTimeout` is banned outside of a documented investigation.
- Wait for the state the user waits for: a row visible, a button enabled, a
  message shown, a URL changed.
- Do not wait on a network request when the visible outcome is the real
  assertion.

## 5. Test structure

```
Isolation      each test creates its own data and does not depend on another
Authentication a stored session state, created once, reused, never a login
               through the UI in every test except the sign in test itself
Data           unique per test run, so parallel workers do not collide
Cleanup        deterministic, or a per test namespace that makes it unnecessary
Determinism    animations disabled, fixed viewport, fixed locale and timezone
```

## 6. Screenshots and visual verification

- Screenshot the element when the element is the subject; screenshot the page
  when the layout is the subject.
- Mask or stub anything that changes between runs: timestamps, avatars,
  random content, live data.
- Compare against a baseline only where the project already keeps baselines,
  and update baselines deliberately, never automatically.
- Documentation screenshots use seeded, obviously fictional data.
- No screenshot ever contains a real token, a real address, a real name, a
  card number, or the contents of a real account.

## 7. Responsive verification

Take the widths from the project configuration, not from a generic list. At
minimum, the narrowest supported width and one wide width.

For each width, check: no horizontal page scroll, no overlapping or clipped
content, navigation reachable, primary action visible without hunting, touch
targets adequate on the narrow width.

## 8. Accessibility in the browser

The browser is where keyboard operability is actually provable.

```
tab through the flow, assert the order matches the visual order
assert focus is visible at each step
open a dialog, assert focus moves inside and is trapped
close with escape, assert focus returns to the trigger
run an automated accessibility scan where the project has one configured
```

An automated scan catches a minority of issues. It is a floor, never a
verdict.

## 9. Driving a browser interactively

Two modes exist, and they answer different questions.

| Mode | Use for |
|---|---|
| the project test runner | permanent journeys, CI, regression |
| an interactive browser CLI | exploration, a QA campaign, reproducing a defect, capturing evidence, debugging a failing test |

The interactive mode is a tool for a session, not a substitute for tests.
Anything worth protecting ends up in the runner.

Before using any command, verify it against the installed tool rather than
from memory: check that the binary exists, read its help output, and take the
flags from there. Command surfaces change between versions, and an invented
flag wastes a session. The verification protocol, the installation sequence
and the capability list are in `resources/playwright-cli-protocol.md`.

Working rules for interactive mode:

```
snapshot first     take an accessibility snapshot and act on the element
                   references it returns, not on coordinates
coordinates last   only for canvas, maps and widgets with no accessible
                   identity, and say so in the notes
verify after       after every interaction, assert the resulting state. A
                   command that returned successfully proves the command ran,
                   not that the application did anything
sessions           use a named or isolated session per role, so two roles can
                   be exercised without signing in and out
credentials        supplied through the environment or a stored state file,
                   never typed into a page that is being recorded
cleanup            close what you opened, and leave no stored session behind
```

## 10. Console and network audit

Both are part of a browser pass, not extras.

Console:

```
collect errors and warnings across every page visited
for each one: origin, whether it reproduces, what it affects
classify: defect, expected noise from a dependency, or deprecation to schedule
a page whose console is clean is worth recording as such
```

Never report every warning as a defect, and never dismiss an error because the
page looked fine. An unhandled rejection with no visible effect today is a
visible effect after the next change.

Network:

```
failed requests, and whether the interface noticed
unexpected 4xx and 5xx, including the ones the interface swallows
duplicate requests for one intent
requests made without credentials that should carry them, and the reverse
oversized payloads and assets that fail to load
redirect chains, and any request to an unexpected host
responses carrying more data than the page displays
```

The last line finds real data exposure: a list endpoint returning fields the
interface never shows.

## 11. Recording and evidence

```
record when the evidence is a sequence, not a state
keep recordings short and chaptered by phase, so a reviewer can skip
capture the failure states, not only the successes
name files by state, not by number
no recording of a page holding real personal data or a real credential
```

Deliberate cursor movement and pauses belong to a demonstration recording.
They have no place in an automated regression run, where the only goals are
determinism and speed.

## 12. Failure diagnosis

On failure, collect the trace, the screenshot and the video where the project
records them, and read them before changing anything. Then apply the flaky
test guide from `testing-quality`.

Diagnosis order for a failing browser test:

```
1 run the single failing test, alone
2 read the assertion that failed, and what it received
3 open the trace or the snapshot at the failing step
4 read the console and the network at that moment
5 decide: application defect, test defect, or environment
6 fix the cause, never the timeout
7 rerun the test, then rerun it a second time
```

Never add a retry to make a browser test pass. Browser flakiness is
disproportionately caused by real races in the application.

## 13. Protocol

1. Confirm the tooling exists, or decide it is justified. Verify the version
   and the available commands rather than assuming them.
2. Choose the journeys, no more than the critical ones.
3. Write each journey with role based selectors and condition based waits.
4. Add the error state and the empty state checks the journey passes through.
5. Verify responsive widths and keyboard operability.
6. Audit the console and the network on every page the journey crosses.
7. Run headed once while developing, headless in the suite.
8. Capture screenshots only where they carry information.
9. Run the suite twice to detect flakiness before it reaches the pipeline.

## 14. Auto-critique

Score from 0 to 5: journeys chosen well and kept few, selector quality, no
duration based waits, isolation, determinism, state verified after every
interaction, console and network audited, screenshot hygiene including absence
of sensitive data, responsive and keyboard coverage, stability across two
consecutive runs.

Threshold: no axis below 3, average at least 4. A single fragile selector or
one `waitForTimeout` sends the work back.

## 15. Interfaces

- Upstream: `frontend-engineering`, `ui-ux-engineering`, `testing-quality`,
  `quality-engineering` when this runs inside a campaign.
- Lateral: `accessibility-testing` for the keyboard and assistive technology
  passes, `exploratory-testing` and `bug-hunting` for what to reproduce,
  `dependency-selection` before introducing browser tooling.
- Downstream: `code-review-protocol`, `technical-documentation` for
  screenshots, `test-reporting` for evidence, `release-readiness`.
