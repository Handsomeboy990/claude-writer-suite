# Example: the same project, asked two ways

Project: the marketplace brief. Requirements analysis produced 23 unknowns.

## The way that burns the relationship

Twenty three messages over nine days, one question each.

```
Day 1  "What database would you prefer?"
Day 1  "Should I use TypeScript?"
Day 2  "What should the page size be for the product list?"
Day 2  "Do you want dark mode?"
Day 3  "Who is the merchant of record?"
...
```

Four problems, in order of severity.

The merchant of record question, the one that determines the payment
architecture, arrived on day three behind two questions the system should have
answered itself and one that has an obvious default.

By the time it arrived, the client had learned that these messages are mostly
noise, and answered it in one word without thinking, because the previous four
had not deserved thought.

Nine days of calendar time were spent to obtain information that fits in one
message.

The client is now doing the analysis. They were told there would be an
engineering system.

## The way that works

Twenty three unknowns entered the blocking test. Nine came out blocking.
Fourteen became assumptions.

### One message

```
Before I propose the architecture, nine things change the design and I cannot
decide them for you. Everything else I have defaulted and listed at the end.

MONEY

1  Who is the merchant of record, the platform or each seller?
   Platform: you handle payments, refunds and tax, sellers are paid out by
   you. Simpler for buyers, heavier compliance for you.
   Seller: each seller is their own merchant, you take a fee. Lighter for
   you, needs seller onboarding checks per country.
   This determines the payment provider model and cannot be changed later
   without redoing checkout and payouts.

2  When is a seller paid: at order, at delivery, or after the dispute window
   closes?

3  An order is refunded after the seller was already paid out. Does the
   platform absorb the commission, claw it back from the next payout, or
   invoice the seller?

DISPUTES

4  Who decides a dispute, and within how many days of delivery?

5  Can a buyer open a dispute after the payout has been sent? If yes,
   question 3 becomes the normal case rather than the exception.

ROLES

6  Can one account be both a buyer and a seller?

7  When you suspend a seller, what happens to their orders that are already
   in progress?

DATA

8  A seller leaves the platform. What happens to their reviews and their
   past orders, from the buyer's point of view?

9  Which country's identity checks apply to seller onboarding: yours, the
   seller's, or both?

ASSUMPTIONS I HAVE MADE

If any of these is wrong, tell me now; each is cheap to change today.

A1  Currencies: EUR only at launch.
A2  Product images: up to 8 per listing, 5 MB each.
A3  Reviews: 1 to 5 stars plus optional text, one per completed order.
A4  Listing edits: allowed until the first order, locked afterwards.
A5  Search: name and description, no faceted filtering at launch.
A6  Interface language: French only.
A7  Seller balance is shown gross, with the commission displayed separately.
A8  Buyers can cancel an unshipped order without seller approval.
A9  Page sizes: 24 products, 20 orders.
A10 Order numbers: opaque identifiers, not sequential.
A11 Email is the only notification channel at launch.
A12 Timezone: Europe/Paris for all display.
A13 Uploaded files are stored for 5 years after account closure.
A14 No mobile application; the site is responsive.
```

### What that message costs and returns

The client reads it in six minutes and answers in one sitting. Question 1 gets
real thought because it is first, it explains the consequence, and it is not
buried behind a question about dark mode.

Three of the fourteen assumptions came back corrected: A1 became EUR and CHF,
A6 became French and German, A13 became 10 years because of an accounting
obligation nobody had mentioned. All three were free to change at that moment.
A13 discovered a compliance requirement that no version of the brief
contained.

### What was never asked

```
Database              decided, PostgreSQL, justified in technology-selection
Language              decided, TypeScript, the team's existing stack
REST or GraphQL       decided, REST, no client requires the alternative
Dark mode             not in scope, listed in the out of scope section
Hosting               proposed with alternatives at the validation gate
Test framework        decided, the one already in the repository
Folder structure      decided, following the existing convention
```

Seven questions the client would have had to answer, each one a small demand
on their attention, each one a decision the system is supposed to make and
justify. They appear in the architecture proposal as decisions with reasons,
which is where the client can still disagree, at no cost, in one place.

## The rule the example demonstrates

The number of questions is not the measure. Nine questions in one message was
correct here. Nine questions would have been wrong for the support tool
example, which needed two.

The measure is: does the answer change what gets built, and can the person
answer it without doing engineering. Everything that passes both goes in the
batch. Everything else gets a default and a line in the register.
