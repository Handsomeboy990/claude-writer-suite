# Example: four deployments that reported success

Each one exited zero. Each one was broken. Each was caught by a different
check, none of which is expensive.

## 1. The deployment that deployed nothing

```
Deploy tool:  success, 42 seconds
Health check: 200
Error rate:   unchanged
```

Everything green. The check that failed:

```bash
$ curl -sS https://app.example.com/version
{"commit":"7c1a904","startedAt":"2026-07-28T09:14:02Z"}
```

`7c1a904` was two weeks old. The deployed commit was `a91f0c2`.

The platform had built the image, tagged it, and failed to update the service
definition because a permission had changed. The build succeeded, the push
succeeded, nothing rolled out, and every health signal reported the old
version as healthy, which it was.

Without the version check, the team would have spent the afternoon wondering
why the fix was not working in production.

Cost of the check: one curl.

## 2. The deployment where the guard disappeared

```
1  Availability   pass
2  Version        pass
3  Health         pass
4  Authentication pass, sign in works
5  Authorization  FAIL
```

```bash
# signed in as a user belonging to team A, requesting team B
$ curl -sS -H "Cookie: sid=$SESSION" \
    https://app.example.com/api/teams/team_b/invitations
[{"id":"inv_...","email":"..."}]
```

Two hundred and a list of another team's invitations.

Cause: the release changed the middleware matcher, and the team routes fell
outside it. Every positive test passed, because a member of team A can read
team A. Only the negative check finds it.

Rolled back in six minutes. The matcher was fixed, a test was added that
asserts the 403, and the deployment went out again the same day.

This is why the negative authorization check is in the list rather than
implied by the test suite: the test suite ran against the code, and the defect
was in the routing configuration.

## 3. The deployment that was correct and four times slower

```
1 to 12       all pass
13 Performance FAIL
```

```
p95 on /dashboard, before: 1.4s
p95 on /dashboard, after:  6.1s
Budget:                    2s
```

The release added a field to the dashboard response. The field came from a
relation loaded per row, which is the N plus 1 pattern, invisible in
development against 40 seeded rows and decisive against 340,000.

Decision, against the threshold set beforehand: roll back. The fix was
understood within twenty minutes, but the threshold said roll back and the
threshold was set when nobody was under pressure.

The fix, a join, shipped two hours later with a p95 of 1.5s.

## 4. The deployment whose headers were in a file

```
1 to 10        pass
11 Headers     FAIL
```

```bash
$ curl -sSI https://app.example.com/ | grep -i content-security-policy
# nothing
```

The policy was in the framework configuration, correct, reviewed and merged.
The platform's edge configuration was terminating and re-emitting responses,
and the header was not being forwarded.

The configuration file said the header existed. Only a real response said it
did not.

Not a rollback: no user impact, and the fix was a platform setting. Recorded,
fixed within the hour, re-verified.

## What the four have in common

None of them would have been caught by:

```
the pipeline being green         all four had green pipelines
the deploy tool reporting success all four reported success
the health check passing          all four passed health
watching the error rate           only case 3 moved it, and slowly
```

Each was caught by a check that takes under a minute and that exercises the
real deployed system rather than reading configuration.

## The total cost

The full thirteen check pass takes eight to twelve minutes when scripted, of
which most is the journey step.

Against: an afternoon lost to a phantom fix, another team's data exposed for
an unknown period, a dashboard four times slower for however long it took
someone to complain, and a security header believed present for weeks.
