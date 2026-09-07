---
name: infrastructure-as-code
description: Defines infrastructure in version controlled code rather than in a console: whether it is warranted at all, state management and locking, module boundaries and environment separation, the plan and apply discipline, drift detection, secrets kept out of state, destructive change protection, and importing what already exists. Tool agnostic: applies to declarative provisioning of any kind, including Terraform, Kubernetes manifests, Helm and cloud native templates. Use before creating cloud resources by hand a second time.
license: MIT
metadata:
  category: devops-skills
  version: 1.0.0
  depends_on: [devops-core, environment-management, secrets-management]
  outputs: [infrastructure-definitions, state-strategy, environment-layout, plan-review, drift-report]
---

# Infrastructure as Code

Infrastructure defined in code is reviewable, reproducible and reversible.
Infrastructure created in a console is a machine nobody can rebuild and a
change nobody can review.

The discipline is not the tool. It is that the code is the truth, and that
nothing is changed outside it.

## 1. Whether it is warranted

```
yes   more than one environment must match
yes   the infrastructure will be rebuilt, moved or duplicated
yes   several people change it
yes   an auditor will ask who changed what, and when
yes   recovery requires recreating resources
no    a single managed platform where the entire configuration is a handful
      of settings in a repository file the platform already reads
no    a prototype that will be deleted in a fortnight
```

For a small project on a managed platform, the platform's own configuration
file is infrastructure as code. Adding a provisioning tool on top is cost with
no return, and refusing it is an engineering decision worth recording.

## 2. State

The most dangerous object in this discipline.

```
stored remotely, never on a laptop, never in the repository
locking enabled, so two applies cannot run at once
versioned, so a corrupted state can be recovered
encrypted, because it contains resource attributes and sometimes secrets
one state per environment, never one for all
access to state is access to production: treat it as a credential
never edit state by hand except as a documented recovery, with a backup taken
  first
```

A lost or corrupted state file turns managed infrastructure back into
unmanaged infrastructure, with the resources still running.

## 3. Environment separation

```
the same definitions, different variables, never copied directories that
  drift within a month
separate state, separate credentials, separate blast radius
production credentials are not available to the pipeline that plans a
  development change
an environment's differences are explicit variables, not conditionals
  scattered through the code
naming carries the environment, so a resource is never ambiguous
```

## 4. Modules and boundaries

```
a module is a unit that is reused or independently changeable
group by lifecycle, not by resource type: things created and destroyed
  together belong together
the network, the data stores and the compute usually have different
  lifecycles and different blast radii
keep the destructive surface small: a change to a compute module must not be
  able to delete a database
version modules, and pin them, so an upstream change does not arrive during
  an unrelated apply
```

## 5. Plan and apply

```
every change produces a plan, and the plan is read before it is applied
the plan is reviewed by a second person for anything in production
the plan is attached to the change record
apply from the pipeline, not from a laptop, once the pipeline exists
apply is serialised: one at a time, enforced by locking
a plan that shows an unexpected replacement or deletion stops the change
```

Reading the plan is the entire safety mechanism. Applying without reading it
is the console with extra steps.

## 6. Destructive changes

```
identify replacements and deletions in the plan before approving
know which attribute changes force a replacement, per resource type
protect stateful resources with deletion prevention where the tool offers it
take a backup before any change touching a data store, and verify it exists
a rename in code is usually a delete and create: move the resource in state
  deliberately instead
a change to a network or a security boundary is reviewed by someone else,
  always
```

## 7. Secrets

```
never in the code, never in variable files committed to the repository
injected at apply time from the secret store
outputs that would expose a secret are marked sensitive, and the state is
  still treated as secret because sensitive marking is not encryption
generated credentials go into the secret store as part of the apply, not into
  a log or a console output
rotation is a documented procedure, not an apply nobody dares run
```

`secrets-management` owns the lifecycle; this skill owns keeping them out of
the definitions and out of the state visible to anyone.

## 8. Drift

```
detect it on a schedule, not only when something breaks
report drift as a finding: someone changed production outside the code
the fix is to bring the change into the code, or to revert it, decided each
  time and recorded
emergency console changes during an incident are legitimate, and they are
  reconciled within days, with the incident referenced
a resource that drifts repeatedly is either managed by another system or
  managed by a person who does not know it is in code
```

## 9. Importing what exists

Adopting existing infrastructure:

```
inventory what runs, before writing anything
import resource by resource, verifying an empty plan after each
an empty plan is the proof: the code now describes reality exactly
start with the stable, low risk resources, and leave the data stores last
never write definitions that would recreate an existing resource: that is how
  a production database is replaced by an apply
```

## 10. Prohibitions

- Never store state locally or in the repository.
- Never apply without reading the plan.
- Never share one state across environments.
- Never commit a secret to a variable file.
- Never apply a plan showing an unexplained replacement or deletion.
- Never change production in the console outside an incident.
- Never leave incident time console changes unreconciled.
- Never let one module hold both a stateless service and its database when
  the destructive surfaces differ.

## 11. Protocol

1. Decide whether a provisioning tool is warranted, and record the decision.
2. Set up remote state with locking, versioning and encryption, per
   environment.
3. Lay out modules by lifecycle and blast radius.
4. Express environment differences as variables.
5. Keep secrets out of definitions and inject them at apply time.
6. Run plans in the pipeline, review them, and attach them to the change.
7. Apply from the pipeline, serialised, with approval for production.
8. Protect stateful resources and verify backups before touching them.
9. Detect drift on a schedule and reconcile it deliberately.
10. When adopting existing infrastructure, import until the plan is empty.

## 12. Auto-critique

Score from 0 to 5: warrant decided rather than assumed, state remote, locked
and separated, module boundaries by lifecycle, environment differences as
variables, secrets absent from code and outputs, plans reviewed before apply,
destructive changes identified and protected, drift detection scheduled,
import verified by an empty plan.

Threshold: no axis below 3, average at least 4. A shared state across
environments, or an apply performed without reading the plan, fails
regardless of how tidy the code is.

## 13. Interfaces

- Upstream: `devops-core` for the environment ladder and blast radius,
  `architecture-design` for what the infrastructure must support,
  `technology-selection` for the platform.
- Lateral: `environment-management` for configuration, `secrets-management`
  for credentials, `containerization` for what runs, `ci-cd-pipelines` for
  where plans and applies execute.
- Downstream: `deployment-engineering`, `production-verification`,
  `backup-recovery`, `incident-response` when a change causes one,
  `decision-records` for the platform choice.
