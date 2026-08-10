---
name: ci-cd-pipelines
description: Builds a pipeline that fails for the right reasons: stage ordering by cost, quality gates that block, caching, artefact handling, secret injection, deployment triggers and branch protection. Forbids weakening a check to obtain a green pipeline.
license: MIT
metadata:
  category: devops-skills
  version: 1.0.0
  depends_on: [engineering-core, devops-core, testing-quality]
  outputs: [pipeline-definition, quality-gates, artefact-strategy, pipeline-report]
---

# CI/CD Pipelines

A pipeline exists to say no. One that has never blocked a change is a build
script with a badge.

## 1. Stage ordering

Order by cost, cheapest first, so a trivial failure is reported in seconds
rather than after twenty minutes of tests.

```
1  install        dependencies, from the lockfile, cached
2  static         format check, lint, type check
3  unit           fast, isolated, no external service
4  build          the artefact
5  integration    real database, real migrations, no external network
6  security       dependency audit, secret scan
7  end to end     browser, against the built artefact
8  package        image or bundle, tagged with the commit
9  deploy         to the target the trigger implies
10 verify         the deployed system answers
```

Stages 2 and 3 catch most failures and cost under a minute. Running them after
the build wastes the majority of pipeline time on changes that were never
going to pass.

## 2. What blocks

Every stage either blocks or is removed. A stage that reports a failure and
lets the pipeline continue trains everyone to ignore it.

| Stage | Blocks | Notes |
|---|---|---|
| format | yes | trivially fixable, so no reason to allow drift |
| lint | yes | warnings that never block become permanent |
| type check | yes | |
| unit | yes | |
| build | yes | |
| integration | yes | |
| dependency audit | yes for reachable advisories | unreachable ones are recorded, not ignored |
| secret scan | yes | always |
| end to end | yes | a flaky suite is fixed, not made advisory |
| coverage threshold | no | a number that blocks produces tests written for the number |

The last row is deliberate. Coverage is reported and watched; it is not a
gate, because gating it rewards the wrong behaviour.

## 3. The rule about green

Never weaken a check to make a pipeline pass.

```
Forbidden
  disabling a test that fails
  adding a retry to hide a race
  lowering a threshold to accommodate a regression
  marking a stage advisory because it is inconvenient
  skipping the pipeline to merge
  committing directly to the protected branch

Correct
  fix the code, or fix the test, having decided which is wrong, and say which
```

A red pipeline is information. Converting it to green without changing the
underlying fact destroys the information and keeps the defect.

## 4. Speed

A pipeline nobody waits for gets bypassed.

```
Cache        the dependency directory, keyed on the lockfile hash
Cache        build outputs where the tool supports it
Parallelise  independent stages: static checks alongside unit tests
Shard        long suites across runners
Scope        run only what a change can affect, where the repository supports
             it reliably
Fail fast    stop the pipeline on the first blocking failure
```

Target: under ten minutes to the first meaningful signal. Where that is
impossible, the slow stage runs on the protected branch rather than on every
push, and that choice is stated.

## 5. Artefacts

Build once, deploy the same artefact everywhere. Rebuilding per environment
means the thing tested and the thing deployed are different objects.

```
Tag        the commit hash, not a floating name
Store      in the platform's registry or artefact store
Promote    the same artefact from staging to production
Retain     long enough to roll back to any recent release
```

## 6. Secrets in the pipeline

```
Injected   from the platform's secret storage, never from the definition file
Scoped     per environment, so a pull request pipeline cannot reach production
Masked     in logs, and never echoed
Forks      pipelines from forks do not receive secrets
```

The fork rule matters on public repositories: a pipeline that runs untrusted
code with production credentials is a supply chain hole.

## 7. Deployment triggers

Stated explicitly, never implied.

| Trigger | Target |
|---|---|
| push to a feature branch | build and test only |
| pull request | build, test, and a preview environment when the platform offers one |
| merge to the default branch | deploy to staging |
| tag, or a manual approval | deploy to production |

Automatic production deployment on every merge is a choice. It requires a
strong test suite, a health gated rollout and a fast rollback, and the absence
of any of the three makes it a liability.

## 8. Branch protection

The pipeline is only a gate if it cannot be bypassed.

```
Required     the pipeline passes before merge
Required     review, where the team has more than one person
Forbidden    direct push to the protected branch
Forbidden    force push to the protected branch
```

## 9. Pipeline failures

A failing pipeline is diagnosed like a defect: reproduce locally where
possible, read the full log rather than the last line, and distinguish a real
failure from an infrastructure one.

Recurrent infrastructure failures, such as registry timeouts, are recorded and
addressed. Retrying them silently until they pass hides a degrading
dependency.

## 10. Protocol

1. Read the platform's pipeline mechanism and the repository's existing one.
2. Order the stages by cost, section 1.
3. Make every stage block, or remove it, section 2.
4. Add caching and parallelism, section 4.
5. Build the artefact once, tag it by commit, section 5.
6. Inject secrets from the platform, scoped per environment, section 6.
7. Define the triggers, section 7.
8. Enable branch protection, section 8.
9. Verify the pipeline fails: break something deliberately and confirm the
   right stage catches it.
10. Record the pipeline duration and the first signal time.

## 11. Auto-critique

Score from 0 to 5: stages ordered by cost, every stage blocking, no check
weakened, caching effective, one artefact promoted rather than rebuilt,
secrets scoped and masked, triggers explicit, branch protection enabled,
failure behaviour verified deliberately.

Threshold: no axis below 3, average at least 4. A pipeline that has never been
proven to fail is an automatic failure, since nothing shows it is a gate.

## 12. Interfaces

- Upstream: `devops-core`, `containerization`, `testing-quality`.
- Lateral: `secrets-management`, `security-audit` for the audit stage.
- Downstream: `deployment-engineering`, `release-readiness` gate 2 and
  gate 6.
