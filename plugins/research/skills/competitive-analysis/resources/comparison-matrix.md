# The evidence matrix

The structure that keeps a comparison honest: options across the top, axes down
the side, and every cell backed by a source and tagged with the type of evidence.

## The shape

```
                 axis 1 (decisive)   axis 2 (decisive)   axis 3 (important)
option A         entry [type][src]   entry [type][src]   entry [type][src]
option B         entry [type][src]   entry [type][src]   entry [type][src]
option C         entry [type][src]   entry [type][src]   entry [type][src]
```

## Evidence type, in every cell

```
[observed]     seen directly: a trial, the source code, a measured number
[claimed]      the option's statement about itself; attributed, not trusted
[independent]  a third party with no interest; per the source hierarchy
[gap]          not established; named, never filled with marketing
```

A matrix that is all [claimed] is a collage of marketing. A useful matrix is
mostly [observed] and [independent] on the decisive axes, with [gap] where the
truth could not be reached.

## Rules for the matrix

- Axes are fixed before the options are entered, and derived from the decision.
- The decisive axes carry the most evidence; a tie-breaker may be lighter.
- Like-for-like: axis 2 is measured the same way for A, B and C, or the cells are
  not comparable and say so.
- A [claimed] cell that a trial contradicts is rewritten to the observation, with
  the contradiction noted; the option's claim does not silently win.
- Every [gap] on a decisive axis is a candidate for the one thing to go and
  measure before deciding.

## Reading the matrix for the decision

The recommendation reads the decisive rows against their weights. A single
ranking number thrown across all axes hides the trade-off; report which option
wins on which decisive axis, and the conditions that tip the balance.
