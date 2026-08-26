# Internationalization audit

Run on a product about to gain a second locale, or on one that already has two
and does not trust them.

## Strings

```
grep for quoted text in components, handlers and templates
grep for string concatenation adjacent to a translation call
grep for ternaries selecting singular and plural
list keys whose name is the English text
list keys that appear in one locale only
list keys nothing references any more
```

## Formatting

```
grep for manual date formatting: slashes, dots, month names in code
grep for toFixed, and for manual thousand separators
grep for currency symbols written inline
grep for hardcoded timezone offsets
grep for sorting by a plain string comparison on user visible text
```

## Surfaces usually missed

```
mail templates
invoice and receipt generation
exported CSV headers and PDF documents
push notifications and SMS
validation messages
server error pages
page titles and meta descriptions
empty states and onboarding text
seeded and demonstration data
admin interfaces, which are often left in one language deliberately: that is
  a decision and it should be written down
```

## Layout resilience

```
render every screen with the pseudo-locale, which expands every string
find: truncation, overflow, buttons that wrap badly, tables that break
check fixed width containers holding text
check labels beside inputs, which break first
check anything absolutely positioned by pixel measurement
```

## Right to left, if in scope

```
layout mirrors: navigation, drawers, progress, breadcrumbs
directional icons mirror: back, forward, indent, send
non directional icons do not mirror: clock, logo, checkmark
text alignment follows direction
numbers and Latin identifiers embedded in RTL text render correctly
input fields with mixed content behave
shadows, borders and paddings use logical properties
```

## Timezone

```
what is stored: UTC, verified
what is displayed: which zone, and where it comes from
a user in another zone sees the same event at the correct local time
a date only value, such as a birthday, does not shift by a day
a scheduled job at a fixed local time behaves across a daylight change
a date range filter means the same thing to a user in two zones
```

## Pseudo-locale

The cheapest test in this discipline: a generated locale that takes each
string and expands it, marks it, and pads it.

```
"Save changes"  becomes  "[## Ŝåṽê çĥåñĝêŝ ~~~~~~~~ ]"
```

It finds three classes at once: hardcoded strings, which stay unmarked; layout
that cannot tolerate expansion; and concatenation, which produces half marked
sentences. It runs in the browser suite with no translator involved.

## Findings format

```
I18N-04  Validation messages are hardcoded in the server handlers
Surface  17 handlers, 63 messages
Effect   a French user sees English errors on every form failure
Fix      route messages through the catalogue with codes, and translate at
         the presentation layer, since the API also serves partners who need
         the code rather than the sentence
Cost     one day, plus translation
```
