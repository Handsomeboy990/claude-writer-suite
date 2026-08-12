# Usability questions that end in an observable fact

Each question is followed by the evidence that turns the answer into a
finding. An answer with no evidence line stays an opinion and is reported as
one, separately from the defect list.

## Understanding

```
Q  Can a user who has never seen this screen tell what to do first?
E  The action taken first, and whether it was the intended one.

Q  Does every label say what will happen, rather than what the system calls it?
E  The label, and the behaviour it actually triggers.

Q  Is the primary action visible without scrolling at the supported widths?
E  Width, and whether the action was below the fold.
```

## Feedback

```
Q  Does every action produce a visible change within a second?
E  The action, the elapsed time, what changed on screen.

Q  When an operation is in flight, does the interface say so?
E  Screenshot of the intermediate state, or its absence.

Q  When an operation fails, does the user learn what to do next?
E  The exact message shown, and whether it names a cause or a technology.

Q  When an operation succeeds, is the result visible without a reload?
E  What appeared, or the reload that was required.
```

## Recovery

```
Q  Can the user undo, or correct, without starting again?
E  The path back, or its absence, and what was lost.

Q  Does a validation error preserve what was already entered?
E  The fields still populated after the failed submit.

Q  Can the user get out of every screen without the browser back button?
E  The exit available in the interface.
```

## Predictability

```
Q  Does the same control behave the same way everywhere?
E  Two locations, and the two behaviours.

Q  Does back go where the user expects?
E  The origin, the destination, the expectation.

Q  Does a destructive action look destructive, and ask before acting?
E  The confirmation, its wording, and what happens without it.
```

## Emptiness and abundance

```
Q  Does an empty list explain what it would contain and how to fill it?
E  The empty state text, or the blank area.

Q  Does a long list stay usable: search, filter, pagination, order?
E  The number of rows at which it degrades.
```

## The final question

```
Q  Could a person with the intended job complete it, alone, first time?
E  The steps taken, where they hesitated, where they stopped.
```

That last line is the whole discipline. Everything above exists to make the
answer specific enough to fix.
