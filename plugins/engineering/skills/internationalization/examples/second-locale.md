# Example: adding the second locale to a product built for one

The product is in English, sold in the United Kingdom, and is about to launch
in France and Quebec. Three locales, two languages, three sets of regional
rules.

## The model, decided in an hour

```
locales     en-GB, fr-FR, fr-CA
negotiation URL segment: /en, /fr-fr, /fr-ca. Chosen because marketing pages
            must be indexed separately per locale.
persistence the authenticated user has a locale preference. The URL wins for
            a single request, the preference is updated when they switch.
fallback    fr-CA falls back to fr-FR, then to en-GB
regional    currency GBP, EUR, CAD. Tax rules differ in all three. Legal
            footer text differs in all three. Date format differs between
            fr-FR and fr-CA.
```

That last line is why the model is locale based and not language based: two
French locales that must not share a date format or a currency.

## What the audit found in the existing code

```
1  412 hardcoded strings, of which 63 in server validation and 40 in mail
   templates. The interface components were mostly already using a catalogue.
2  19 places formatting dates by hand, including the invoice PDF
3  currency written as "£" + amount.toFixed(2) in 7 places
4  plural handled by count === 1 in 23 places
5  three sentences assembled from fragments, one of which is untranslatable
   into French without restructuring
6  sorting the member list by a plain string comparison, which places accented
   names after Z
7  the timezone of scheduled reports taken from the browser, which produced a
   report labelled Tuesday for a user who received it on Monday evening
```

Item 5 is the interesting one:

```
"You have " + count + " unread " + (count === 1 ? "message" : "messages")
  + " in " + folderName

French requires a different word order, agreement on the adjective, and the
preposition contracts with the article depending on the folder name's gender.
No amount of fragment translation produces a correct sentence.

Replaced by one message with named placeholders and plural categories:
  inbox.unread = "{count, plural, one {Vous avez # message non lu dans {folder}}
                                other {Vous avez # messages non lus dans {folder}}}"
```

## The order of work

```
1  pseudo-locale added first, before any translation. It immediately listed
   every hardcoded string, because they stayed unmarked on screen.
2  formatting routed through the locale aware functions: dates, numbers,
   currencies. One utility module, seven days of small changes.
3  the 23 plural branches replaced by message format plurals.
4  the three concatenated sentences restructured, with a note to translators.
5  server validation messages moved to codes, translated at presentation.
   The API keeps returning codes, which partners preferred anyway.
6  mail and invoice templates externalised, which nobody had planned for and
   which took as long as the interface.
7  sorting moved to a locale aware comparison.
8  the report timezone became an explicit user setting, defaulting to the
   browser's zone but stored and editable.
```

## What the pseudo-locale caught before any translator saw the product

```
the primary navigation broke at 130 percent string length
the invoice table clipped the description column
four buttons had fixed widths
the plan comparison table became unreadable and needed a different layout
  at narrow widths in the expanded locale
two toast messages truncated mid word
```

All six were layout defects that would otherwise have been reported by French
users in the first week, and each was cheaper to fix before translation than
after.

## What stayed in English, deliberately

```
the internal admin interface, used by six employees who all read English
log messages and error codes
the API contract, including its error codes
```

Written into the decision record, so that nobody spends a sprint translating
an admin panel that nobody asked for.

## Verification

```
every screen rendered in en-GB, fr-FR, fr-CA and the pseudo-locale
a French user's invoice: correct date format, EUR, French legal footer
a Quebec user's invoice: correct date format, CAD, Quebec legal footer
a scheduled report at 08:00 local, verified across a daylight change
member list sorted with accents in the right place, verified in French
mails sent in the recipient's locale, not the sender's, verified for
  invitations where the two differ
```

The invitation case is the one nobody thinks of: the mail language follows the
recipient, and the only way to find that out is to test with two accounts in
two locales.
