# Journey checklist

Applied to every browser test before it enters the suite.

## Scope

- [ ] The journey is critical: its breakage would be an incident.
- [ ] The suite still contains only a handful of journeys.
- [ ] No business rule is asserted here that a unit test could assert.
- [ ] No form permutation is exercised here that a component test covers.

## Selectors

- [ ] Every selector uses role, label, text or a deliberate test identifier.
- [ ] No class chain, no positional selector, no XPath.
- [ ] Ambiguity is resolved by scoping to a container, not by an index.
- [ ] Any element that needed a test identifier genuinely lacks accessible
      identity.

## Waiting

- [ ] No `waitForTimeout` anywhere.
- [ ] Every wait targets a condition the user would also wait for.
- [ ] Web first assertions are used rather than manual polling.
- [ ] No assertion depends on a fixed animation duration.

## Isolation

- [ ] The test creates the data it needs.
- [ ] Data is unique per run so parallel workers do not collide.
- [ ] The test passes when run alone and when run in the suite.
- [ ] The test passes in a shuffled order.
- [ ] Authentication uses stored state, except in the sign in test itself.

## Determinism

- [ ] Animations disabled in the test environment.
- [ ] Viewport fixed and stated.
- [ ] Locale and timezone fixed.
- [ ] Time sensitive content is stubbed or masked.
- [ ] The suite was run twice consecutively with the same result.

## Coverage inside the journey

- [ ] The empty state the journey passes through is asserted.
- [ ] At least one error state is exercised, not only the happy path.
- [ ] A loading state is asserted where it is user visible and stable enough.
- [ ] The post action state is asserted, not just the absence of an error.

## Accessibility

- [ ] Tab order matches the visual order through the flow.
- [ ] Focus is visible at each step.
- [ ] Dialog focus is trapped, escape closes, focus returns to the trigger.
- [ ] An automated scan runs where the project has one configured.

## Responsive

- [ ] The narrowest supported width is checked.
- [ ] One wide width is checked.
- [ ] No horizontal page scroll at either width.
- [ ] The primary action is reachable without hunting at the narrow width.

## Screenshots

- [ ] Each screenshot carries information nobody could get from the assertion.
- [ ] Volatile content is masked or stubbed.
- [ ] No real name, address, token, key or card number is visible.
- [ ] Baselines are updated deliberately, with the visual change reviewed.
