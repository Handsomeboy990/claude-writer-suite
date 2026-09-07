# Example: replacing a mail provider without losing a message

Reason: the current provider is being discontinued in four months. Not
optional, and the date is fixed by someone else.

## Inventory

```
call sites        1 sender module, 3 direct calls that bypass it, found by
                  searching for the provider package rather than for the module
templates         31, of which 22 are actively sent, verified from 90 days of
                  logs. The other 9 are candidates for deletion.
integrations      the provider's webhooks feed a delivery status table used by
                  the support interface
data              200k historical delivery records referencing provider ids
tests             the sender module has 4 tests, all mocking the provider
                  library. The three direct calls have none.
```

Two findings before any code was written: three call sites bypass the
abstraction, and the existing tests mock the library, which means they prove
nothing about the request actually sent.

## Compatibility

```
identical    recipient, subject, HTML body, attachments
renamed      template variables use a different delimiter
silent       the old provider silently truncated subjects at 78 characters.
             The new one does not. Twelve templates rely on the truncation
             without knowing it.
silent       bounce webhooks arrive with a different retry policy: up to 5
             deliveries of the same event rather than 1
removed      no equivalent for the old scheduled send. Replaced by our own
             queue with a delay.
```

The subject truncation is the kind of thing no changelog mentions and only
testing finds.

## Strategy

Parallel change, with a per-template switch rather than a global one.

```
rejected  big bang: 22 live templates, no way to verify them all at once
rejected  global flag: one bad template would force a full rollback
chosen    a provider interface, both implementations, and a per template
          routing rule, so migration proceeds template by template with the
          blast radius of a single mail type
```

## Steps, each shipped

```
1  fix the three direct call sites to go through the sender module.
   No provider change. Shipped alone, so the migration diff stays honest.
2  replace the library mocks with network level stubs, so the tests assert
   the request actually built. Two defects found immediately: a missing
   reply-to header and an attachment name that was never encoded.
3  introduce the provider interface, old implementation behind it. No
   behaviour change, no flag yet.
4  implement the new provider behind the same interface, unused, with its own
   tests against recorded responses.
5  route one low volume template: the internal weekly digest. Observe for
   three days. Two findings: the delimiter change broke one variable, and the
   subject arrived untruncated and looked wrong in a narrow mail client.
6  fix the truncation explicitly in the templates that needed it, rather than
   depending on a provider quirk. Twelve templates edited, each verified.
7  route templates in four batches, ordered by volume ascending, with three
   days of observation between batches.
8  webhook consumer made idempotent before the new provider's retries could
   create duplicate delivery rows. Done before batch 2, after the risk was
   noticed in the compatibility analysis.
9  cut over the last batch: password reset and invitation, the two mails whose
   failure is an incident. Done on a Tuesday morning, not a Friday evening.
```

## Data

The historical delivery records were not migrated. Decision recorded: they
reference provider identifiers that mean nothing in the new system, they are
only used by support for recent messages, and the retention policy is 90 days.

```
old table kept read only for 90 days, then dropped
support interface reads both tables during the window, new first
one line in the support documentation explains the split
```

Migrating them would have cost a week and produced records nobody would query
after three months. Not migrating is a decision, and it is written down rather
than left as an omission.

## Rollback

Rehearsed on staging before batch 1, and again before the final batch.

```
procedure     flip the routing rule for the affected templates, redeploy
              configuration, no code change
duration      under two minutes, measured
cannot        restore mails already sent through the new provider, or the
  restore     delivery events already recorded for them
point of no   the old provider account closing on the contract date. After
  return      that, rollback is replaced by forward fix, and the plan says so
```

## Cleanup, done

```
old implementation deleted             2026-07-02
provider interface kept                it now has a second implementer for
                                       transactional versus marketing mail,
                                       so it earns its existence
routing rules removed                  2026-07-02
old dependency removed from manifest   2026-07-02
9 unused templates deleted             2026-07-09
old delivery table dropped             2026-09-30, after the retention window
documentation and diagram updated      2026-07-03
```

Total: five weeks, no incident, one deliberate non-migration, and a subject
truncation defect that would have reached customers on day one of a big bang.
