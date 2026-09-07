# Plan review

The plan is the change. Reviewing it is not a formality, and it is the last
moment at which a deletion is cheap.

## Read in this order

```
1  deletions            what disappears, and whether anything depends on it
2  replacements         what is destroyed and recreated, and what that costs:
                        an address, a certificate, data, downtime
3  creations            what appears, and whether it is what was intended
4  in place changes     usually safe, occasionally not
5  the count            does the total match what the change should produce
```

A plan with more resources affected than the change describes is a signal,
not a detail. It usually means a variable changed, a module version moved, or
someone changed production in the console.

## Questions before approving

```
does anything stateful appear under deletion or replacement
does any identity, permission or network rule change
does anything public gain or lose exposure
does a certificate, address or endpoint change, and who depends on it
is there downtime implied, and is it announced
is the change reversible, and by what
was the backup taken and verified, if a data store is touched
does the plan match the diff, or does it show changes nobody wrote
```

## Attribute changes that force replacement

Per resource type, know these before planning rather than after applying:

```
identifiers and names, on many resource types
availability zone or region
network placement of a stateful resource
engine version, on some database services, in one direction only
encryption settings, once set
the primary key or partitioning of a managed table
```

Learn them for the resources in the project, and write them into the project's
own runbook. This is the single most useful local document in this discipline.

## Approval rules

```
development     a plan is read by its author, applied from the pipeline
staging         a plan is read by its author, applied from the pipeline
production      a plan is read by a second person, and applied from the
                pipeline with an explicit approval
any deletion    a second person, whatever the environment, if the resource
  or replacement holds data or serves traffic
```

## The empty plan

```
after an apply, plan again: it must be empty
after an import, plan: it must be empty
on a schedule against production: it must be empty

a non empty plan on a schedule is drift, and drift is a finding with a name
attached to it: something changed outside the code
```

## Drift record

```
DRIFT-03  security group 443 rule added outside code
Detected  scheduled plan, 2026-08-11 04:00
Change    ingress rule allowing 0.0.0.0/0 on 443 added to the api group
Origin    incident INC-2026-08-09, added at 02:14 during the outage
Decision  legitimate during the incident, and correct permanently. Brought
          into the code with a comment referencing the incident.
Reconciled 2026-08-11, plan empty afterwards
```

Two outcomes are acceptable for any drift: adopt it into the code, or revert
it. Leaving it undecided is how the code stops describing reality, and once
that is true nobody trusts the plan again.
