# production-verification

Proves a deployed system works by exercising it. Thirteen checks in order:
availability, version, health, authentication, authorization, critical
journeys, data, external services, assets, configuration, security headers,
logs and performance, followed by a watch window with a threshold set in
advance.

- Inputs: the completed deployment, the environment, the critical journeys.
- Outputs: verification report, smoke results, rollback decision.
- Depends on: engineering-core, devops-core, deployment-engineering,
  observability.
- Downstream: release-engineering, release-readiness, project-continuity.

The version check is the cheapest and catches the deployment that appeared to
succeed while leaving the previous version serving. Test data uses reserved
domains, is marked, and is removed.
