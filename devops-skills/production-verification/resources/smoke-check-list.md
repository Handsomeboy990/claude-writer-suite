# Smoke check list

Run against the deployed system, in order. Stop at the first failure and
decide per the rollback criteria.

## 1. Availability

```bash
curl -sS -o /dev/null -w '%{http_code} %{time_total}s\n' https://<host>/
```
Expect: 200, and a time within the normal range.

```bash
curl -sSI https://<host>/ | grep -i '^strict-transport-security'
echo | openssl s_client -connect <host>:443 2>/dev/null | openssl x509 -noout -dates
```
Expect: the header present, the certificate not near expiry.

## 2. Version

```bash
curl -sS https://<host>/version
```
Expect: the commit that was just deployed.

This is the cheapest check and it catches the failure mode where the platform
reported success and kept serving the previous version.

## 3. Health

```bash
curl -sS https://<host>/health/ready
```
Expect: 200. On platforms exposing individual instances, check each.

## 4. Authentication

```
sign in with a known test account          -> session established
a wrong password                            -> refused, generic message
a request with the session                  -> succeeds
sign out                                    -> the session no longer works
```

## 5. Authorization, negative

```
a signed in account without rights requests a resource it does not own
   -> 403 or 404, per the contract, and no data in the body
```

One negative check. It catches a configuration that disabled a guard, which no
positive check finds.

## 6. Critical journeys

The two or three whose failure is an incident. Scripted where
`playwright-automation` is available, otherwise by hand.

```
| Journey | Steps | Expected |
|---|---|---|
| sign up | | |
| the primary product action | | |
| payment or the main money path | | |
```

## 7. Data

```
read      a list endpoint returns real records
write     create a marked test record
re-read   it is present after a fresh request
schema    where the release changed the schema, the new field is present
```

## 8. External services

```
| Service | Check | Safe method |
|---|---|---|
| payments | a charge | provider test mode |
| mail | a send | to a reserved address, or the provider's log |
| storage | an upload and a read back | a marked test object |
| search or third party API | one query | read only |
```

Never a real charge, never a message to a real recipient.

## 9. Assets

```bash
curl -sSI https://<host>/<a hashed asset> | grep -iE 'cache-control|content-type'
```
Expect: the new bundle served, long cache on hashed assets, correct type.

Load one page and confirm it renders rather than showing an application error.

## 10. Configuration

```bash
curl -sS https://<host>/version   # where it reports non secret config flags
```
Or the platform's variable listing. Confirm the required set is present, and
that feature flags are in their intended state.

## 11. Security headers

```bash
curl -sSI https://<host>/ | grep -iE \
  'content-security-policy|strict-transport-security|x-frame-options|frame-ancestors|x-content-type-options|referrer-policy'
```
Expect: the set the architecture specified, on a real response.

Headers present in a configuration file and absent from a response is a
routine finding, and only this check catches it.

## 12. Logs and errors

```
the deployment produced log lines from the new version
no new error class in the reporter
the correlation identifier from a smoke request appears in the logs
```

## 13. Performance

```bash
for i in 1 2 3 4 5; do
  curl -sS -o /dev/null -w '%{time_total}\n' https://<host>/<critical path>
done
```
Expect: within the budget from the architecture. Report the spread, not one
sample.

## Test data hygiene

```
Addresses     @example.test or another reserved domain
Names         marked, for example "SMOKE 2026-08-11"
Record        what was created, where
Remove        after verification, and confirm removal
```

```
Created: 1 user usr_01J..., 1 order ord_01J..., marked SMOKE 2026-08-11
Removed: 15:12, confirmed by re-query returning zero rows
```

## Watch window

```
Duration     15 to 60 minutes, from the deployment plan
Error rate   current versus the pre deployment baseline
Latency      p95 on the critical path
Domain       the metric that says the product works
Threshold    decided before deploying; crossing it triggers rollback
```

## Verdict

```
verified            every applicable check passed, watch window clean
verified with notes passed, with an observation recorded
rolled back         a check failed, the rollback was executed and verified
```

There is no verdict meaning "probably fine". A check that could not be run is
reported as not run, with the reason.
