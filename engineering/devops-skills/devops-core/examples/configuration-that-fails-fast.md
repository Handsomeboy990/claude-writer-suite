# Example: the default that signed production sessions

## The code that shipped

```ts
// lib/config.ts
export const config = {
  sessionSecret: process.env.SESSION_SECRET ?? "dev-secret-change-me",
  databaseUrl: process.env.DATABASE_URL ?? "postgres://localhost:5432/app_dev",
  storageBucket: process.env.STORAGE_BUCKET ?? "app-uploads-dev",
  mailFrom: process.env.MAIL_FROM ?? "noreply@localhost",
}
```

Every line is a convenience that works locally. Three of the four are
production incidents waiting for a missing variable.

## What each default does in production

**`sessionSecret`.** The application starts. Sessions are signed with a string
that is in the public repository. Anyone who reads the code can forge a
session cookie for any user. Nothing logs an error, nothing alerts, and the
system behaves perfectly.

This is the worst kind of defect: it produces no symptom until it is
exploited.

**`databaseUrl`.** In a container with no PostgreSQL, the connection is
refused and the failure is obvious. In a container that happens to run one, it
silently connects to an empty local database, and the application serves a
system with no data as though it were new.

**`storageBucket`.** Uploads go to the development bucket. Production files
land in a bucket with a seven day retention policy. The failure appears eight
days later, as missing files with no error anywhere.

**`mailFrom`.** Mail is sent from `noreply@localhost`, which the provider
rejects or the recipient's server discards. Users report not receiving
emails; the logs say the send succeeded.

## The replacement

```ts
// lib/config.ts
function required(name: string): string {
  const value = process.env[name]
  if (!value) {
    console.error(`Configuration error: ${name} is not set. Refusing to start.`)
    process.exit(1)
  }
  return value
}

function optional(name: string, fallback: string): string {
  return process.env[name] ?? fallback
}

export const config = {
  sessionSecret: required("SESSION_SECRET"),
  databaseUrl: required("DATABASE_URL"),
  storageBucket: required("STORAGE_BUCKET"),
  mailFrom: optional("MAIL_FROM", "noreply@example.com"),
  logLevel: optional("LOG_LEVEL", "info"),
}
```

Three variables are required and the process refuses to start without them.
Two have defaults because they are genuinely optional: a wrong log level is a
nuisance, and `mailFrom` has a sensible non local default.

The distinction is not stylistic. `required` is for anything whose absence
makes the system wrong rather than merely different.

## Validation at the boundary, not at first use

```ts
// The config module is imported at startup, not lazily.
// app/layout.tsx or the server entry point:
import "@/lib/config"
```

A configuration error should stop the process at second zero, not at the first
request that happens to need the storage bucket, forty minutes into a
deployment that already replaced the previous version.

## What this changed at deployment

The first production deploy after this change failed immediately:

```
Configuration error: STORAGE_BUCKET is not set. Refusing to start.
```

The deploy rolled back automatically because the health check never passed.
Total user impact: none.

Under the previous version, that same deploy would have succeeded, and
uploads would have gone to the development bucket until someone noticed
missing files a week later.

A failed deploy with a clear message is a good outcome. It is the visible
version of a problem that was previously invisible.

## The parity table that explained a different bug

```
| Dimension | Staging | Production | Consequence |
|---|---|---|---|
| instance count | 1 | 4 | staging cannot reproduce any concurrency defect |
| data volume | 800 orders | 340,000 orders | staging cannot reveal a missing index |
| runtime | Node 24 | Node 24 | none |
| database | PostgreSQL 16 | PostgreSQL 16, managed | connection limit differs, 100 versus 20 |
| external services | provider sandbox | live | sandbox never rate limits |
```

Row one explained a duplicate order bug that never reproduced in staging: the
idempotency check was a read followed by a write, which is safe with one
instance and a race with four.

Row four explained a connection exhaustion incident: the pool was sized for
staging's limit.

Neither was a code defect discovered by testing. Both were parity gaps that
became visible the moment they were written down.
