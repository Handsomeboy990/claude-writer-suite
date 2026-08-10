# devops-core

Constitution of the operations family: the five rung environment ladder,
parity gap reporting, the code versus config versus secret split, the fail
fast startup rule, blast radius classification, the destructive action
protocol, idempotence and the observability precondition.

- Inputs: the project, its architecture section 9, its environments.
- Outputs: environment model, operational rules, blast radius assessment.
- Depends on: engineering-core.
- Downstream: every skill in devops-skills.

Loaded first in the family and never restated by the others. A silent
production default for a secret, and a destructive command run against an
unverified target, are the two failures these rules exist to prevent.
