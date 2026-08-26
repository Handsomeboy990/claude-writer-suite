# Example: adopting infrastructure that was built by hand

Two years of production, everything created in a console by two people, one of
whom has left. Nobody can rebuild it and nobody is sure what exists.

## Inventory before writing any definition

```
compute          4 instances, 2 of them undocumented
networking       1 network, 3 subnets, 6 security groups, of which 2 allow
                 traffic nobody could explain
databases        1 primary, 1 replica, 1 instance from a migration in 2024
                 that is still running and receives no connections
storage          9 buckets, 3 of them empty, 1 publicly readable
DNS              22 records, 4 pointing at addresses that no longer respond
certificates     3, one expiring in 5 weeks and not renewed automatically
identities       17 access keys, 6 unused for over a year
```

The inventory alone produced four findings before a single line of code: a
public bucket, an expiring certificate, six stale credentials and a database
nobody uses but everybody pays for.

## Order of adoption

Stable and harmless first, stateful last.

```
1  DNS records          low risk, easy to verify, immediate value
2  certificates         and automatic renewal, which fixed the 5 week problem
3  networking           read only import, no changes, because a mistake here
                        removes access to everything
4  storage              including making the public bucket private, which was
                        a separate reviewed change, not part of the import
5  identities           after auditing which are used
6  compute              one instance at a time
7  databases            last, with deletion protection enabled first
```

## The import loop, per resource

```
1  write the definition to match what exists, attribute by attribute
2  import the resource into state
3  plan
4  if the plan is not empty, the definition is wrong, not the resource.
   Correct the definition and plan again.
5  repeat until the plan is empty
6  commit
```

Rule 4 is the whole discipline. The temptation, when the plan proposes to
change something, is to let it. On the network import that would have replaced
a subnet, and taken every instance in it with the change.

## What the empty plan protected

```
a database import where the definition omitted a parameter group. The plan
  proposed a modification with a restart. Corrected the definition instead:
  plan empty, no restart, production untouched.

a security group import where the definition normalised the rule order. The
  plan proposed a delete and recreate of all six rules, which is a brief
  window with no rules at all. Corrected the definition to match the existing
  order: plan empty.

a bucket import where the definition set a lifecycle rule the bucket did not
  have. That was a real improvement, and it was applied as its own reviewed
  change afterwards, not smuggled into an import.
```

## State setup, done first

```
remote backend with locking and versioning
one state per environment: production, staging
encryption enabled
access limited to the pipeline role and two people
a manual backup of the state file after each import batch, kept for a month
```

## Result after three weeks

```
plan against production   empty
environments              production and staging from the same definitions,
                          differing by 11 explicit variables
rebuild                   exercised in a scratch environment: 34 minutes from
                          nothing to a running stack
findings fixed            public bucket, expiring certificate, 6 stale keys
                          revoked, 1 unused database removed after verifying
                          no connections for 90 days
drift detection           scheduled nightly, alert on a non empty plan
console access            reduced to read only for everyone except the two
                          break glass accounts, which are logged
```

The migration changed nothing about how the application runs. It changed who
can answer the question `what is running, and why`, which was previously
nobody.
