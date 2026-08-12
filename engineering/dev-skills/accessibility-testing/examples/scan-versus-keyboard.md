# Example: what the scanner found, and what the keyboard found

Same page, same build: a settings screen with a tab list, a form and a
confirmation dialog.

## The automated scan

```
axe-core 4.x, 1 page, 0 critical, 2 moderate

moderate  form element has no label            input#tz
moderate  insufficient contrast 3.9:1          .hint
```

Two findings, both real, both fixable in ten minutes. A campaign that stops
here reports the page as broadly accessible.

## The keyboard pass, twenty minutes later

```
step  key      focus landed on              visible  result
1     Tab      logo link                    yes      ok
2     Tab      nav item 1                   yes      ok
...
9     Tab      "Account" tab                yes      ok
10    Right    nothing moved                n/a      FINDING: tab list is not
                                                     arrow navigable, each tab
                                                     is a separate Tab stop
13    Tab      "Delete account" button      NO       FINDING: outline removed
                                                     on .btn-danger only
14    Enter    dialog opens, focus stays
               on the button behind it      n/a      FINDING: focus not moved
15    Tab      focus walks the page behind
               the dialog                   yes      FINDING: no inert, no trap
19    Escape   nothing happens              n/a      FINDING: Escape not handled
20    Tab x12  reaches "Confirm" inside
               the dialog                   yes      reachable, eventually
21    Enter    account deleted, focus on
               document body                n/a      FINDING: focus lost after
                                                     the destructive action
```

Six findings, none of which the scanner can see, and one of which means a
destructive confirmation dialog can be dismissed only by activating it.

## The form pass

```
submit the form with an empty required field
  error appears in red text under the field
  the error is not associated with the field: no aria-describedby, no id link
  the error is not announced: no live region
  focus stays on the submit button
  a screen reader user learns nothing except that the page did not navigate
```

One more finding, and the most consequential on the page: the form cannot be
corrected by someone who does not see the red text.

## The contrast pass, by hand

The scanner reported one contrast defect. Measuring the rendered pairs found
three more it could not see:

```
placeholder text over the input background          3.1:1   below 4.5
disabled button label                                2.4:1   exempt, but the
                                                             state is carried
                                                             by colour alone
white text over the hero image, at the crop used
  on narrow widths                                   2.9:1   varies with the
                                                             image, invisible
                                                             to a static scan
```

The third one is why contrast is measured on the rendered pair rather than on
the design token.

## Result

```
scanner        2 findings
manual passes  10 findings, of which 3 blocking

Blocking
  A11Y-01  dialog does not receive focus and is not dismissable by Escape
  A11Y-02  form errors are neither associated nor announced
  A11Y-03  focus indicator removed on the destructive action

High
  A11Y-04  tab list is not arrow navigable
  A11Y-05  focus lost after account deletion
  A11Y-06  no inert background behind the modal

Medium
  A11Y-07  timezone select has no label            (also found by the scan)
  A11Y-08  hint text contrast 3.9:1                (also found by the scan)
  A11Y-09  placeholder contrast 3.1:1
  A11Y-10  hero text contrast varies with the image at narrow widths
```

## What became permanent

Three of these became Playwright tests, because they are deterministic and
cheap to assert: focus moves into the dialog, Escape closes it, focus returns
to the trigger. The form association became a component test. The contrast
findings became a design token change plus one screenshot baseline, because a
test cannot follow a hero image that the client replaces every quarter.

The tab list finding stayed manual, and is written into the accessibility
notes as a check to repeat when that component changes.
