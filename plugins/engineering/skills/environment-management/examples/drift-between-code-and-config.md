# Example: five kinds of drift, found by two scripts

The project had been running for eight months. Nobody had compared the code
against the configuration.

## Direction one, code to inventory

```bash
grep -rhoE 'process\.env\.[A-Z_][A-Z0-9_]*' src app lib \
  | sed 's/process\.env\.//' | sort -u > /tmp/in-code.txt

grep -oE '^\| [A-Z_][A-Z0-9_]* ' docs/environment.md \
  | tr -d '| ' | sort -u > /tmp/in-inventory.txt

comm -23 /tmp/in-code.txt /tmp/in-inventory.txt
```

```
ANALYTICS_WRITE_KEY
LEGACY_API_URL
SENTRY_DSN
```

Three variables the code reads and nobody documented.

`SENTRY_DSN` was the interesting one. It had been added six months earlier, was
set in production, and was absent from staging. Error reporting had therefore
never worked in staging, which explained a long standing belief that staging
produced fewer errors than production.

`LEGACY_API_URL` was read by a module that no longer ran. Dead configuration
for dead code.

## Direction two, inventory to code

```bash
comm -13 /tmp/in-code.txt /tmp/in-inventory.txt
```

```
REDIS_URL
FEATURE_NEW_CHECKOUT
SMTP_HOST
SMTP_PORT
SMTP_USER
```

Five documented variables that nothing reads.

`REDIS_URL` remained from a caching layer removed in March. It was still set
in production, still pointing at a managed Redis instance, still being billed
at 30 EUR per month for a service nothing connected to.

The four `SMTP_*` variables remained from before the migration to an API based
mail provider. One of them, `SMTP_USER`, was a real credential still valid on
the old server.

## Direction three, inventory to example file

```bash
grep -oE '^[A-Z_][A-Z0-9_]*=' .env.example | tr -d '=' | sort -u \
  > /tmp/in-example.txt
comm -23 /tmp/in-inventory.txt /tmp/in-example.txt
```

```
PUBLIC_APP_URL
STORAGE_BUCKET
```

Two required variables missing from the example file. Every new developer
discovered them by hitting a runtime error, which is why the onboarding
instructions in the team wiki contained the sentence "if you get a storage
error, ask someone for the bucket name".

## Direction four, example file to inventory

```bash
comm -13 /tmp/in-inventory.txt /tmp/in-example.txt
```

```
DEBUG_SQL
```

Undocumented, read nowhere, present in the example file. A developer had added
it locally, committed the example file, and the variable never existed in the
code.

## Direction five, required variables against the target environment

The check that belongs in the pipeline:

```bash
# fail the deploy before it starts, not after
missing=""
for var in $(grep -E '\| yes \|' docs/environment.md | awk '{print $2}'); do
  if [ -z "$(printenv "$var")" ]; then
    missing="$missing $var"
  fi
done
if [ -n "$missing" ]; then
  echo "Missing required variables in this environment:$missing"
  exit 1
fi
```

Run against staging, it reported:

```
Missing required variables in this environment: SENTRY_DSN PUBLIC_APP_URL
```

`PUBLIC_APP_URL` being absent in staging meant every email sent from staging
contained links to production. Nobody had noticed, because staging emails
mostly went to team members who clicked the link and landed somewhere
plausible.

## What the sweep produced

```
Removed from the code       LEGACY_API_URL and its dead module
Removed from the inventory  REDIS_URL, SMTP_HOST, SMTP_PORT, SMTP_USER
Removed from the platform   REDIS_URL, and the Redis instance, 30 EUR monthly
Rotated                     SMTP_USER, still valid, now revoked
Documented                  ANALYTICS_WRITE_KEY, SENTRY_DSN
Added to the example        PUBLIC_APP_URL, STORAGE_BUCKET
Removed from the example    DEBUG_SQL
Set in staging              SENTRY_DSN, PUBLIC_APP_URL
Added to the pipeline       the direction five check, on every deploy
```

## Cost and return

Four shell commands, roughly two hours including the cleanup and the
rotation.

Found: one live credential for a decommissioned server, one service billed for
nothing, error reporting that had never worked in staging, staging emails
pointing at production, and an onboarding step that existed only in a wiki
sentence.

None of these produced a visible failure. That is why they had survived eight
months, and why the drift check belongs in the pipeline rather than in
someone's memory.
