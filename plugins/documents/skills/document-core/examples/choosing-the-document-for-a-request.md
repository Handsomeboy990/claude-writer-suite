# Choosing the document for a request

The request, as received:

> Can you document the new billing integration? The client needs it, our devs
> need it, and support keeps asking how refunds work.

One request, three audiences, three documents. Producing one document here is
the most common failure in professional documentation, and it is decided
before a word is written.

## Applying section 3

| Reader | Wants | Cost of misreading |
|---|---|---|
| Client, a finance lead | proof it works and what to do at month end | invoices reconciled wrong |
| Developer, integrating | endpoints, payloads, failure modes | a broken integration in their production |
| Support agent | how to answer a refund question in two minutes | a wrong answer given with confidence |

No shared structure exists. The client wants outcomes, the developer wants a
contract, support wants a symptom index. A single document would open with the
wrong thing for two readers out of three.

## The split

| Document | Skill | Audience | Output language | Format |
|---|---|---|---|---|
| Billing integration overview | `report-writing` | client finance lead | French, the client is French | PDF, 3 pages |
| Billing API reference | `technical-writing` | developer | English | Markdown in the repository |
| Refunds: answering customer questions | `user-documentation` | support agent | English | internal knowledge base |

The client document is French because the client reads French. The team
documents are English because the system language is English and the readers
are the team. That is section 2 applied, not a preference.

## What the evidence rule changed

Drafting the API reference produced fourteen statements. Section 5 forced each
one to be verified. Four did not survive.

| Statement drafted | Verification | Outcome |
|---|---|---|
| Refunds are processed within 24 hours | asked the provider, found 5 to 10 business days for the card network | corrected; the wrong number would have been quoted to customers |
| The endpoint returns 404 for an unknown invoice | called it, returns 200 with an empty object | corrected, and a defect raised |
| The webhook retries three times | no retry configuration found anywhere in the code | marked as a gap, not written |
| Partial refunds are supported | the field exists, no handler reads it | written as not supported, with the field documented as reserved |

Three of those four would have been plausible. All four would have been
believed, because they were in a document.

The gap was marked visibly in the delivered draft:

```
[TO CONFIRM: webhook retry policy. Nothing in the code sets one, and the
provider dashboard is not accessible from here. Owner: platform team.]
```

Support would have been told refunds take 24 hours. That single unverified
sentence would have produced a customer complaint for every refund.

## What the audience split changed

The client document opens with a table of what reconciles automatically and
what does not, then the month end procedure. It contains no endpoint, no
payload, no status code.

The developer reference opens with an authenticated request and its real
response. It contains no month end procedure.

The support document is indexed by the customer's words: *my refund has not
arrived*, *I was charged twice*, *I cancelled but was still billed*. Not by
component, and not by endpoint. Each entry is symptom, cause, check, action,
escalation threshold.

## Gate record

```
Document: Billing API reference, v1, English
Audience: developer integrating, section 3 profile
1 Content     pass  14 statements, 10 verified by running, 3 corrected, 1 marked as a gap
2 Structure   pass  request and response first, failures before conveniences
3 Language    pass  English, terms match the code, no synonym drift
4 Formatting  pass  document-design applied, code blocks labelled
5 Audience    pass  no product narrative, no month end procedure
6 Consistency pass  invoice, not bill or charge, throughout
7 Requirement pass  three documents requested as one, split with the reason stated
8 Self critique  pass  technical writer, subject matter expert, new developer
Gaps remaining: webhook retry policy, owner platform team
```

Gate 7 is the interesting one. The request asked for one document. Delivering
three is a scope change, so it was stated and agreed rather than done quietly.
Silently expanding a deliverable is the same failure as silently shrinking it.
