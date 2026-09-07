# Documentation audit

Run when documentation is suspected of drifting, and as part of release
readiness.

## Accuracy

- [ ] Every documented endpoint exists in the code.
- [ ] Every endpoint in the code that is public is documented.
- [ ] Documented request and response shapes match the schemas.
- [ ] Documented error codes match what the handlers return.
- [ ] Documented environment variables match those the code reads.
- [ ] Every variable the code reads is documented.
- [ ] Documented commands exist in the manifest scripts or the task file.
- [ ] Documented file paths exist.

## Executability

- [ ] Every command in the setup guide was run on a clean state.
- [ ] Every code example compiles against the current code.
- [ ] Every API example was called and returned what is shown.
- [ ] The verification step at the end of setup actually verifies something.

## Staleness

- [ ] No documentation for removed behaviour.
- [ ] No reference to a renamed module, endpoint or variable.
- [ ] No screenshot showing an interface that no longer exists.
- [ ] No decision record describing a decision that was reversed without a
      superseding record.
- [ ] No link to a moved or deleted document.

## Safety

- [ ] No secret, key or token in any example.
- [ ] No real personal data in any example.
- [ ] No internal URL that discloses infrastructure unnecessarily.
- [ ] Example domains are reserved ones, not real addresses.

## Structure

- [ ] Each document serves one audience.
- [ ] The readme is short and points elsewhere for depth.
- [ ] The setup guide starts from an empty machine.
- [ ] The runbook is written in the imperative.
- [ ] The changelog contains user visible changes, not commit summaries.

## Constitution

- [ ] No emoji.
- [ ] No em dash.
- [ ] English throughout, unless the project states otherwise.

## Findings format

```
stale     docs/api.md:112  documents customerId on GET /api/invoices, removed
          in a91f0c2
Fixed     paragraph deleted, the scoping behaviour documented instead

missing   SESSION_SECRET is read in lib/session.ts:8 and absent from the setup
          guide
Fixed     added to the environment variable table with its generation command

wrong     README says pnpm test:watch, the script does not exist
Fixed     corrected to pnpm test --watch, verified by running it
```
