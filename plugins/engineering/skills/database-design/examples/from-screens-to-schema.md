# Example: from three screens to a schema that survives

Feature: teams subscribe to a plan, invite members, and are billed monthly.

## The schema that comes from looking at the screens

```
teams(id, name, plan, price, seats, owner_email, created_at)
members(id, team_id, email, role, invited, joined)
```

It renders the screens. It also encodes six future incidents.

## The access patterns, collected first

```
reads
  the team page: team plus its members, per visit, up to 200 members
  the billing page: current plan, seats used, next invoice, per visit
  the admin list: all teams, filtered by plan, sorted by created date
  monthly job: every active subscription, with its price at that time
writes
  invite a member: often, and twice in a row when someone double clicks
  accept an invitation: once per member
  change plan: rare, but must not lose the price history
  remove a member: frequent enough to matter for seat counting
reports
  monthly revenue by plan, over any range
lifecycle
  a team can be closed, its data kept for 90 days, then deleted
```

Three problems appear immediately, none visible from the screens: price
history, seat counting under concurrency, and retention.

## The schema

```
teams
  id                 identifier, opaque
  name               text not null
  status             enum(active, suspended, closed) not null default active
  closed_at          timestamptz null
  created_at         timestamptz not null default now()

plans
  code               text primary key            -- starter, team, business
  name               text not null
  monthly_amount     integer not null            -- minor units
  currency           char(3) not null
  seat_limit         integer null                -- null means unlimited
  active             boolean not null default true

subscriptions
  id                 identifier
  team_id            references teams restrict, not null
  plan_code          references plans restrict, not null
  amount             integer not null            -- price at subscription time
  currency           char(3) not null
  started_at         timestamptz not null
  ended_at           timestamptz null
  unique (team_id) where ended_at is null        -- one active subscription

users
  id                 identifier
  email              citext not null unique
  created_at         timestamptz not null

memberships
  id                 identifier
  team_id            references teams cascade, not null
  user_id            references users restrict, not null
  role               enum(owner, admin, member, viewer) not null
  joined_at          timestamptz not null
  unique (team_id, user_id)

invitations
  id                 identifier
  team_id            references teams cascade, not null
  email              citext not null
  role               enum(admin, member, viewer) not null
  token_hash         text not null unique
  expires_at         timestamptz not null
  accepted_at        timestamptz null
  revoked_at         timestamptz null
  unique (team_id, email) where accepted_at is null and revoked_at is null
```

## Every decision, and the incident it prevents

```
plans as a table          changing a price does not rewrite history
amount copied into        the monthly job bills what the customer agreed to,
  subscriptions           not what the plan costs today
partial unique on         a team cannot end up with two active subscriptions
  subscriptions           after a double click on Upgrade
users separate from       one person in three teams is one person, and the
  memberships             email lives in one place
citext on email           Ada@example.com and ada@example.com are one account
partial unique on         inviting the same address twice does nothing, and
  invitations             revoked or accepted invitations do not block a new one
token_hash, not token     a leaked backup does not grant access
restrict on user_id       deleting a user with memberships fails loudly rather
                          than silently removing them from teams
cascade on team_id        closing a team removes its memberships deliberately
status plus closed_at     retention is computable: closed_at plus 90 days
enum for role and status  no row ever holds "Admin " with a trailing space
```

## Seats, the interesting one

Seat limit is not a column on `teams`. It is `plans.seat_limit`, and the check
happens in the transaction that creates the membership:

```sql
insert into memberships (team_id, user_id, role, joined_at)
select $1, $2, $3, now()
where (
  select count(*) from memberships where team_id = $1
) < (
  select coalesce(p.seat_limit, 2147483647)
  from subscriptions s join plans p on p.code = s.plan_code
  where s.team_id = $1 and s.ended_at is null
);
```

Zero rows inserted means the limit was reached. Reading the count first and
then inserting would let two simultaneous acceptances both pass the check,
which is exactly how products end up with 11 members on a 10 seat plan.

## Indexes, from the patterns above

```
memberships (team_id)                     the team page
memberships (user_id)                     which teams a user belongs to
subscriptions (team_id) where ended_at is null   the billing page
subscriptions (started_at)                the revenue report range scan
invitations (team_id) where accepted_at is null and revoked_at is null
teams (status, created_at desc)           the admin list
```

Six indexes, six named patterns. The unique constraints already serve as
lookups, so no duplicate index was created for them.

## The cost of the likely changes, stated now

```
adding a plan                cheap, one row
adding a role                cheap if the enum is extended, one migration
per-team custom pricing      cheap, subscriptions already carries an amount
teams inside organisations   moderate, a nullable organisation_id then a
                             backfill, no rewrite
moving to per-seat billing   cheap, the seat count is derivable from
                             memberships at any point only if we keep
                             membership history, which we do not. Recorded as
                             a known limitation, with the option to add a
                             membership_events table when it is needed.
```

The last line is the honest part. The design does not support historical seat
counts, that is a deliberate choice, and it is written down instead of being
discovered by a billing engineer in eighteen months.
