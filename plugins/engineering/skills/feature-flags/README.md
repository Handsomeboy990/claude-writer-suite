# feature-flags

Manages flags as code with a lifecycle: types and their different lifespans,
fail safe evaluation, targeting and gradual rollout with a written abort
threshold, kill switches, testing both sides, stale flag detection, and the
removal that closes the loop.

- Inputs: the decision the flag defers, the rollout metric, the environments,
  the flag provider if one exists.
- Outputs: flag register, evaluation rules, rollout plan, removal plan.
- Depends on: engineering-core, testing-quality.
- Lateral: backend-engineering, frontend-engineering,
  analytics-instrumentation, technical-debt.
- Downstream: testing-quality, regression-testing, release-engineering,
  incident-response.

An entitlement by plan or role is authorization, not a flag. A release flag
with no removal date is a permanent conditional acquired for a temporary
reason, and the discipline is the removal rather than the toggle.
