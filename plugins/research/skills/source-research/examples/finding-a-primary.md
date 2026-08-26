# Example: from a headline to the primary source

The question: did a specific medication's approval change in the EU in 2025, and
how. A search lands on a news headline. The work is getting from the headline to
the document.

## The chain down the ladder

```
rung 4  a news aggregator: "Regulator updates approval for <drug>"
        useful only to learn the approval changed and roughly when
rung 3  the reporting outlet's article, which names "the agency's committee"
        and paraphrases the decision; still a paraphrase
rung 2  the agency's own press release, found by searching the agency site for
        the drug; states the decision in the agency's words and links a document
rung 1  the committee's published opinion (the primary), which contains the
        actual scope of the change, the conditions, and the date
```

## What changed between the rungs

```
the headline said "approval updated"
the article said "expanded to a new patient group"
the primary said "expanded to a new patient group, with a required monitoring
    protocol and a contraindication that the article omitted"
```

The finding reported from rung 3 would have been incomplete in exactly the
detail that matters for the decision. The primary carried it.

## Recorded finding

```
finding      the drug's approval was expanded to <group> in 2025, conditional on
             <monitoring protocol>, with a new contraindication for <condition>
attribution  <agency> committee opinion, published <date>, section 4.2 (rung 1)
route        found via the agency press release, reached from a news article
type         fact, directly stated by the primary
```

## The lesson

Every rung down removed an error or added a condition the rung above had dropped.
The search "stopped" at the news article would have been faster and wrong. Source
research is the following, not the finding.
