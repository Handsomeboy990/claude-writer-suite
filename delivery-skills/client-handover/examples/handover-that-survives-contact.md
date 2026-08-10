# Example: the handover section that saved the project

Delivery of the training platform. The maintaining team is two internal
developers who did not build it.

## The installation section, first draft

```bash
npm install
npm run dev
```

Written from memory by someone whose machine already had Node 24, PostgreSQL
running, a populated `.env`, and the database migrated.

## What happened when it was tested on a clean container

```
$ npm install
npm error engine Unsupported engine: required node >=24, current v20.11.1

# after installing Node 24
$ npm run dev
Error: DATABASE_URL is not set

# after guessing a DATABASE_URL
$ npm run dev
Error: connect ECONNREFUSED 127.0.0.1:5432

# after starting PostgreSQL
$ npm run dev
Error: relation "users" does not exist

# after finding the migration command in package.json
$ npm run db:migrate
Error: SESSION_SECRET is not set

# after generating one
$ npm run db:migrate && npm run dev
ready on http://localhost:3000

# opening it
500, no seed data, the sign in page cannot be reached without a user
```

Seven failures between the written instructions and a working application.
Each one is an hour of a new engineer's first day, and each one produces the
impression that the delivery is broken.

## The installation section, as delivered

````markdown
## Installation

Prerequisites:
- Node.js 24 or later (`node --version`)
- PostgreSQL 16 or later, running and reachable
- npm 10 or later

1. Obtain the code and install dependencies.

```bash
git clone <repository> formation
cd formation
npm install
```

2. Create the database.

```bash
createdb formation_dev
```

3. Configure. Copy the example file and fill in the four required values.

```bash
cp .env.example .env
```

| Variable | Purpose | Required | Format | Source |
|---|---|---|---|---|
| DATABASE_URL | database connection | yes | postgres://user:pass@host:5432/db | your local instance |
| SESSION_SECRET | signs session cookies | yes | 32+ random bytes, base64 | generate: `openssl rand -base64 32` |
| STORAGE_BUCKET | course material storage | yes | bucket name | the client's object storage console |
| STORAGE_KEY | storage access | yes | provider key | the client's object storage console |
| MAIL_API_KEY | attestation emails | no | provider key | not configured, see limitation L2 |

4. Migrate and seed.

```bash
npm run db:migrate
npm run db:seed
```

The seed creates one trainer (`formateur@example.test`) and one trainee
(`stagiaire@example.test`), both with the password printed by the seed
command. These accounts exist in development only; `db:seed` refuses to run
when `NODE_ENV` is `production`.

5. Run.

```bash
npm run dev
```

Expected output:

```
ready on http://localhost:3000
database connected
```

6. Verify the installation.

Open http://localhost:3000, sign in as the seeded trainer, and confirm the
dashboard lists one example course. If the dashboard is empty, step 4 did not
complete; re-run `npm run db:seed` and read its output.

Common first run problems:

| Symptom | Cause | Fix |
|---|---|---|
| Unsupported engine | Node below 24 | install Node 24 |
| DATABASE_URL is not set | step 3 skipped | copy and fill `.env` |
| ECONNREFUSED 5432 | PostgreSQL not running | start it |
| relation does not exist | step 4 skipped | `npm run db:migrate` |
| sign in page has no accounts | seed not run | `npm run db:seed` |
````

## The difference

The second version was produced by running the first version on a clean
container and writing down what actually happened, including the failures.
It took forty minutes.

The failure table at the end is the part the maintaining team used. Every row
in it is a real error message someone will paste into a search engine, and
finding it in the handover instead is the difference between a smooth first
day and a support call.

## The limitations section, as delivered

```
| # | Limitation | Consequence | Trigger |
|---|---|---|---|
| L1 | course list is not paginated | slow above roughly 500 courses | when the catalogue passes 300 |
| L2 | attestation email delivery not configured | trainees download; no email is sent | when the client creates the mail provider account; the adapter is written and throws a named error until then |
| L3 | single organisation | a second client needs a second deployment | if multi tenancy is wanted; this is a data model change, not a configuration one |
| L4 | French only | no other locale | before a non French cohort; strings are inline, so this is roughly a week |
| L5 | backup restore never tested | recovery time unknown | before the platform holds attestations that exist nowhere else |
```

L5 is the uncomfortable one and the one that mattered. The backups existed and
ran nightly. Nobody had ever restored one, so the honest statement is that
recovery is untested, not that backups are in place.

The client read L5, scheduled a restore drill in their own environment, and
discovered the backup job had been writing to a bucket their retention policy
emptied weekly. That was found in month one instead of during an incident.

## What made the package work

Nothing in it is clever. The installation was executed rather than
remembered, the feature table was built by using the running system, and the
limitations were written without softening.

The section that is always tempting to skip, L5, is the one that returned the
most value, because it was the one that admitted something had not been
verified.
