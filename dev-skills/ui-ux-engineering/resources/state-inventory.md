# State inventory

Filled per component before implementation. A component whose inventory has
blanks is not specified.

```
Component: InvitationList

| State | Trigger | What the user sees | Notes |
|---|---|---|---|
| default | data loaded, rows present | table of invitations | |
| loading | request pending | 5 skeleton rows, same height as real rows | no layout shift |
| empty, first use | zero invitations ever | title, one sentence, Invite button | the action is the point |
| empty, filtered | filter matches nothing | title naming the filter, Clear filter | different from first use |
| partial | list loaded, member count pending | rows visible, count as a skeleton | do not block the list |
| error | request failed | title, cause, Try again | says whether retrying helps |
| success feedback | invitation sent | status message, new row highlighted briefly | persists 4s minimum |
| disabled action | seat limit reached | Invite button disabled, reason next to it | never a bare disabled control |
| hover | pointer over a row | row background shift | never the only affordance |
| focus | keyboard focus on a control | visible ring, both themes | contrast target met |
```

## Rules per row

**loading.** Reserve the space the real content will occupy. A spinner in a
zero height container guarantees a layout jump.

**empty, first use versus empty, filtered.** These are different states with
different words and different actions. Conflating them is the most common
empty state defect: a user who filtered to nothing is told they have no data.

**partial.** Decide whether the screen waits for everything or renders
progressively. Waiting for the slowest of three requests is a choice, and
usually the wrong one.

**error.** Three obligations: what failed, whether retrying helps, and the
control that retries. A message saying something went wrong meets none of
them.

**disabled.** A disabled control with no explanation is a dead end. Either
explain it adjacent to the control, or do not disable it and explain on
attempt.

**focus.** Checked on both themes. A focus ring that is visible on light and
invisible on dark is a keyboard user losing their place.

## Completion test

Read the inventory and ask: could someone implement the component from this
alone, without asking a question? If not, the blank is where the question is.
