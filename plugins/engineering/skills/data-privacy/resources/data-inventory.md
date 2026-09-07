# Data inventory

The document everything else depends on. Incomplete on the copies is the usual
failure, and the copies are where incidents happen.

## Per field

```
field            users.email
category         identifier, contact
purpose          authentication, transactional mail
basis            contract
collected from   the user, at signup
stored in        users table
copies in        mail provider, error tracking (redacted), support tool,
                 data warehouse, backups
readable by      the user, organisation admins, support role, engineers with
                 production access (logged)
retention        life of the account, then 30 days
deletion         row deleted, mail provider contact deleted by API, warehouse
                 row deleted by the nightly job, backups expire at 90 days
export           included in the subject export
sensitive        no
```

## The copies checklist

For every field, ask where else it exists:

```
primary database
read replicas
cache
search index
queue messages, and their retention
object storage: uploads, exports, generated documents
logs, application and access
error tracking and traces
analytics and product telemetry
session recording, if any
mail provider
support and CRM tools
data warehouse and reporting
backups, and their retention
non production environments
local machines: exports, dumps, screenshots
third party integrations
```

Seventeen places. Most inventories list two, which is why erasure requests
fail.

## Sensitive categories

Flag explicitly, because they change the obligations and the access rules:

```
health, biometrics, genetic data
racial or ethnic origin, religious or philosophical beliefs
political opinions, trade union membership
sexual orientation or sex life
criminal convictions
precise location
data about children
financial detail beyond what payment requires
```

If the product holds any of these, access logging, encryption and retention
deserve their own review rather than the general one.

## Retention table

```
category                  period            reason               enforced by
account data              life + 30 days    account recovery     deletion job
invoices, accounting      10 years          legal obligation     none, retained
support conversations     3 years           dispute resolution   monthly job
application logs          30 days           debugging            log platform
access logs               1 year            security             log platform
analytics events          14 months         product analysis     provider config
backups                   90 days           recovery             backup policy
session recordings        30 days           usability            provider config
error reports             90 days           debugging            provider config
```

An entry with `enforced by: none` is either a legal obligation or a defect.

## Erasure procedure

```
1  identify every store from the inventory
2  delete or anonymise in each, in an order that does not break references
3  request deletion from every processor, through its documented mechanism
4  record what was deleted, when, and by which procedure
5  name what is retained and why: accounting records, fraud prevention, an
   ongoing legal claim
6  verify: run the export procedure afterwards and confirm it returns only
   what was deliberately retained
```

Step 6 is the test. An erasure that has never been followed by an export is an
assumption.

## Verification queries

```
a deleted user's identifier appears in no table that should not retain it
the search index returns nothing for their email
the warehouse has no row for them beyond the retained aggregates
the mail provider has no contact
an export for a live account contains every field the inventory lists
no log line from the last 30 days contains an email address
no analytics event uses an email as an identifier
```

The last two run continuously, not once. Personal data returns to logs with
every new feature that logs a user object.
