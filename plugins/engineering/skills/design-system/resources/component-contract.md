# Component contract

One per component, written before implementation and kept beside it.

```
COMPONENT  Button

Purpose      triggers an action in the current context
Not for      navigation to another address, which is a link, even when it
             looks like a button

Anatomy      container, optional leading icon, label, optional trailing icon,
             loading indicator replacing the leading icon

Variants     primary, secondary, ghost, danger
             one primary per view, stated as a rule, not enforced by code

Sizes        sm, md, lg, from the spacing and typography scales

States       default
             hover           background one step darker
             focus visible   2px outline, offset 2px, token color-focus,
                             visible in every theme, never removed
             active          background two steps darker
             disabled        reduced contrast, not interactive, and the
                             reason is available to assistive technology
             loading         label retained, indicator replaces the leading
                             icon, width does not change, control disabled,
                             state announced
             icon only       requires an accessible name, tooltip optional

Content      label is one to three words, verb first
             very long labels wrap to two lines maximum, then truncate with
             the full text available to assistive technology
             text expansion of 40 percent must not break the layout

Accessibility
             element         button
             name            from the label, or from an explicit name when
                             icon only
             keyboard        Enter and Space activate
             focus           never removed, never suppressed by a style reset
             disabled        remains discoverable, communicates why where the
                             reason is not obvious

Composition  may contain text and icons only
             may not contain another interactive element
             inside a form, the type is explicit

Props        variant, size, disabled, loading, iconLeading, iconTrailing,
             type, and the standard event handlers
             no className, no style, no sx, no arbitrary override

Tokens       button-background-{variant}, button-text-{variant},
             button-padding-{size}, radius-md, motion-fast

Do not       use primary for a destructive action, which is what danger is for
             disable a button to communicate a validation failure without
             telling the user what is missing
             put a spinner in place of the label, which changes the width and
             moves the layout
```

## What every contract must contain

```
purpose and non-purpose
anatomy
the finite variant list
the complete state list, including focus visible, disabled and loading
content rules, including long, short, absent and expanded text
the accessibility contract: element, name, keyboard, focus
composition rules
the prop surface, with no style escape
the tokens consumed
the misuse list
```

## The state inventory, in full

Any interactive component is checked against this list, and each row is either
implemented or explicitly not applicable:

```
default            selected           empty
hover              indeterminate      loading
focus visible      expanded           error
active             collapsed          success
disabled           read only          truncated
```

Most components need six of these. The point of the list is that the missing
one is noticed at design time rather than by a user.
