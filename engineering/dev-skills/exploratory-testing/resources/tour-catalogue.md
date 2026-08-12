# Tour catalogue

A tour is a lens on the product. Two or three per session. Each one lists the
moves that belong to it and the defect family it usually surfaces.

## Newcomer tour

Account created two minutes ago, no data, no training, no documentation.

```
sign up, confirm, arrive
try to reach the thing the product is sold for
notice every point where the interface assumes knowledge you do not have
count the clicks to first value
```

Finds: empty states that explain nothing, onboarding that assumes existing
data, features that only make sense once you already use them.

## Landmark tour

Every feature named in the navigation, the marketing copy or the
documentation, reached from the front door.

```
list what the product claims to do
reach each one without using a bookmarked URL
note the ones that cannot be reached, or need a role nobody explained
```

Finds: orphan routes, features shipped without navigation, permissions that
hide something the user was told they have.

## Back roads tour

The pages nobody demonstrates: settings, profile, billing history, exports,
notifications, admin, help.

```
open every settings panel and change one thing in each
export something and open the file
change an email or a password and see what else it affects
look at whatever the admin interface offers
```

Finds: the highest density of defects in most products, because these paths
carry the least attention and often the most privilege.

## Interruption tour

The user is interrupted, as users are.

```
reload in the middle of a multi step flow
navigate back after submitting
navigate forward again
open the same page in a second tab and act in both
let the session expire, then act
log out in one tab while working in another
close a dialog with Escape mid operation
```

Finds: lost work, stale state, duplicate submissions, actions that succeed
against an expired session, actions that fail silently.

## Obsessive tour

The same intent, repeated and rushed.

```
click the primary action twice, fast
submit the same form three times
create, delete, recreate with the same name
undo and redo the same operation
switch between two records quickly and check which one you are editing
```

Finds: missing idempotency, race conditions, unique constraints surfacing as
stack traces, the wrong record edited.

## Money tour

Anything that counts: prices, quantities, quotas, seats, credits, limits.

```
reach the boundary of a limit, then exceed it by one
apply the discount twice
change quantity to zero, and to a very large value
start a purchase and abandon it, then start again
downgrade, then immediately upgrade
```

Finds: rounding, quota bypass, state machines with impossible transitions,
double charges.

## Supporting actor tour

The states that are not the success state.

```
force each list to be empty
force each request to be slow
force each request to fail
reach a permission denied page
reach a not found page from inside the application
disable images, or let one fail to load
```

Finds: missing empty states, spinners that never end, error pages that lose
the application shell, retries that do nothing.

## Antisocial tour

Input the interface did not expect, within what the contract allows.

```
very long strings in every free text field
leading and trailing spaces
characters from another script, and emoji where the product claims to allow them
a date far in the past and far in the future
paste instead of type
a file of the wrong type, and a file at the size limit
```

Finds: truncation without warning, validation that runs only on the client,
layout that breaks on real content.

## Continuity tour

Leave the operation half done and come back.

```
start a draft, leave, return the next day
begin an upload and navigate away
begin a checkout and return through a bookmark
leave a long form open past the session lifetime
```

Finds: orphaned records, drafts that cannot be resumed, half created entities
that block the next attempt.

## Choosing tours

| The area | Tours that pay |
|---|---|
| onboarding, first use | newcomer, supporting actor |
| a form heavy flow | obsessive, antisocial, interruption |
| billing, subscription, cart | money, obsessive, continuity |
| settings, admin | back roads, landmark |
| anything asynchronous | continuity, supporting actor, interruption |
| a redesign | landmark, supporting actor, newcomer |
