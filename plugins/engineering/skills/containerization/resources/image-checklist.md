# Image checklist

## Decision

- [ ] The question of whether a container is warranted was answered in
      writing.
- [ ] The platform actually consumes container images, or another reason from
      the decision table applies.
- [ ] The alternative, building from source on the platform, was considered.

## Build

- [ ] Multi stage: build dependencies do not reach the runtime stage.
- [ ] Base image pinned to a specific version, not a floating tag.
- [ ] Layer order runs from least to most frequently changing.
- [ ] Dependency manifests are copied and installed before the source.
- [ ] Package manager caches are not left in the final image.
- [ ] Only runtime packages are installed in the final stage.
- [ ] The build is reproducible: the same commit produces equivalent images.
- [ ] Ignore file excludes the git directory, dependencies, tests and local
      configuration from the build context.

## Runtime

- [ ] A non root user is created and used, unless the platform imposes one.
- [ ] File ownership matches the running user.
- [ ] The entry point makes the application the main process, so it receives
      signals.
- [ ] Termination is handled: in flight work finishes, connections close.
- [ ] The grace period is longer than the longest normal request.
- [ ] A health check exists.
- [ ] The health check fails when the application cannot serve.
- [ ] The health check does not depend on an external service.
- [ ] The health check has a timeout shorter than its interval.

## Configuration

- [ ] No secret in a build argument.
- [ ] No secret in an environment instruction.
- [ ] No secret in any layer, verified by inspecting the image history.
- [ ] Configuration is injected at runtime.
- [ ] The image is identical across environments; only configuration differs.

## Size and surface

- [ ] Image size stated.
- [ ] The size is proportionate to the artefact, not an order of magnitude
      above it.
- [ ] No shell tooling, editors or debuggers in the final stage.
- [ ] No source tree in the final stage where a build artefact suffices.
- [ ] Base image advisories reviewed.

## Compose, where present

- [ ] Contains local dependencies, not production configuration.
- [ ] No real credential anywhere in it.
- [ ] Named volumes for data that should survive a restart.
- [ ] Health check on the database so the application waits for it.
- [ ] A documented reset command exists and was tested.
- [ ] The file is usable by a developer on a clean machine.

## Verification, performed not assumed

```
docker build .                     builds
docker image inspect <image>       user is not root
docker history <image>             no secret in any layer
docker run <image>                 starts, health check passes
docker stop <container>            exits cleanly within the grace period
docker run --env-file /dev/null    fails fast with a named missing variable
```

The last line is the one that ties this skill to `devops-core` section 4: an
image that starts happily with no configuration is an image that will start
happily in production with the wrong configuration.
