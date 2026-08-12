# reliability-testing

Verifies how the product behaves when its dependencies fail: unavailable,
slow, timing out, partial, malformed, duplicated or out of order. Every
injected failure is judged against four properties: fails honestly,
communicates, stays consistent, recovers.

- Inputs: the dependency inventory, the critical operations, an environment
  the campaign is authorised to break.
- Outputs: dependency inventory, failure matrix results, recovery findings,
  consistency findings.
- Depends on: engineering-core, quality-engineering.
- Lateral: bug-hunting, observability, devops-core.
- Downstream: backend-engineering, testing-quality, test-reporting,
  production-verification.

One failure per run. The same operation is then rerun with the injection moved
to a different point, because failing before, during and after a write
produces three different defects. The data is checked, not only the absence of
an exception.
