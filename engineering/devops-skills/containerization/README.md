# containerization

Decides whether a container is warranted, then builds one correctly: multi
stage, cache friendly layer order, pinned base, minimal runtime surface, non
root execution, signal handling, a health check that can fail, and runtime
configuration injection.

- Inputs: the project, the platform, the local dependency needs.
- Outputs: container images, compose files, build report, image audit.
- Depends on: engineering-core, devops-core, environment-management.
- Lateral: ci-cd-pipelines, security-audit.
- Downstream: deployment-engineering, production-verification.

The first question is whether the project needs one at all. A container added
onto a platform that builds from source buys nothing and adds a build, a
registry and a class of bug where image and source disagree.
