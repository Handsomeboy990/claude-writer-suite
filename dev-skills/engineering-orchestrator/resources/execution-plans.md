# Canonical execution plans

One plan per task category. Machine checkable format: a `category:` line
followed by a single `plan:` line whose steps are separated by `->`. Every
step is the exact directory name of a skill in `dev-skills/`.

These are starting points, not scripts. The orchestrator adapts them under the
rules of `SKILL.md` sections 3, 4 and 5, and states every adaptation.

`engineering-core` is implicit in every plan and never listed.
`engineering-orchestrator` is the caller and never lists itself.

## EXPLORATION

category: EXPLORATION
plan: project-exploration -> technical-documentation -> project-continuity

Answer a question about the codebase. No code changes, so no test or review
gate. Documentation only when the answer is worth keeping.

## ARCHITECTURE

category: ARCHITECTURE
plan: project-exploration -> architecture-design -> dependency-selection -> technical-documentation -> project-continuity

Design work with no implementation yet. `dependency-selection` runs only when
the design implies a new library.

## FRONTEND

category: FRONTEND
plan: project-exploration -> ui-ux-engineering -> frontend-engineering -> input-validation -> testing-quality -> playwright-automation -> performance-engineering -> code-review-protocol -> technical-documentation -> project-continuity -> git-workflow

`input-validation` covers client side form constraints and any server action
the page introduces. `playwright-automation` is dropped when the repository
has no browser tooling and the change does not justify adding it.

## BACKEND

category: BACKEND
plan: project-exploration -> architecture-design -> backend-engineering -> input-validation -> security-audit -> testing-quality -> performance-engineering -> code-review-protocol -> technical-documentation -> project-continuity -> git-workflow

`architecture-design` is dropped for a change confined to one existing module.
`security-audit` is never dropped when the endpoint returns user scoped data.

## FULLSTACK

category: FULLSTACK
plan: project-exploration -> architecture-design -> fullstack-engineering -> backend-engineering -> frontend-engineering -> input-validation -> security-audit -> testing-quality -> playwright-automation -> ui-ux-engineering -> performance-engineering -> code-review-protocol -> technical-documentation -> project-continuity -> git-workflow -> release-readiness

The widest plan. `release-readiness` runs only when the request is to ship.

## DATABASE

category: DATABASE
plan: project-exploration -> architecture-design -> backend-engineering -> testing-quality -> performance-engineering -> code-review-protocol -> technical-documentation -> project-continuity -> git-workflow

Migrations are treated as production changes: reversibility, ordering and
index impact are decided before writing the migration file.

## API

category: API
plan: project-exploration -> architecture-design -> backend-engineering -> input-validation -> security-audit -> testing-quality -> code-review-protocol -> technical-documentation -> project-continuity -> git-workflow

Contract changes require the documentation step, never optional here.

## AUTHENTICATION

category: AUTHENTICATION
plan: project-exploration -> architecture-design -> security-audit -> backend-engineering -> input-validation -> testing-quality -> code-review-protocol -> technical-documentation -> project-continuity -> git-workflow

`security-audit` runs before implementation as well as after, because the
threat model constrains the design.

## SECURITY

category: SECURITY
plan: project-exploration -> security-audit -> debugging -> backend-engineering -> input-validation -> testing-quality -> code-review-protocol -> technical-documentation -> project-continuity -> git-workflow

`debugging` establishes exploitability before anything is changed. The fix
skill is chosen by surface: `backend-engineering`, `frontend-engineering` or
`fullstack-engineering`.

## VALIDATION

category: VALIDATION
plan: project-exploration -> input-validation -> backend-engineering -> testing-quality -> security-audit -> code-review-protocol -> technical-documentation -> project-continuity -> git-workflow

## DEBUGGING

category: DEBUGGING
plan: project-exploration -> debugging -> backend-engineering -> testing-quality -> code-review-protocol -> technical-documentation -> project-continuity -> git-workflow

Exploration is dropped only when every file involved was already read in this
session. The fix skill follows the surface of the defect.

## PERFORMANCE

category: PERFORMANCE
plan: project-exploration -> performance-engineering -> debugging -> backend-engineering -> testing-quality -> code-review-protocol -> technical-documentation -> project-continuity -> git-workflow

No optimisation without a measurement. `performance-engineering` runs first to
produce the baseline, and again at the end to prove the delta.

## UI_UX

category: UI_UX
plan: project-exploration -> ui-ux-engineering -> frontend-engineering -> testing-quality -> playwright-automation -> performance-engineering -> code-review-protocol -> technical-documentation -> project-continuity -> git-workflow

Accessibility and responsive verification live inside `ui-ux-engineering` and
`playwright-automation`; they are not separate steps.

## TESTING

category: TESTING
plan: project-exploration -> testing-quality -> playwright-automation -> code-review-protocol -> technical-documentation -> project-continuity -> git-workflow

## BROWSER_AUTOMATION

category: BROWSER_AUTOMATION
plan: project-exploration -> playwright-automation -> testing-quality -> code-review-protocol -> technical-documentation -> project-continuity -> git-workflow

## DOCUMENTATION

category: DOCUMENTATION
plan: project-exploration -> technical-documentation -> code-review-protocol -> project-continuity -> git-workflow

Documentation is reviewed against the implementation it describes, which is
why the review step stays.

## GIT

category: GIT
plan: project-exploration -> git-workflow -> project-continuity

## RELEASE

category: RELEASE
plan: project-exploration -> testing-quality -> security-audit -> performance-engineering -> code-review-protocol -> technical-documentation -> project-continuity -> release-readiness -> git-workflow

## REFACTORING

category: REFACTORING
plan: project-exploration -> architecture-design -> testing-quality -> code-review-protocol -> performance-engineering -> technical-documentation -> project-continuity -> git-workflow

Tests come before the refactor, as the behaviour contract that must not move.
A refactor with no covering test is a rewrite in disguise.

## DEPENDENCY

category: DEPENDENCY
plan: project-exploration -> dependency-selection -> security-audit -> testing-quality -> performance-engineering -> code-review-protocol -> technical-documentation -> project-continuity -> git-workflow
