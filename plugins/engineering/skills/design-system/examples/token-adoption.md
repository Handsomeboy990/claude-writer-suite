# Example: adopting tokens in a product that already exists

Four years of product, six engineers, no system. The proposal on the table was
a rewrite of the interface over a quarter, which was correctly refused.

## The inventory, one afternoon

Extracted from the stylesheets and the components, then counted:

```
colours          47 distinct values, of which 9 shades of the same grey and
                 4 nearly identical blues
font sizes       23, several differing by one pixel
spacing values   31, of which 4, 5, 6 and 8 pixels all in use for the same
                 kind of gap
border radius    9
shadows          11
button styles    7 visually distinct, across 4 implementations
z-index values   highest was 99999, on a tooltip
```

Nobody argued after seeing the counts. That is the function of the inventory:
it converts a taste discussion into a maintenance one.

## Tokens first, no component work

```
week 1  define the scales by consolidating what exists rather than inventing:
        6 greys, 1 blue with 5 steps, 1 green, 1 red, 1 amber
        spacing: 4, 8, 12, 16, 24, 32, 48, 64
        type: 12, 14, 16, 20, 24, 32, with paired line heights
        radius: 4, 8, full
        shadows: 3
        z-index: 5 named layers

week 2  semantic layer on top:
        color-surface, color-surface-raised, color-text, color-text-muted,
        color-border, color-action, color-action-hover, color-danger,
        color-focus, and their dark theme values

week 3  mechanical replacement of raw values with tokens, file by file.
        Every replacement mapped to the nearest scale value, and the visual
        difference reviewed on screenshots. 14 places changed by more than
        two pixels and were checked individually.
```

Three weeks, no component rewritten, and the product could now be themed.

## What that alone bought

```
dark mode, which had been estimated at six weeks, took four days: it was a
  second token set plus 23 places that had assumed a light background
a brand colour change requested by marketing took twenty minutes
the contrast audit found 9 failing pairs, and fixing them meant changing 2
  token values rather than 60 declarations
```

## Then components, by traffic

```
1  Button, used on every screen, 4 implementations collapsed into 1
   the migration found 3 buttons with no focus style and 2 that were divs
2  Input and field wrapper, which fixed label association in 11 forms
3  Modal, which fixed focus trapping and Escape handling everywhere at once
4  Table, the largest, done last and over two iterations
```

Each component shipped with its contract, its states rendered in the
documentation, and a codemod where the prop surface changed.

## Migration on contact

No screen was rewritten for its own sake. The rule was: a screen you are
already changing adopts the system before you leave it.

```
adoption after 3 months   61 percent of screens
adoption after 6 months   88 percent
remaining                 the admin billing screens and two legacy reports,
                          recorded as debt with an estimate, not left implied
```

## What the system deliberately does not have

```
no Card component: three screens use a box with a border and they do not
  share a concept. Recorded, revisited if a fourth appears.
no Grid component: the layout primitives of the platform are adequate and
  wrapping them added a name without adding a decision
no theme beyond light and dark: a third was requested for a partner and
  refused until the partner contract exists
```

Writing down what the system refuses is as useful as documenting what it
contains. It is the difference between a system and an accumulation.
