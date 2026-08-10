---
name: release-engineering
description: Owns how a release happens: versioning scheme, tagging, changelog generation from real changes, artefact promotion, rollout strategy, feature flags, hotfix path and post release records. Distinct from release-readiness, which decides whether to ship at all.
license: MIT
metadata:
  category: devops-skills
  version: 1.0.0
  depends_on: [engineering-core, devops-core, git-workflow, deployment-engineering]
  outputs: [version-decision, release-tag, changelog-entry, rollout-plan, hotfix-procedure]
---

# Release Engineering

`release-readiness` decides whether this revision may ship. This skill decides
how the shipping happens: what it is called, how it reaches users, and what
happens when it must be undone or corrected in a hurry.

## 1. Versioning

Choose one scheme, state it, and hold it.

| Scheme | Fits |
|---|---|
| semantic versioning | anything other people depend on: libraries, public APIs |
| date based | applications where users do not pin versions |
| sequential build number | internal tools, continuous delivery |
| commit hash only | continuous deployment with no user facing version |

For semantic versioning, the discipline is in the major bump. A breaking
change shipped as a minor version is a promise broken, and the promise is the
only reason the scheme has value.

```
Breaking   a consumer must change something
Feature    a consumer gains something and changes nothing
Patch      a consumer gains a correction and changes nothing
```

`Consumer` includes the project's own frontend when the API is versioned
against it.

## 2. Tagging

```
Annotated  tags, not lightweight, so the tag carries who and when
Immutable  a tag is never moved once pushed
Matched    the tag names exactly the commit that was built and deployed
Signed     where the project's distribution requires it
```

The artefact carries the version, and the version endpoint reports it. A
release whose deployed commit cannot be identified from the running system is
not traceable, which matters at exactly the moment it matters most.

## 3. Changelog

Written from what changed, for the people affected. Not a commit log.

```
Breaking   first, always, each with the migration step
Added      user visible capabilities
Changed    behaviour that differs
Fixed      defects that were reported or that users could hit
Security   fixes, with enough detail to judge urgency and no exploit recipe
Internal   omitted, unless a consumer is affected
```

Rules:

- One entry per user visible change, in the reader's terms.
- A refactor with no external effect does not appear.
- A security fix says what class of issue and who should upgrade quickly. It
  does not include a working exploit.
- Entries are written when the change is made, not reconstructed at release
  time from commit subjects.

## 4. Rollout

| Strategy | When | Requires |
|---|---|---|
| all at once | small user base, fast rollback, low blast radius | a rollback that works |
| rolling | multiple instances, the common default | health gating, backward compatible schema |
| canary | large user base, or a risky change | traffic splitting and per cohort metrics |
| blue green | a clean instant switch and an instant revert | double capacity during the switch |
| flagged | the code ships dark, the behaviour is enabled separately | a flag system and a plan to remove the flag |

The choice is stated in the release plan with the reason. Defaulting to
whatever the platform does, without knowing what it does, is how a release
with an incompatible migration goes out as a rolling deployment.

## 5. Feature flags

Useful, and they accumulate. Every flag is created with its removal
condition.

```
Name         what it controls, not who asked for it
Default      the safe value
Scope        global, per cohort, per account
Owner        who decides
Removal      the condition under which the flag and the old path are deleted
Expiry       a date after which it is reviewed
```

A flag with no removal condition becomes permanent configuration, and the
untaken branch rots until nobody dares delete it.

## 6. Hotfix path

Defined before it is needed, because it is used under pressure.

```
1  Confirm the severity justifies bypassing the normal path
2  Branch from the released tag, not from the development branch
3  Make the smallest change that fixes the problem
4  The full pipeline runs; the hotfix path shortens review, never testing
5  Tag as a patch release
6  Deploy, verify with production-verification
7  Merge the fix back into the development branch, immediately
8  Record the incident and the fix
```

Step 7 is the one forgotten, and the result is the same defect returning in
the next ordinary release.

Step 4 is the one under pressure to skip. A hotfix that has not been tested is
a second incident with a shorter fuse.

## 7. Release record

```
Version      the tag
Commit       the hash
Date         and who released it
Contents     the changelog entry
Migrations   which ran, and whether any were destructive
Rollout      strategy, and how long it took
Verification the production verification verdict
Rollback     available until when, and what it would not restore
Issues       anything observed in the watch window
```

Kept with the release, so a question about what shipped in a given version is
answered by a record rather than by archaeology.

## 8. Post release

```
Watch        the window from the deployment plan
Compare      error rate and latency against the pre release baseline
Record       anything unusual, even when it resolves
Close        the release when the window passes cleanly
Follow up    anything the release deferred, into the register
```

## 9. Protocol

1. Determine the version per the scheme, section 1.
2. Assemble the changelog from the changes, section 3.
3. Choose the rollout strategy and state why, section 4.
4. Confirm `release-readiness` returned a go.
5. Tag, annotated, on the exact commit.
6. Deploy per `deployment-engineering`.
7. Verify per `production-verification`.
8. Record, section 7.
9. Watch and close, section 8.

## 10. Auto-critique

Score from 0 to 5: version correct under the scheme, breaking changes not
disguised as minor, tag immutable and matching the artefact, changelog written
for users, rollout strategy chosen deliberately, flags carrying removal
conditions, hotfix path preserving testing, release record complete.

Threshold: no axis below 3, average at least 4. A breaking change released
without a major version, or a hotfix that skipped the test stages, is an
automatic failure.

## 11. Interfaces

- Upstream: `release-readiness` for the go decision, `git-workflow` for
  tagging, `technical-documentation` for the changelog.
- Lateral: `deployment-engineering`, `production-verification`.
- Downstream: `client-handover`, `project-continuity`.
