# debugging

Root cause analysis, not hypothesis generation. Defines the defect precisely,
reproduces it, collects evidence before forming a theory, bisects the failing
path, instruments minimally, names the mechanism with a file and line range,
fixes it and proves the fix.

- Inputs: the defect report, the repository, logs or traces when available.
- Outputs: root cause report, reproduction, verified fix, regression test.
- Depends on: engineering-core, project-exploration.
- Downstream: testing-quality, code-review-protocol, project-continuity.

The regression test is written before the fix so that it fails first. A fix
with no test that failed beforehand is a fix with no evidence.
