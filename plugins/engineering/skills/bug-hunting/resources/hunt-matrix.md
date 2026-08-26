# Hunt matrix

The nine families, expanded into the moves that are actually performed. Every
row gets a result: `ok`, `hit`, or `n/a` with the reason. A row left blank is
a row that was not run.

## 1 Repetition

```
click the primary action twice within 200 ms
click it five times
submit the form, then press Enter again on the same form
resubmit by reloading a POST result page
replay the same request twice with the same body
create, delete, create again with identical values
```

Look for: two records, two mails, two charges, two jobs, a second request that
returns 500 instead of a clean conflict.

## 2 Concurrency

```
the same account in two tabs, same record, edit in both, save both
two different accounts editing the same record
the same request sent twice in parallel
a long operation started twice before the first finishes
a delete in one tab while the other holds the edit form
```

Look for: last write silently wins, a lost update with no warning, a unique
constraint reaching the user as a stack trace, both operations succeeding when
only one should.

## 3 Interruption

```
reload during submission
back immediately after submission
forward again after back
close the tab mid upload, reopen the page
Escape on a dialog mid operation
navigate away with unsaved changes
```

Look for: work lost with no prompt, records created without their children,
uploads that leave a placeholder, a back navigation that shows stale data as
if it were current.

## 4 Session

```
act after the session expires
act after logging out in another tab
act after the role is changed by an administrator
act after the account is disabled
resume a form left open past the session lifetime
use a link shared before a permission was revoked
```

Look for: a 401 with no user visible handling, an action accepted with the old
permission, input lost on redirect to login, no return to the original page
after signing back in.

## 5 Network

```
throttle to a slow profile and complete a flow
go offline mid operation, then online
force a request to time out
force a request to fail with 500
force a request to fail with 429
```

Look for: a spinner with no end, a success message on a failed request, a
retry that duplicates the effect, no offline handling at all, a rate limit
that reaches the user as a blank screen.

## 6 Response

```
empty body where a list was expected
null where an object was expected
a field missing from the payload
an unexpected extra field
an error body with a shape the client does not expect
a very large list where the interface expects a page
```

Look for: a render crash, a blank region with a console error, `undefined`
shown to the user, an infinite spinner because the client waits for a field
that never arrives.

## 7 Input

```
empty every optional field, then every required one
the minimum and maximum of every constrained field
one beyond each boundary
whitespace only
a very long string in every free text field
characters from a script the product claims to support
a file of the wrong type, of zero bytes, and at the size limit
```

Look for: validation only on the client, silent truncation, layout breaking on
real content, a 500 instead of a 422, an error that names a database column.

## 8 Sequence

```
skip a step by URL
return to a completed step and change it
resume an old link after the state moved on
complete a flow twice from a bookmarked intermediate page
act on a record that was deleted in another tab
```

Look for: state machines that accept transitions the interface never offers,
completed operations that can be completed again, actions on deleted rows that
recreate them.

## 9 Environment

```
narrowest and widest supported width
browser zoom at 200 percent
a second supported locale
a timezone far from the server's
a date near midnight, and near a month boundary
```

Look for: content clipped or overlapping, a date one day off, currency or
number formats that ignore the locale, layout that only works at the width the
developer used.

## Result sheet

```
feature: <name>            environment: <name>           build: <commit>

family        result   note
repetition    hit      duplicate mail, 2 of 3, see BUG-14
concurrency   ok       second save rejected with a clear conflict
interruption  hit      unsaved changes lost with no prompt, 3 of 3
session       hit      401 not handled, input lost, 2 of 2
network       ok       failure surfaces a retryable error
response      n/a      client rendering not in this campaign's scope
input         hit      500 on a 300 character name, 3 of 3
sequence      ok       step skipping redirects correctly
environment   hit      table overflows at 360 px, 3 of 3
```
