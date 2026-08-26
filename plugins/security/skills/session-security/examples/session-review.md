# Example: reviewing a web session implementation

A cookie-based session for a healthcare portal. High-value assets, so timeouts
are tight and revocation must be real.

## Findings

```
1  session cookie has no SameSite attribute
   severity high: CSRF rides the session on state-changing requests
   file: src/session/cookie.js:14

2  the session id is not rotated on login; the pre-login id is kept
   severity high: session fixation; an attacker who sets the id keeps it
   file: src/session/login.js:31

3  logout deletes the client cookie but leaves the server record valid
   severity high: a captured session works after the user logs out
   file: src/session/logout.js:6

4  no absolute timeout; idle timeout is 24 hours
   severity medium: a stolen session lives a day, renewed by any activity
   file: src/session/config.js:9
```

## Fixes and verification

```
1  set SameSite=Lax and added a per-request CSRF token on POST/PUT/DELETE.
   Verified: a cross-site form POST is rejected; the same-site app works.

2  the session store issues a fresh id inside the login transaction and drops
   the old one.
   Verified: the id in the cookie before and after login differs; a pre-set id
   does not survive login.

3  logout now deletes the server-side session record and the cookie.
   Verified: replaying the captured cookie after logout returns 401.

4  absolute timeout set to 8 hours, idle timeout to 15 minutes, matched to the
   asset and confirmed with the product owner.
   Verified: a session older than 8 hours is refused regardless of activity;
   15 minutes idle expires it.
```

## Result

Four findings closed at the cookie, fixation, revocation and timeout layers. The
review reports these checks on this revision; it does not conclude the session
layer is secure. One note handed over: the session store is a single Redis
instance, so its availability and its own access control are an infrastructure
concern recorded for the operations owner.
