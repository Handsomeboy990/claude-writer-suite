# Leak response

A credential has appeared somewhere it should not. Work in this order. The
first step is rotation, not deletion.

## Step 1, rotate, immediately

```
Create the replacement credential.
Set it in every environment that uses the old one.
Deploy or restart what needs it.
Verify the system works on the new credential.
```

Everything else can wait. While the old credential is valid, the exposure is
live.

## Step 2, assess before revoking

```
What did it grant       read, write, delete, spend, impersonate
Which environment       staging only, or production
How long exposed        from the commit or publication date to now
Where exposed           public repository, private repository, log, message,
                        screenshot, third party service
Evidence of use         the provider's access log, checked now, before it
                        rolls off
```

The access log is time sensitive. Many providers keep it for days, and it is
the only source that answers whether the leak was used.

## Step 3, revoke

Once the new credential is confirmed working, revoke the old one. Not before:
revoking first turns a security event into an outage, and outages create
pressure that produces further mistakes.

## Step 4, remove

Remove the value from wherever it appeared. This is housekeeping, not
remediation.

```
Working tree     delete it, commit the removal
History          rewrite only when the repository is private, coordinated with
                 everyone who has a clone; otherwise accept it is public
Logs             purge where the platform allows, note where it does not
Messages         delete where possible, and assume it was read
Third parties    ask for deletion, and assume caches remain
```

Never treat a history rewrite as remediation. A pushed secret has been
available to every clone, fork, mirror and platform cache since the moment it
was pushed.

## Step 5, prevent

Ask how it got there and fix that, not the instance.

| How it got there | Prevention |
|---|---|
| pasted into a file to test something | a local `.env` that is ignored, and a scan on the staged diff |
| committed in an example file | example files hold empty values, checked by the drift check |
| logged by a debug statement | redaction at the logger, not at the call site |
| passed on a command line | environment injection instead |
| in a screenshot for documentation | a policy that documentation shows formats, never values |
| baked into a container image | build arguments never used for secrets, runtime injection instead |
| shared in a message to onboard someone | a secret store with per person access |

## Step 6, record

```
Leaked:        which credential, which environment
Exposed:       from when, to when, where
Granted:       what the credential allowed
Evidence:      access log findings, or: no evidence, log covered N days
Rotated:       when, by whom
Revoked:       when
Removed:       where from, and where it remains public
Prevention:    what changed so this class does not recur
Uncertain:     what is not known, stated plainly
```

The `Uncertain` line matters. The honest statement reads: no evidence of use,
but the provider log covers only seven days and the exposure lasted three
months. That is what a client needs in order to decide whether to notify
anyone.

## Severity, for deciding how fast

| Situation | Response |
|---|---|
| production credential in a public repository | drop everything, rotate now |
| production credential in a private repository | rotate today |
| production credential in a log with broad access | rotate today |
| staging credential in a public repository | rotate today; it identifies the account |
| test or sandbox credential, public | rotate this week; still a credential |
| a credential in a message to a colleague | rotate at the next convenient point, and fix the sharing practice |

There is no row for `leave it`. A credential that is not worth rotating was
not worth treating as a secret.

## What not to do

- Do not delete first and rotate later.
- Do not decide the exposure was probably harmless without checking the access
  log.
- Do not rewrite public history and report the leak as resolved.
- Do not skip rotation because the credential is only for staging.
- Do not tell a client the secret was removed when what they need to know is
  whether it was rotated.
