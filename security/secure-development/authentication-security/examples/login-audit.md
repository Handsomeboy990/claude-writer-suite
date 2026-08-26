# Example: auditing an existing login flow

A Node/Express login handler brought in for review. Findings ranked, fixes
applied and verified, one action handed to the infrastructure list.

## What was found

```
finding 1  passwords stored with a single SHA-256 and a static salt
           severity critical: one database leak cracks the whole table cheaply
           file: src/auth/user.model.js:34

finding 2  login returns "no account with that email" on an unknown address
           severity medium: account enumeration, feeds credential stuffing
           file: src/auth/login.js:19

finding 3  no rate limit on the login endpoint
           severity high: unlimited credential-stuffing attempts
           file: src/auth/routes.js:8

finding 4  the JWT has a 30-day expiry and no server-side revocation; logout
           only deletes the client cookie
           severity high: a stolen token is valid for 30 days, unrevocable
           file: src/auth/token.js:12
```

## Fixes applied and verified

```
finding 1  migrated to argon2id; existing hashes upgraded on next successful
           login (verify old, re-hash new), flagged for a forced reset campaign.
           Verified: a new password produces an argon2id hash; the old column
           is dropped after migration.

finding 2  both branches now return "invalid email or password", and the
           not-found path performs a dummy hash so timing does not leak.
           Verified: response body and response time are indistinguishable for
           a known and an unknown email over 1000 samples.

finding 3  added a per-account and per-IP limiter with exponential backoff.
           Verified: the 6th failed attempt in a minute is refused; a legitimate
           user on a fresh account is not affected.

finding 4  access token cut to 15 minutes, refresh token stored server-side and
           revoked on logout, reset and password change.
           Verified: logout invalidates the refresh token; a replayed access
           token fails after 15 minutes.
```

## Handed to the infrastructure list

```
- Force a password reset for all users, since finding 1 means every stored hash
  should be treated as crackable. Rotation, not a code change.
```

## Result

Two critical/high findings closed at the storage and token layers, enumeration
removed in text and timing, and one rotation action named rather than silently
skipped. The audit reports these six checks on this revision; it does not
conclude the login is secure.
