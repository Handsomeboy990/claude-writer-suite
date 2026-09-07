# Keyboard pass sheet

One sheet per flow. No mouse is touched from the first line to the last. The
mouse is unplugged, or the hand stays off it; there is no third option.

## Setup

```
flow          <name>
pages         <the pages the flow crosses>
browser       <name and version>
zoom          100 percent for the first run, 200 percent for the second
starting URL  <url>
```

## The walk

For each step, record: the key pressed, where focus landed, whether the
indicator was visible, and what the interface did.

```
step  key      focus landed on               visible  result
1     Tab      skip to content link          yes      correct
2     Enter    main region                   yes      correct
3     Tab      search input                  yes      correct
4     Tab      results filter, custom select yes      correct
5     Space    filter opens                  yes      correct
6     Down     second option                 yes      correct
7     Enter    filter applies, focus lost    NO       FINDING A11Y-03
...
```

## Questions answered by the walk

```
1  Is every interactive element reachable by Tab, in a sensible order?
2  Is the focus indicator visible on every one, including custom controls
   and elements over a coloured background?
3  Does Shift+Tab walk back through the same path?
4  Does Enter activate links and buttons, and Space activate buttons?
5  Do arrow keys work where the role implies them: menus, tabs, radio groups,
   listboxes, sliders?
6  Does Escape close menus, dialogs and popovers?
7  After closing, does focus return to the element that opened it?
8  Is there a way past repeated navigation, such as a skip link?
9  Does anything trap focus outside a dialog?
10 Does focus ever land on a hidden element, or leave the viewport with no
   scroll?
11 After an async update, is focus preserved or moved deliberately?
12 Can the entire flow be completed, start to finish, with no mouse?
```

Question 12 is the result. Everything else explains it.

## Common defects and what they actually break

| Defect | Consequence |
|---|---|
| `div` with a click handler | unreachable, invisible to assistive technology |
| `outline: none` with no replacement | reachable but invisible, the user is lost |
| positive `tabindex` | order diverges from the visual order across the page |
| focus not moved into an opened dialog | the user keeps interacting with the page behind |
| no focus trap in a modal | the user tabs into content that is visually hidden |
| focus not returned on close | the user restarts from the top of the document |
| focus moved on every keystroke | typing is impossible in a filtered list |
| autofocus on a low value field | screen reader users skip the page context |
| skipped heading levels | the document outline stops being navigable |

## Second run at 200 percent zoom

Repeat the walk. Check that focused elements scroll into view, that sticky
headers do not cover the focused control, and that nothing that was reachable
becomes unreachable.

## Recording

Where the campaign records evidence, capture the walk once as a video or a
sequence of screenshots at the steps that fail. A focus defect described in
prose is argued about; a focus defect shown is fixed.
