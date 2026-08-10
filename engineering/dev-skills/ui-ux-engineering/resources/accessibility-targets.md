# Accessibility targets

Targets are numbers and behaviours, verified, not intentions.

## Contrast

Measured with a tool, never judged by eye. The project states its target
level; these are the standard thresholds.

| Content | Ratio |
|---|---|
| body text | 4.5 to 1 |
| large text, 24px or 19px bold and above | 3 to 1 |
| interactive element boundaries and icons | 3 to 1 |
| focus indicator against both the component and the background | 3 to 1 |
| disabled content | exempt, but must not be the only signal |

Checked on both themes. A palette that passes on light and fails on dark has
failed.

## Keyboard

- [ ] Every interactive element is reachable by Tab.
- [ ] Tab order matches the visual order.
- [ ] No keyboard trap except a deliberate modal trap.
- [ ] Enter and Space activate buttons; Enter follows links.
- [ ] Escape closes dialogs, popovers and menus.
- [ ] Arrow keys move within composite widgets: menus, tabs, listboxes.
- [ ] Focus is visible at every step, on both themes.
- [ ] Focus moves into a dialog on open and returns to the trigger on close.
- [ ] Focus is managed on route change so the next Tab is not from the top.
- [ ] A skip link exists where the navigation is long.

## Semantics

- [ ] A button is a `button`, a link is an `a` with an `href`.
- [ ] Headings are ordered and describe structure, not chosen for size.
- [ ] Landmarks exist: header, nav, main, footer.
- [ ] Lists are lists, tables are tables with headers and a caption or
      accessible name.
- [ ] Form controls have programmatically associated labels.
- [ ] Required and invalid states are conveyed programmatically, not only in
      colour.
- [ ] Error messages are associated with their field.
- [ ] Icon only controls have an accessible name.
- [ ] Images have alternative text, empty for decorative ones.

## Announcements

- [ ] Asynchronous results that matter are announced through a live region.
- [ ] The live region politeness matches the urgency: polite for status,
      assertive for errors that block.
- [ ] Announcements are not duplicated by both a live region and a focus move.
- [ ] Loading is announced when it lasts long enough to matter.

## Motion and sensory

- [ ] `prefers-reduced-motion` is honoured, and the reduced version still
      communicates the state change.
- [ ] Nothing flashes more than three times per second.
- [ ] No meaning is carried by colour alone.
- [ ] No meaning is carried by position alone in a linearised reading order.
- [ ] Autoplaying motion can be paused.

## Targets and pointer

- [ ] Touch targets meet the project's minimum, with spacing between them.
- [ ] No functionality requires hover or a precise gesture without an
      alternative.
- [ ] Drag operations have a non drag alternative.

## Verification

```
1 Automated scan on the changed pages. It catches a minority of issues.
   Passing it is the floor, not the verdict.
2 Keyboard only pass through the whole flow.
3 Contrast measured on the new tokens, both themes.
4 Screen reader pass on the primary flow where the project has that
   capability; where it does not, say so rather than implying it was done.
```
