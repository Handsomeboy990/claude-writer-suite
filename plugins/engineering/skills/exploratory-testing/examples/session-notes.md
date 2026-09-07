# Example: one session, notes as they were taken

## Charter

```
Explore the document sharing flow as an editor and as a viewer to discover
what happens when a share is revoked while the other person is using it.

Time box   45 minutes
Tours      interruption, supporting actor, obsessive
Start      staging, commit 4c17ab9, two accounts in the same workspace
```

## Notes

```
00:04  Editor shares a document with viewer@example.test, role viewer.
       Toast "Shared". Row appears. Good.

00:07  Viewer opens the link in a second browser. Document renders read only.
       Expected.

00:09  Editor revokes the share. Viewer's tab still shows the document.
       Viewer scrolls, still readable. Refresh -> access denied page.
       FINDING 1. Revocation only takes effect on reload. Anyone with the tab
       open keeps reading. Reproduced twice from clean state.
       Evidence: screenshot revoke-still-visible.png, network shows no push,
       no polling on this route.

00:15  Access denied page has no navigation. No header, no link home, browser
       back returns to the document shell which then also denies.
       FINDING 2. Dead end. Reproduced. Evidence: denied-dead-end.png.

00:19  Editor shares again with the same address. Second row appears in the
       list, same person twice, both active.
       FINDING 3. Duplicate share not collapsed. Revoking one leaves the
       other, which is why the viewer still had access on the first attempt
       during my second reproduction. Reproduced 3 of 3.

00:26  Obsessive: click Share twice quickly on a new address.
       Two invitation mails in the sandbox, one row in the list.
       FINDING 4. Duplicate mail from a single intent. Reproduced 2 of 3,
       intermittent, depends on how fast the second click lands.

00:31  Supporting actor: workspace with no documents at all.
       Empty state says "No documents". No explanation, no create button, and
       the create action lives in a menu three clicks away.
       OBSERVATION, not a defect: nothing is broken. Recorded as usability
       with the click count as evidence.

00:38  Session expiry: left the viewer tab idle past the session lifetime,
       then clicked a comment. Comment box accepted the text, spinner, then
       silence. No error, no redirect, text lost.
       FINDING 5. Silent failure on expired session, and the comment is gone.
       Reproduced 2 of 2. Evidence: console shows 401, no handler.

00:45  Box closed. Not reached: mobile widths, the viewer's own share list,
       export. Next charter proposed below.
```

## Findings, ranked by consequence

```
1  Revocation is not enforced on an open session          High
   Access continues until the page is reloaded. Security relevant,
   handed to security-testing for the authorization angle.

2  Silent failure and lost input on expired session       High
   The user believes the comment was posted. It was not.

3  Duplicate active shares for one address                Medium
   Makes revocation unreliable and confused this session for six minutes.

4  Duplicate invitation mail on double click              Medium
   Intermittent, 2 of 3. No idempotency on the share action.

5  Access denied page is a dead end                       Low
   Recoverable with the browser, but the application offers no way out.

Observation, not a defect
   Creating a first document takes three clicks from an empty workspace,
   and the empty state does not mention it.
```

## What this session did not cover

Mobile widths, the viewer side of the share list, and export. Both are the
next two charters, and they are named rather than left implied.

## What happened to the findings

Findings 1 and 2 went to `security-testing` and `frontend-engineering`.
Findings 1, 2 and 3 became permanent tests through `testing-quality`, at the
integration layer for revocation and at the browser layer for the expired
session, because the silent failure only exists in the browser. Finding 4 went
to `bug-hunting` to be confirmed systematically rather than by feel, and it
was: the endpoint has no idempotency key.
