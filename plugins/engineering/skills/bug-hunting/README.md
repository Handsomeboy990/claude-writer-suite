# bug-hunting

Systematic adversarial testing of a feature that already works. Nine families
of abuse, run in a fixed order, each hit reduced to a minimal reproduction
with a stated frequency.

- Inputs: a feature whose happy path passes, the testing contract, a clean
  starting state.
- Outputs: matrix results, minimal reproductions, ranked defect list,
  regression candidates.
- Depends on: engineering-core, quality-engineering.
- Lateral: security-testing, reliability-testing, input-validation.
- Downstream: debugging, testing-quality, test-reporting.

Repetition and concurrency run first because they are cheap and expose the
defects that cost the most: duplicate charges, duplicate mail, lost updates.
Destructive scenarios run only when the contract authorises them in writing.
