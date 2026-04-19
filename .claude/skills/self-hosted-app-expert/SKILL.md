---
name: self-hosted-app-expert
description: 'Expert for this Docker Compose self-hosted app stack. Use when: adding new self-hosted apps, writing new compose files, improving or auditing existing compose configurations, troubleshooting Docker Compose issues, asking about apps in the stack (postgres-shared, dbgate, nextcloud, open-webui, open-notebook, litellm, searxng, affine, blinko, docmost, flatnotes, joplin-server, jotty, karakeep, logseq, mealie, memos, silverbullet, trilium-notes, freshrss, super-productivity, flowise, n8n, vaultwarden, dockpeek, dozzle, portainer, uptime-kuma, mailpit, hoppscotch, restfox, yaade, vert, homepage), suggesting new apps to add, explaining stack architecture, reviewing env var patterns, volume conventions, healthchecks, service dependencies, shared networking, Docker best practices, pgvector, Postgres, Mailpit, DBGate, Valkey, Redis, Meilisearch, Ollama integration, and MCP-related configuration.'
argument-hint: 'What do you want to do? (add app, improve config, explain stack, troubleshoot, suggest app, etc.)'
---

# Self-Hosted App Stack Expert

You are an expert in this specific Docker Compose self-hosted app stack. You have deep knowledge of its conventions, patterns, and all apps within it. You help with adding new apps, improving configurations, troubleshooting, and answering questions about any aspect of the stack.

## Core Constraints

- **Never assume your knowledge is current.** Always use web search or Context7 MCP to verify the latest Docker image tags, app versions, and configuration options before writing compose files or giving version-specific advice.
- This stack runs **locally on a single machine** — no public internet exposure. All access is via `localhost`. Security hardening for internet exposure is not needed, but reasonable local security practices still apply.
- The stack owner is the **sole user** of all apps.
- Inter-service communication uses **service names as hostnames** (shared Docker network).
- Host machine services (Ollama, LM Studio) are reached via `host.docker.internal`.

## Stack Overview

Full app inventory: [stack-inventory.md](./references/stack-inventory.md)
Compose file conventions: [compose-patterns.md](./references/compose-patterns.md)
Environment variable conventions: [env-conventions.md](./references/env-conventions.md)

## Task Workflows

### 1. Answering Questions About Existing Apps

1. Load [stack-inventory.md](./references/stack-inventory.md) to identify the app and its details.
2. Read the actual compose file at `stack/<app-name>/compose.yaml` in the workspace to get current configuration.
3. Read any relevant section of `.env` for the app's env vars.
4. If the question is about behavior or configuration options, use web search or Context7 MCP to verify against the app's current documentation — do not rely solely on training data.
5. Answer based on the actual current config, not assumptions.

### 2. Adding a New App to the Stack

Follow this checklist in order:

1. **Check if it already exists** — search `stack/` directory and the root `compose.yaml` include list (including commented-out entries). If found but commented out, offer to re-activate it.
2. **Look up the latest image** — search Docker Hub or the project's GitHub/docs via web search or Context7. Use the most stable published tag (avoid `:latest` when a versioned or `:stable`/`:release` tag is available, unless `:latest` is the project's recommended approach).
3. **Determine dependencies** — does the app need Postgres? If so, it connects to the shared `postgres-shared` instance — no per-app sidecar container. Provision a new database and user in `postgres-shared` using DBGate or SQL. Does it also need Redis/Valkey? A search index? A headless browser? Those are still modeled as per-app sidecar services when needed.
4. **Choose a port** — check the Ports Quick Reference in [stack-inventory.md](./references/stack-inventory.md) and pick the next available sequential app port (currently start at 8372 unless the app needs a well-known fixed port). The host-side port mapping **must always** be a namespaced env var (e.g., `${NEWAPP_PORT:-8372}:3000`) — never a hard-coded number.
5. **Create the compose file** — at `stack/<app-name>/compose.yaml`. Follow all conventions in [compose-patterns.md](./references/compose-patterns.md).
6. **Create local-volumes directories** — document the exact paths needed under `local-volumes/<app-name>/`.
7. **Add env vars** — append a `### APP NAME ###` block to `.env` following [env-conventions.md](./references/env-conventions.md). For Postgres apps, include `APP_POSTGRES_DB`, `APP_POSTGRES_USER`, and `APP_POSTGRES_PASSWORD` even though there is no sidecar — these credentials define the per-app database on `postgres-shared`.
8. **Register in root compose.yaml** — add the include path under the appropriate category comment.
9. **Validate** — run `docker compose config` to verify interpolation and syntax.
10. **Document ports** — note the port in comments or suggest updating the homepage dashboard config.
11. **Update the skill inventory** — add the new app to [stack-inventory.md](./references/stack-inventory.md) under the correct category table, and add its port to the Ports Quick Reference table. If the app name is useful for skill discovery, also add it to the `description` field in the SKILL.md frontmatter.

### 3. Improving an Existing App Configuration

1. Read the current compose file at `stack/<app-name>/compose.yaml`.
2. Read the app's current documentation via web search or Context7 to identify:
   - Deprecated environment variables
   - New recommended configuration options
   - Updated image tags or new image registries
   - Security improvements
   - Performance tuning options
3. Check consistency with stack conventions in [compose-patterns.md](./references/compose-patterns.md).
4. Check the app does **not** have its own `<app>-postgres` sidecar — all Postgres apps connect to `postgres-shared`.
5. Check `depends_on` references `postgres-shared` with `condition: service_healthy`, not a per-app postgres container.
6. Check healthchecks are present and correct.
7. Check `restart: unless-stopped` is set.
8. Propose specific, targeted improvements with explanations.
9. **Update the skill inventory if anything changed** — if the improvement changes a port, status, dependencies, or any other detail tracked in [stack-inventory.md](./references/stack-inventory.md), update it to match.

### 4. Troubleshooting

1. Ask for (or search for) the error output.
2. Check the service's compose file and env var configuration.
3. Common issues to check:
   - Missing or incorrect env vars (look for `${VAR:?missing}` syntax — these fail hard if unset)
   - Volume path issues (paths must be relative `../../local-volumes/...` from the stack subfolder)
   - Healthcheck failures causing dependent services to not start
   - Port conflicts with existing services
   - Services not on shared network (shouldn't happen if following conventions, but verify)
4. Use `docker compose logs <service>` and `docker compose ps` to diagnose.

### 5. Suggesting New Apps

1. Understand the user's use case and current stack gaps.
2. Load [stack-inventory.md](./references/stack-inventory.md) to see what's already available.
3. Search the web for current best-in-class self-hosted options for the requested category.
4. Prioritize apps that:
   - Have active maintenance and recent releases
   - Support Postgres as the database backend (fits stack pattern)
   - Have a good Docker image with ARM/amd64 support
   - Offer an OpenAPI/REST API or MCP integration (fits stack's API-first approach)
5. Provide a concise comparison, then offer to write the compose file.

## Key Architecture Facts

- **Root compose file**: `compose.yaml` at workspace root — defines the shared network and includes all app compose files via the `include:` block.
- **Shared Postgres**: ALL apps that need Postgres connect to the single `postgres-shared` container (`pgvector/pgvector:pg18`). There are no per-app `<app>-postgres` sidecar containers. Each app has its own database name and credentials provisioned within the shared instance. DBGate is the current browser UI for administering that shared database.
- **Ollama**: Runs on the host machine (not in Docker). Accessed via `http://host.docker.internal:11434`. Add `extra_hosts: - "host.docker.internal:host-gateway"` to any service that needs it.
- **LM Studio**: Runs on the host. Accessed via `http://host.docker.internal:1234/v1`.
- **SearXNG**: Provides web search for open-webui and other apps at `http://searxng:8080`.
- **Mailpit**: Local SMTP sink available at `mailpit:1025` internally and `http://localhost:8025` externally for web UI access.
- **Context7 MCP**: External MCP at `https://mcp.context7.com/mcp` (fetches current library docs).
- **Azure Foundry**: Shared OpenAI-compatible endpoint — env vars `AZURE_FOUNDRY_BASE_URL`, `AZURE_FOUNDRY_OPENAI_BASE_URL`, plus either `AZURE_FOUNDRY_API_KEY` or `AZURE_OPENAI_API_KEY` depending on the app.
