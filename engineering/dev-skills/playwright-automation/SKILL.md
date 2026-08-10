---
name: playwright-automation
description: Drives a real browser for end to end journeys, visual verification, responsive checks, screenshots and error state proof. Uses role and label based selectors, never brittle ones, and never captures secrets. Use when a change has a browser surface and Playwright is available or justified.
license: MIT
metadata:
  category: dev-skills
  version: 1.0.0
  depends_on: [engineering-core, testing-quality]
  outputs: [journey-tests, screenshots, responsive-report, visual-evidence]
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

## 9. Failure diagnosis

On failure, collect the trace, the screenshot and the video where the project
records them, and read them before changing anything. Then apply the flaky
test guide from `testing-quality`.

Never add a retry to make a browser test pass. Browser flakiness is
disproportionately caused by real races in the application.

## 10. Protocol

1. Confirm the tooling exists, or decide it is justified.
2. Choose the journeys, no more than the critical ones.
3. Write each journey with role based selectors and condition based waits.
4. Add the error state and the empty state checks the journey passes through.
5. Verify responsive widths and keyboard operability.
6. Run headed once while developing, headless in the suite.
7. Capture screenshots only where they carry information.
8. Run the suite twice to detect flakiness before it reaches the pipeline.

## 11. Auto-critique

Score from 0 to 5: journeys chosen well and kept few, selector quality, no
duration based waits, isolation, determinism, screenshot hygiene including
absence of sensitive data, responsive and keyboard coverage, stability across
two consecutive runs.

Threshold: no axis below 3, average at least 4. A single fragile selector or
one `waitForTimeout` sends the work back.

## 12. Interfaces

- Upstream: `frontend-engineering`, `ui-ux-engineering`, `testing-quality`.
- Downstream: `code-review-protocol`, `technical-documentation` for
  screenshots, `release-readiness`.
