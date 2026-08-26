# performance-engineering

Measures first, optimises the dominant cost, proves the delta. Covers frontend
waterfalls, bundles, images and rendering; backend query counts, payloads,
concurrency and blocking work; database plans, indexes and lock behaviour.

- Inputs: a slowness symptom or a measurement, the repository.
- Outputs: baseline, bottleneck analysis, applied optimisations, measured
  delta.
- Depends on: engineering-core, project-exploration.
- Downstream: code-review-protocol, release-readiness, project-continuity.

No baseline, no optimisation. No delta, no claim. Both numbers are measured
under identical conditions, reported with the median and the tail.
