# Variable inventory template

The source of truth for configuration. Kept in the project's documentation
directory and updated in the same change that adds or removes a variable.

````markdown
# Environment variables

Values never appear in this file.

| Name | Purpose | Required | Format | Local | Dev | Staging | Prod | Secret |
|---|---|---|---|---|---|---|---|---|
| DATABASE_URL | database connection | yes | postgres://user:pass@host:port/db | set | set | set | set | yes |
| SESSION_SECRET | signs session cookies | yes | 32+ random bytes, base64 | set | set | set | set | yes |
| STORAGE_BUCKET | course material storage | yes | bucket name | set | set | set | set | no |
| STORAGE_KEY | storage access | yes | provider key | set | set | set | set | yes |
| STRIPE_SECRET_KEY | payment API | yes | sk_test_ or sk_live_ prefix | set | set | set | set | yes |
| STRIPE_WEBHOOK_SECRET | webhook signature verification | yes | whsec_ prefix | set | set | set | set | yes |
| MAIL_API_KEY | outbound mail | no | provider key | absent | set | set | set | yes |
| MAIL_FROM | sender address | no | email address | default | set | set | set | no |
| LOG_LEVEL | log verbosity | no | debug\|info\|warn\|error | default | default | set | set | no |
| PUBLIC_APP_URL | absolute links in emails | yes | https URL, no trailing slash | set | set | set | set | no |

## Absence behaviour

| Name | When absent |
|---|---|
| DATABASE_URL | process exits 1 at startup |
| SESSION_SECRET | process exits 1 at startup |
| STORAGE_BUCKET | process exits 1 at startup |
| STORAGE_KEY | process exits 1 at startup |
| STRIPE_SECRET_KEY | process exits 1 at startup |
| STRIPE_WEBHOOK_SECRET | process exits 1 at startup |
| MAIL_API_KEY | mail adapter throws NotConfigured; the feature reports itself unavailable |
| MAIL_FROM | defaults to noreply@example.com |
| LOG_LEVEL | defaults to info |
| PUBLIC_APP_URL | process exits 1 at startup |

## Sources

| Name | Where the value comes from |
|---|---|
| DATABASE_URL | the managed database console, connection tab |
| SESSION_SECRET | generated: openssl rand -base64 32, then stored in the vault |
| STORAGE_BUCKET | the storage console, bucket name |
| STORAGE_KEY | the storage console, access keys |
| STRIPE_SECRET_KEY | Stripe dashboard, developers, API keys |
| STRIPE_WEBHOOK_SECRET | Stripe dashboard, the webhook endpoint's signing secret |
| MAIL_API_KEY | the mail provider console |

## Rotation

| Name | How | What restarts |
|---|---|---|
| SESSION_SECRET | generate, set, deploy | all instances; every session is invalidated, users sign in again |
| STRIPE_SECRET_KEY | create a new key, set, deploy, revoke the old one | all instances; do not revoke before the deploy completes |
| STRIPE_WEBHOOK_SECRET | roll in the dashboard, set, deploy | all instances; the dashboard supports two active secrets during the window |
| STORAGE_KEY | create, set, deploy, revoke | all instances |
````

## The three columns that get filled wrong

**`Required`.** Means the process should refuse to start without it, not that
the feature needs it. `MAIL_API_KEY` is not required: the system runs without
mail and says so. `SESSION_SECRET` is required: the system must not run
without it.

**`Secret`.** Decides where the value comes from, not how sensitive it feels.
A bucket name is not secret. A bucket access key is. Marking non secrets as
secret makes the secret store noisy and the real secrets less visible.

**Environment columns.** `set`, `default` or `absent`. Writing the value here
is the single most common way a credential enters a repository, because this
table looks like documentation rather than configuration.

## Rotation is part of the inventory

The rotation table is what turns a leaked credential from an incident into a
procedure. Without it, the response to a leak begins with someone working out
what will break.

The `SESSION_SECRET` row is worth its space: rotating it signs out every user,
which is a decision someone should make knowingly rather than discover.
