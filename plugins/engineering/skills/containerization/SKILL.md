---
name: containerization
description: Decides whether a container is warranted and builds it correctly: multi stage images, layer caching, non root execution, signal handling, health checks, minimal surface, and compose files for local dependencies. Refuses containerisation that adds operational burden without benefit.
license: MIT
metadata:
  category: devops-skills
  version: 1.0.0
  depends_on: [engineering-core, devops-core, environment-management]
  outputs: [container-images, compose-files, build-report, image-audit]
---

# Containerization

Containers solve reproducibility and isolation. They do not solve
architecture, and they add a build, a registry, a runtime and a set of failure
modes.

The first question is whether this project needs one.

## 1. The decision

| Warranted when | Not warranted when |
|---|---|
| the platform deploys containers | the platform builds from source and runs it |
| the runtime is hard to reproduce | the runtime is one mainstream version |
| several services must run together locally | one process and one managed database |
| the team's machines differ enough to cause failures | they do not |
| the client's operations team runs containers | they run a process supervisor |
| CI needs a reproducible environment | the CI runner already provides it |

A container introduced because it is standard practice, onto a platform that
would have built from source, adds a Dockerfile to maintain, an image to
build, a registry to manage, and a class of bug where the image and the source
disagree.

Local dependencies are the common legitimate case even when deployment is not
containerised: a compose file that runs the database and nothing else is often
the whole justified use.

## 2. Image construction

### Multi stage

```
Stage 1  install build dependencies, build the artefact
Stage 2  a minimal runtime, copy only the artefact and its runtime deps
```

The build stage carries compilers, development dependencies and source. None
of it belongs in the running image, where every byte is attack surface and
transfer time.

### Layer order

Order instructions from least to most frequently changing, so the cache
survives ordinary edits.

```
1  base image
2  system packages
3  dependency manifests only
4  dependency installation
5  application source
6  build
```

Copying the whole source before installing dependencies invalidates the
dependency layer on every source change, which turns a five second rebuild
into a two minute one.

### Pinning

Pin the base image to a specific version, not a floating tag. A `latest` base
means the image built today and the image built next month are different
artefacts with the same name, and the difference is discovered in production.

### Minimal surface

Install what runs, not what was convenient during debugging. No shell tools,
no editors, no package manager caches, no build toolchain in the final stage.

## 3. Runtime correctness

### Non root

Create a user, own the files it needs, switch to it before the entry point.
A container running as root that is compromised is a machine level problem
rather than a process level one.

Where the platform imposes a user, follow the platform.

### Signal handling

The process must receive and act on the termination signal, so it can finish
in flight requests and close connections.

Two common defects: a shell form entry point that makes the shell the main
process and swallows signals, and an application that ignores the signal and
is killed after the grace period, dropping requests.

### Health check

A container that is running is not a container that is working. The health
check answers whether the process can serve, and it is what the platform uses
to decide whether to route traffic and whether a deploy succeeded.

The check is cheap, has a timeout, and does not depend on an external service
whose outage would then take the application down.

### Configuration

Injected at runtime, never baked. A secret in a build argument is in the image
history and is readable by anyone who can pull the image.

## 4. Compose for local dependencies

Runs what a developer cannot easily install: the database, a cache, a message
broker, a storage emulator.

```
Include   the dependencies
Consider  the application itself, when the team's environments differ enough
Never     production configuration, real credentials, or a production profile
Always    named volumes for data, a health check on the database, and a
          documented reset command
```

The reset command matters. A developer whose local database is in a bad state
should have one documented way back rather than a folklore of commands.

## 5. Image audit

Before an image is used in an environment above local:

```
Size            stated; a runtime image an order of magnitude larger than the
                artefact means the build stage leaked
User            not root, verified by running the image
Signals         termination handled, verified by stopping it
Health          the check passes, and fails when the app is broken
Secrets         none in any layer, verified by inspecting the history
Base            pinned, and its known advisories reviewed
Packages        only what runs
Reproducible    two builds of the same commit produce the same behaviour
```

## 6. Prohibitions

- Never a secret in a build argument, an environment instruction, or a layer.
- Never a floating base tag in a deployed image.
- Never the source tree copied into the runtime stage.
- Never root in the final stage without a platform reason.
- Never a health check that calls an external service.
- Never a compose file holding a real credential.
- Never containerise to appear rigorous when the platform does not use it.

## 7. Protocol

1. Answer section 1 honestly. Record the answer either way.
2. If warranted, build multi stage with the layer order of section 2.
3. Pin the base, minimise the final stage.
4. Apply the runtime rules of section 3.
5. Write the compose file for local dependencies, section 4.
6. Run the audit, section 5.
7. Document the build and run commands, and the reset command.

## 8. Auto-critique

Score from 0 to 5: decision justified, multi stage used, layer order
cache friendly, base pinned, non root, signals handled, health check
meaningful, no secret in any layer, compose limited to local dependencies,
audit performed.

Threshold: no axis below 3, average at least 4. A secret in an image layer, or
an image whose health check cannot fail, is an automatic failure.

## 9. Interfaces

- Upstream: `devops-core`, `technology-selection`,
  `environment-management`.
- Lateral: `ci-cd-pipelines` builds the image, `security-audit` reviews the
  base and the layers.
- Downstream: `deployment-engineering`, `production-verification`.
