# file-handling

Handles uploads, storage, processing and delivery safely: authorization
first, size enforced while streaming, type detected from content, generated
storage names, storage outside the served tree, authorised or signed delivery,
processing limits, scanning where required, orphan cleanup and retention.

- Inputs: the feature accepting files, the storage available, the sharing
  model, the retention requirements.
- Outputs: upload contract, storage layout, access policy, processing limits,
  retention rules.
- Depends on: engineering-core, input-validation.
- Lateral: backend-engineering, background-jobs, data-privacy, security-audit.
- Downstream: security-testing, testing-quality, reliability-testing.

A file lies about its size, its name, its type and its content. Type is
detected from the bytes, the stored name is generated, and user uploads are
never served from the application origin when they can execute.
