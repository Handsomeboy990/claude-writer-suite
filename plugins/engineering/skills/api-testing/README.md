# api-testing

Verifies an HTTP surface against its contract: status codes, response and
error shapes, authentication and authorization per endpoint, parameter
validation, pagination, idempotency, concurrency and rate limits.

- Inputs: the specification if one exists, the handler code, the running API,
  the testing contract.
- Outputs: endpoint inventory, contract tests, contract deviations, error
  shape report.
- Depends on: engineering-core, testing-quality.
- Lateral: input-validation, security-testing, bug-hunting.
- Downstream: testing-quality, technical-documentation, test-reporting.

Where the specification and the code disagree, that disagreement is the first
finding. A `200` is where the test starts, not where it ends.
