<!-- markdownlint-disable MD060 -->

# Compose File Conventions & Patterns

These are the established patterns used throughout this stack. New compose files and targeted updates to existing ones should follow these conventions unless a specific upstream image requires something different.

## File Location & Structure

```text
stack/
└── <app-name>/
    └── compose.yaml
```

- Individual compose files live at `stack/<app-name>/compose.yaml`.
- No top-level `name:` field in individual compose files.
- No top-level `networks:` block in individual compose files.
- Prefer bind mounts into `../../local-volumes/`.

## Volume Paths

Use bind mounts relative to the app compose file:

```yaml
volumes:
  - ../../local-volumes/<app-name>/<subdir>:/container/path
```

Common patterns:

| Purpose | Path |
|---------|------|
| App data | `local-volumes/<app>/data` |
| App config | `local-volumes/<app>/config` |
| Redis/Valkey data | `local-volumes/<app>/redis` or `local-volumes/<app>/valkey` |
| Meilisearch data | `local-volumes/<app>/meilisearch` |
| Storage/uploads | `local-volumes/<app>/storage` |

All shared Postgres data lives under `local-volumes/postgres-shared/postgresql`.

## Service Naming

- Service names should be descriptive and consistent with the stack directory name.
- `container_name` usually matches the primary service name, but some apps use explicit upstream-specific names already present in the stack, such as `affine-server`, `blinko-web`, or `karakeep-web`.
- Sidecars should be prefixed with the app name, such as `<app>-redis`, `<app>-valkey`, `<app>-meilisearch`, or `<app>-chrome`.
- There is no `<app>-postgres` service in this stack.

## Restart Policy

Persistent services should use:

```yaml
restart: unless-stopped
```

One-shot migration jobs should use the upstream default or `restart: "no"` when needed.

## Shared Postgres Pattern

All Postgres-backed apps connect to the single `postgres-shared` service.

Typical pattern:

```yaml
depends_on:
  postgres-shared:
    condition: service_healthy
environment:
  DATABASE_URL: "postgresql://${APP_POSTGRES_USER}:${APP_POSTGRES_PASSWORD}@postgres-shared:5432/${APP_POSTGRES_DB}"
```

Before starting a new Postgres-backed app, create its role and database in the shared instance:

```sql
CREATE ROLE appname WITH LOGIN PASSWORD 'replace-with-your-password';
CREATE DATABASE appname OWNER appname;
```

Only add `CREATE EXTENSION IF NOT EXISTS vector;` when the app actually needs `pgvector`.

DBGate is the current browser UI for the shared Postgres instance. Do not document or assume an older database UI or maintenance sidecar unless they are added back to the stack.

## Environment Variables

- All env vars come from the root `.env` file via the root `compose.yaml` include block.
- Required secrets should use `${VAR:?missing}` when practical.
- Optional values should use `${VAR:-default}`.
- Published host ports should use namespaced env vars, never hard-coded literals.
- Follow the current sequential app-port range when assigning defaults; the next typical sequential app port is currently 8372.

Example:

```yaml
ports:
  - "${APP_PORT:-8372}:3000"
  - "${APP_ADMIN_PORT:-8373}:3100"
```

## Healthchecks

Use healthchecks on supporting services and on app services when upstream images expose a stable readiness endpoint.

Postgres:

```yaml
healthcheck:
  test: ["CMD", "pg_isready", "-U", "${POSTGRES_SHARED_SUPERUSER}", "-d", "${POSTGRES_SHARED_DEFAULT_DB}"]
  interval: 10s
  timeout: 5s
  retries: 5
```

Redis:

```yaml
healthcheck:
  test: ["CMD", "redis-cli", "--raw", "incr", "ping"]
  interval: 10s
  timeout: 5s
  retries: 5
```

Valkey:

```yaml
healthcheck:
  test: ["CMD", "valkey-cli", "ping"]
  interval: 10s
  timeout: 3s
  retries: 5
  start_period: 5s
```

HTTP app:

```yaml
healthcheck:
  test: ["CMD-SHELL", "curl -f http://localhost:3000/health || exit 1"]
  interval: 30s
  timeout: 10s
  retries: 3
```

## Accessing Host Services

When a container needs Ollama or LM Studio on the host:

```yaml
extra_hosts:
  - "host.docker.internal:host-gateway"
environment:
  OLLAMA_BASE_URL: "${OLLAMA_BASE_URL:-http://host.docker.internal:11434}"
```

## Valkey / Redis / Search Sidecars

Prefer whatever the current stack already uses for the app category:

- SearXNG uses Valkey.
- Affine and Docmost currently use Redis.
- Karakeep uses Meilisearch and Chrome sidecars.

Stay consistent with the nearest comparable app instead of forcing a single sidecar choice everywhere.

## Multi-Port Apps

For apps with separate frontend, admin, or API ports:

```yaml
ports:
  - "${APP_PORT:-8372}:3000"
  - "${APP_ADMIN_PORT:-8373}:3100"
  - "${APP_API_PORT:-8374}:3170"
```

Hoppscotch is the current reference pattern for this.

## Docker Socket Access

For management/dashboard apps that need container metadata:

```yaml
volumes:
  - /var/run/docker.sock:/var/run/docker.sock
```

Used by Homepage, Dockpeek, Dozzle, Portainer, and Uptime Kuma.

## Registering in Root compose.yaml

After creating `stack/<app-name>/compose.yaml`, add it to the root `compose.yaml` `include:` block under the appropriate category comment.

Do not add `env_file` in individual compose files.

## Image Tag Guidance

| Pattern | When to use |
|---------|-------------|
| `:stable` or `:release` | Preferred when published by upstream |
| `:latest` | Acceptable only when upstream treats it as the recommended tag |
| `:<version>` | Use when pinning for stability |
| `:main` / `:main-stable` | Use only when the stack already tracks that upstream channel |

Always verify tags against current upstream docs before editing compose files.

## Example Pattern

```yaml
services:
  myapp:
    image: registry/myapp:stable
    container_name: myapp
    restart: unless-stopped
    depends_on:
      postgres-shared:
        condition: service_healthy
    ports:
      - "${MYAPP_PORT:-8372}:8080"
    environment:
      DATABASE_URL: "postgresql://${MYAPP_POSTGRES_USER}:${MYAPP_POSTGRES_PASSWORD}@postgres-shared:5432/${MYAPP_POSTGRES_DB}"
      SECRET_KEY: "${MYAPP_SECRET_KEY:?missing}"
    volumes:
      - ../../local-volumes/myapp/data:/app/data
```
