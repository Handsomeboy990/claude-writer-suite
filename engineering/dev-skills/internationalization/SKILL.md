---
name: internationalization
description: Makes a product work in more than one language and region without rewriting it: externalised strings with stable keys, pluralisation and gender, interpolation without concatenation, locale aware dates, numbers and currencies, timezone correctness, right to left layout, locale negotiation and persistence, translation workflow and missing key behaviour. Use before the second language, not after it.
license: MIT
metadata:
  category: dev-skills
  version: 1.0.0
  depends_on: [engineering-core, frontend-engineering]
  outputs: [locale-model, message-catalogue, formatting-rules, translation-workflow, rtl-plan]
---

# Internationalization

Adding a second language to a product that assumed one is a refactor of every
screen. Preparing for it costs almost nothing while there is still one.

The work divides in two: internationalisation, which is engineering, and
localisation, which is translation. This skill owns the first and makes the
second possible.

## 1. Decide the model first

```
which locales, expressed as language plus region where it matters
which are content locales, and which are only interface locales
how a locale is chosen: URL segment, subdomain, user preference, header
how it is persisted, and how a user overrides the detection
the fallback chain, ending at a locale that always exists
whether currency, tax and legal text vary by region independently of language
whether content is translated or region specific, which are different problems
```

Locale is not language. A price, a date format and a legal notice can differ
between two regions sharing a language.

## 2. Strings

```
every user visible string in a catalogue, keyed, never inline
keys that describe meaning and location, not the English text
one key per message, never assembled from fragments at runtime
interpolation with named placeholders, never string concatenation
context provided to translators: where it appears, what the placeholder is,
  how long it may be
no HTML built by concatenating translated pieces
```

Concatenation is the defect that produces untranslatable sentences, because
word order differs between languages and a fragment has no grammatical
identity.

## 3. Plurals and grammar

```
plural rules come from the locale, not from a count equals one check
languages have between one and six plural categories, and the library knows
gendered forms handled by the message format, not by branching in code
ordinals, ranges and lists have their own locale rules
sentence case, capitalisation and quotation marks differ by language
never build a sentence from a noun and a verb chosen separately
```

## 4. Numbers, dates, money

```
numbers formatted by locale: separators, grouping, decimal sign
percentages and units formatted, not concatenated
currency formatted with the locale and the currency, which are independent
dates and times formatted by locale, never assembled from parts
relative time expressed with the locale's own rules
timezone: stored in UTC, displayed in the user's zone, and the zone is a
  user setting, not a browser guess, wherever it matters
calendars and week start days vary, and a date picker must follow the locale
```

## 5. Layout

```
text expands: German and Finnish often 30 percent longer than English, and
  some languages far more. Layouts must not depend on string length.
right to left: mirrored layout, logical CSS properties, mirrored icons that
  imply direction, unmirrored ones that do not, correct text alignment
bidirectional text: a Latin identifier inside an RTL sentence must render
  correctly, which requires isolation rather than hope
fonts: the chosen typeface must cover every script in scope
line breaking differs by script, and truncation must not break a grapheme
```

## 6. Locale negotiation

```
detect from an explicit choice first, then a stored preference, then the
  request's accepted languages, then the default
never lock a user into a locale because of their address
make the switcher reachable on every page, naming languages in their own
  language
the chosen locale appears in the URL where content is indexed, so a shared
  link keeps its language
```

## 7. Translation workflow

```
the catalogue is the source: extracted from code, not maintained by hand
new keys appear in the source locale and are marked untranslated elsewhere
missing keys fall back visibly in development and gracefully in production
never ship a raw key to a user
unused keys are detected and removed, since a catalogue only grows otherwise
a translated string is versioned with the source string: changing the source
  invalidates the translations
screenshots or context notes accompany anything ambiguous
```

## 8. What is often forgotten

```
mails, receipts, invoices and exported documents
error messages, including validation and server errors
notifications, push messages and SMS
metadata: page titles, descriptions, alternate language links
dates inside generated PDFs
sorting and searching, which are locale sensitive
input parsing: a user typing a number or date in their own format
address and phone formats, and name order
seeded and sample data, which is usually in one language forever
```

## 9. Prohibitions

- Never concatenate translated fragments into a sentence.
- Never hardcode a user visible string, including in an error path.
- Never format a date or a number by hand.
- Never use a flag to represent a language.
- Never assume a name has a given order or a fixed set of characters.
- Never infer a language from a country or from an IP address alone.
- Never let a missing translation reach a user as a key.
- Never test with the source locale only.

## 10. Protocol

1. Decide the locale model, the negotiation and the fallback chain.
2. Externalise strings with meaningful keys and named placeholders.
3. Adopt a message format that handles plurals and gender.
4. Route every number, date and currency through locale aware formatting.
5. Decide timezone storage and display.
6. Make layouts tolerate expansion, and add logical properties for RTL.
7. Set up extraction, missing key behaviour and unused key detection.
8. Cover the forgotten surfaces: mail, documents, notifications, metadata.
9. Test with a pseudo-locale that expands strings and marks untranslated text.
10. Run the browser pass in at least one RTL locale if one is in scope.

## 11. Auto-critique

Score from 0 to 5: locale model decided, no concatenated sentences, plural and
gender handled by the format, all formatting locale aware, timezone
correctness, layout resilience to expansion, negotiation and persistence,
coverage of mail and documents, missing key behaviour, pseudo-locale testing.

Threshold: no axis below 3, average at least 4. A product whose error messages
or mails are untranslated is internationalised on the screens someone
remembered, which is not internationalised.

## 12. Interfaces

- Upstream: `requirements-analysis` for the locales in scope,
  `ui-ux-engineering` for layouts that tolerate expansion.
- Lateral: `frontend-engineering` and `backend-engineering` for the
  catalogues, `design-system` for logical properties and typography,
  `seo-engineering` for alternate language metadata.
- Downstream: `testing-quality` for pseudo-locale tests,
  `accessibility-testing` for language declaration and RTL,
  `technical-documentation` for the translation workflow.
