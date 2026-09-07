# Example: resisting the wrong architecture

Request: "we need a notification system, users should get emails and in app
alerts, and later push".

## The design that gets proposed by reflex

```
notification-service, separate deployable
  -> message broker
    -> email-worker
    -> in-app-worker
    -> push-worker (empty, for later)
  -> template-service
  -> preferences-service
```

Six moving parts, three of them unused on day one, and a broker to operate.

## The forces, written down

```
Constraint   one PostgreSQL, one Node process, two engineers, single deploy
Load         measured from the existing mailer: 400 emails per day, peak 30
             per minute during the daily digest
Failure cost a missed notification annoys a user; no money and no data loss
Change rate  the team expects one new channel per year, not per month
```

Nothing in these four lines pays for a broker, a separate service or three
workers. The push channel is a future maybe, and designing for a maybe is how
teams end up maintaining an empty worker for two years.

## The design that ships

```
lib/notifications/
  index.ts        notify(userId, event, payload)
  channels/
    email.ts      existing mailer, unchanged
    in-app.ts     insert into notifications table
  templates/      one file per event
  preferences.ts  reads user_notification_preferences
```

One module. One owner of the `notifications` table. Channels are functions
behind a common signature, selected by user preference.

```
Decision: a single in process module with a channel map.
Ownership: lib/notifications is the only writer of notifications and
notification_preferences.
Contract: notify() is fire and forget from the caller's perspective, it never
throws into the business path, and it records a failed delivery row instead.
```

## Failure model, decided before implementation

| Dependency | Timeout | On failure |
|---|---|---|
| email provider | 10s | one retry after 30s, then a `failed` delivery row and a log at warn level |
| database insert | inherits pool timeout | propagates, since an in app alert that cannot be stored is a real error |

Fail open on email, fail closed on the database write. Written down because
six months later nobody remembers that this asymmetry was deliberate.

## What the trigger for the bigger design is

Recorded in the decision record so the next engineer does not have to relitigate
the question:

```
Move to a queue and a worker when any of these becomes true:
  - the daily peak exceeds 500 notifications per minute;
  - a channel needs a retry window longer than one request lifetime;
  - notification sending starts blocking user facing latency, measured;
  - a second service needs to send notifications.
Until then, the module stays in process.
```

## What was avoided

A broker to operate, three deployables, two extra failure modes between the
caller and the email, an empty push worker, and a template service that would
have wrapped four string interpolations.

The push channel, when it arrives, is one file in `channels/` and one row in
the preferences table. That is the test of the design: the future case is
cheap without having been built.
