# Example: one defect, in a system with no tests

The report: invoices for customers in one country show the wrong tax total.
The system: eleven years old, no test suite, three previous maintainers, the
invoice module is 2400 lines in one file.

## What was done first, and it was not reading

```
built and ran the application locally: two hours, three missing environment
  variables, one deprecated dependency pinned
generated an invoice through the interface: it worked
generated an invoice for the affected country: reproduced the defect on the
  first attempt
```

Reproducing before reading meant every subsequent hour of reading had a target.

## The map, one page

```
entry points   two: the web controller, and a nightly batch job. Both call
               InvoiceRenderer.render, which is where the defect lives.
boundaries     database, a currency rate service over HTTP, a PDF library,
               the system clock, a filesystem cache
tests          none for invoices. 40 tests elsewhere, 6 of them failing today
               and failing before this work started, recorded as such.
danger zone    a 300 line method with a comment reading "do not change the
               order of these blocks, see ticket 4471". The ticket no longer
               exists. The comment was believed.
```

## The seam

`render` builds its own tax calculator, reads the clock, and calls the rate
service directly. No seam.

The smallest one available: the tax calculation was already a private method
taking a country code and a subtotal. Extracting it into a plain function,
called from the same place, was a mechanical change with no behaviour
difference, and it created a testable surface in twenty minutes.

```
commit 1  extract computeTax(country, subtotalMinorUnits, date) -> integer
          no logic change, called from the same line
```

## Characterization tests, before the fix

```
country FR, 100.00, 2026-08-01   -> 2000     (20 percent)
country DE, 100.00, 2026-08-01   -> 1900
country LU, 100.00, 2026-08-01   -> 1700
country IE, 100.00, 2026-08-01   -> 2300
country IE, 100.00, 2020-08-01   -> 2100     the historical rate
country XX, 100.00, 2026-08-01   -> 0        unknown country, silently zero
country FR, 0.01,   2026-08-01   -> 0        rounds down to nothing
```

Two of those seven are wrong, and both were asserted as they are:

```
unknown country returns zero tax instead of failing. That is how one customer
  has been invoiced without tax for four years. Raised as a separate finding,
  not fixed here.
one cent rounds to zero tax. Correct in the local regulation. Verified with
  the finance contact rather than assumed.
```

## The fix

```
commit 2  IE rate table had 21 percent applying from 2020 with no end date,
          and 23 percent from 2021 inserted after it in the list. The lookup
          returned the first match rather than the most recent applicable one.
          Fix: order the table by start date descending and return the first
          whose start date is on or before the invoice date.
          One test written first, red, then green. Six characterization tests
          still pass unchanged.
```

Three lines changed. Finding them took a day, and the day was spent building
the ability to change those three lines safely.

## What was deliberately not done

```
the 2400 line file was not split
the 300 line method was not touched, and its comment is still there
the six pre-existing test failures were not fixed
the unknown country defect was not fixed in this change
formatting was left exactly as it was
```

All five went into the risk register with an estimate, and the unknown country
defect became its own ticket with a note that it has financial consequences
and needs a decision, not only a fix.

## The risk register entry

```
invoice module
  no automated coverage except computeTax, added by this change
  the rate table is edited by hand in the database, with no validation
  the batch job and the controller can disagree, since only one was verified
  the "do not change the order" comment refers to a ticket that no longer
    exists. Nobody knows what it protects. Treat the block as load bearing
    until someone characterises it.
  suggested next seam: extract the currency formatter, one hour, would allow
    testing the rendering path
```

The next person to open this file starts with that page instead of the two
hours of setup and the day of reading.
