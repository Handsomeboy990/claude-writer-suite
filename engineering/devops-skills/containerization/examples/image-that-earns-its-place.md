# Example: two Dockerfiles for the same application

## The first one, which works

```dockerfile
FROM node:latest
WORKDIR /app
COPY . .
RUN npm install
ENV DATABASE_URL=postgres://app:app@db:5432/app
ENV SESSION_SECRET=dev-secret
EXPOSE 3000
CMD npm start
```

Eight lines, builds, runs. Seven defects.

**`node:latest`.** The image built in June and the image built in September
contain different runtimes. A failure that appears only in the newer one is
attributed to the code.

**`COPY . .` before `npm install`.** Every source change invalidates the
dependency layer. A one character edit triggers a full reinstall.

**Everything copied.** The git directory, the tests, local configuration
files, and any `.env` present in the build context, all inside the image.

**`npm install` with development dependencies.** The runtime image carries
compilers, test frameworks and type definitions. Larger, slower to pull, more
surface.

**Secrets in `ENV`.** They are in the image history. Anyone who can pull the
image can read them, and they are the same in every environment.

**Root.** No user is created, so the process runs as root.

**`CMD npm start`.** The shell form makes the shell the main process. The
termination signal goes to the shell, the application never receives it, the
platform waits out the grace period and kills it, and in flight requests are
dropped on every deploy.

## The second one

```dockerfile
# Build stage
FROM node:24.4.1-bookworm-slim AS build
WORKDIR /app

COPY package.json package-lock.json ./
RUN npm ci

COPY . .
RUN npm run build && npm prune --omit=dev

# Runtime stage
FROM node:24.4.1-bookworm-slim AS runtime
WORKDIR /app

RUN useradd --system --uid 1001 --create-home app

COPY --from=build --chown=app:app /app/node_modules ./node_modules
COPY --from=build --chown=app:app /app/dist ./dist
COPY --from=build --chown=app:app /app/package.json ./

USER app
EXPOSE 3000

HEALTHCHECK --interval=30s --timeout=3s --start-period=10s --retries=3 \
  CMD node dist/healthcheck.js

CMD ["node", "dist/server.js"]
```

Each change tied to a defect above.

**Pinned base**, both stages, same version. Two builds of one commit produce
equivalent images.

**Manifests before source.** `npm ci` runs only when the lockfile changes. An
ordinary source edit rebuilds in seconds.

**`npm ci`, not `npm install`.** Installs exactly the lockfile, fails when the
manifest and lockfile disagree, which is a defect worth failing on.

**Two stages.** The runtime stage receives `node_modules` after pruning, the
build output, and the manifest. No source, no compilers, no test tooling.

**A user with a fixed identifier**, owning what it needs, active before the
entry point.

**Exec form entry point.** `node` is process 1 and receives the signal.

**Health check running in process**, checking what matters, with a start
period so a slow boot does not report unhealthy.

**No `ENV` for configuration.** Injected at runtime.

## The health check itself

```js
// dist/healthcheck.js
import { db } from "./db.js"

const timeout = setTimeout(() => process.exit(1), 2500)

try {
  await db.raw("select 1")
  clearTimeout(timeout)
  process.exit(0)
} catch {
  process.exit(1)
}
```

It checks the database, because an application that cannot reach its database
cannot serve. It does not check the payment provider: an outage there should
degrade a feature, not take every instance out of rotation.

That distinction is the one that turns a provider incident into a full
outage when it is decided wrongly.

## The signal handling it depends on

```ts
// server.ts
const server = app.listen(3000)

process.on("SIGTERM", async () => {
  server.close()               // stop accepting, finish in flight
  await db.destroy()
  process.exit(0)
})
```

Without this, the exec form entry point delivers a signal the application
ignores, and the outcome is the same dropped requests as the shell form.

## The compose file, for local dependencies only

```yaml
services:
  db:
    image: postgres:16.3-bookworm
    environment:
      POSTGRES_USER: app
      POSTGRES_PASSWORD: local-development-only
      POSTGRES_DB: app_dev
    ports:
      - "5432:5432"
    volumes:
      - pgdata:/var/lib/postgresql/data
    healthcheck:
      test: ["CMD-SHELL", "pg_isready -U app"]
      interval: 5s
      timeout: 3s
      retries: 10

volumes:
  pgdata:
```

The application is absent. Every developer runs Node locally and only needs
the database. Adding the application would mean rebuilding an image on every
edit, for no benefit.

The password is a local development string, and the file states it. It is not
a real credential and it is not reused anywhere.

Reset command, documented in the readme:

```bash
docker compose down -v && docker compose up -d && npm run db:migrate && npm run db:seed
```

## The verification that was run

```
docker build .                 6.2s cached, 48s cold
docker image inspect           User: app
docker history                 no secret in any layer
docker run                     starts, healthy after 8s
docker stop                    exits in 1.4s, logs show connections closed
docker run --env-file /dev/null
                               "DATABASE_URL is not set. Refusing to start."
                               exit 1
Image size                     186 MB, against 1.4 GB for the first version
```

The last line is the practical difference on every pull, on every instance,
on every deploy.
