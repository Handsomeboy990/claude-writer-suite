# literary-critic

Severe editorial analysis: weighted grid across ten criteria, decision scale,
five reads, a structured report with quotations, a verdict and one single
recommendation.

- Inputs: the complete manuscript.
- Outputs: critical report, editorial verdict.
- Depends on: `writing-constitution`.
- Downstream: `publication-review`, `rewriting-engine`.

## When to use

To find out whether a manuscript is publishable, and what to fix first.

## What to expect

It judges the book that was written, not the one that was intended. It always
reaches a verdict, including the hardest one: do not rework this text, write
the next one. Every criticism carries a quotation, which is what separates a
judgement from a preference.

## Configuration

`language.creative_output` sets the output language.
