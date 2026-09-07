# infrastructure-as-code

Defines infrastructure in version controlled code: whether a provisioning tool
is warranted at all, remote state with locking, environment separation, module
boundaries by lifecycle and blast radius, the plan and apply discipline,
destructive change protection, secrets kept out of state, drift detection and
importing what already exists.

- Inputs: what the infrastructure must support, the platform, the
  environments, the existing resources.
- Outputs: infrastructure definitions, state strategy, environment layout,
  plan review, drift report.
- Depends on: devops-core, environment-management, secrets-management.
- Lateral: containerization, ci-cd-pipelines, architecture-design.
- Downstream: deployment-engineering, production-verification,
  backup-recovery, incident-response.

Tool agnostic. Reading the plan is the safety mechanism, and applying without
reading it is the console with extra steps. For a small project on a managed
platform, refusing a provisioning tool is a legitimate decision worth
recording.
