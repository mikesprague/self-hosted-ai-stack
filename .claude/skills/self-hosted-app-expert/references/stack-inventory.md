<!-- markdownlint-disable MD060 -->

# Stack App Inventory

Complete inventory of all apps in the self-hosted stack. Apps marked [inactive] are defined but commented out in the root `compose.yaml` include block or otherwise not currently part of the active stack. At the moment, only `home-assistant` is present but commented out.

## Infrastructure / Data

| App | Container | Port | Status | Notes |
|-----|-----------|------|--------|-------|
| postgres-shared | `postgres-shared` | 5432 | active | Single shared `pgvector/pgvector:pg18` Postgres instance for all Postgres-backed apps |
| dbgate | `dbgate` | 8370 | active | Browser-based database manager preconfigured for `postgres-shared` |

## Personal Cloud

| App | Container | Port | Status | Notes |
|-----|-----------|------|--------|-------|
| nextcloud | `nextcloud` | 8361 | active | Personal cloud / sync service backed by MariaDB + Redis |

## AI / Research

| App | Container | Port | Postgres | Status | Notes |
|-----|-----------|------|----------|--------|-------|
| open-webui | `open-webui` | 3000 | shared | active | Main chat UI; integrates Ollama, Azure, SearXNG, and MCP servers |
| open-notebook | `open-notebook` | 8502 (UI), 5055 (API) | No (SurrealDB) | active | AI notebook with SurrealDB sidecar |
| litellm | `litellm` | 4000 | shared | active | OpenAI-compatible LLM proxy/gateway |
| searxng | `searxng` | 8348 | No | active | Privacy-preserving meta search engine used by AI workflows |

## Knowledge Management

| App | Container | Port | Postgres | Status | Notes |
|-----|-----------|------|----------|--------|-------|
| affine | `affine-server` | 3010 | shared | active | Workspace with docs, whiteboards, and databases; uses Redis sidecar + migration job |
| blinko | `blinko-web` | 1111 | shared | active | AI note-taking app with Tailnet-based callback URLs |
| docmost | `docmost` | 7889 | shared | active | Collaborative wiki/docs app; also uses Redis sidecar |
| flatnotes | `flatnotes` | 8352 | No | active | Flat-file markdown notes |
| joplin-server | `joplin-server` | 22300 | shared | active | Joplin sync server; uses Mailpit for outbound email |
| jotty | `jotty` | 1122 | No | active | Minimal notes/checklists app |
| karakeep | `karakeep-web` | 7788 | No | active | Bookmark/read-later manager; uses Meilisearch + Chrome sidecars |
| logseq | `logseq` | 8360 | No | active | Local-first outliner / graph workspace |
| memos | `memos` | 5230 | shared | active | Lightweight notes and journaling |
| silverbullet | `silverbullet` | 8350 | No | active | Markdown personal wiki |
| trilium-notes | `trilium` | 8351 | No | active | Hierarchical notes app |

## Recipes

| App | Container | Port | Postgres | Status | Notes |
|-----|-----------|------|----------|--------|-------|
| mealie | `mealie` | 8367 | shared | active | Recipe manager; uses Mailpit SMTP and Azure OpenAI-compatible features |

## RSS / Feed Reading

| App | Container | Port | Postgres | Status | Notes |
|-----|-----------|------|----------|--------|-------|
| freshrss | `freshrss` | 8353 | shared | active | Self-hosted RSS aggregator |

## Task Management / Productivity

| App | Container | Port | Deps | Status | Notes |
|-----|-----------|------|------|--------|-------|
| super-productivity | `super-productivity` | 8354 | WebDAV sidecar | active | Task/time tracking app with bundled WebDAV sync |

## Automation / Workflow

| App | Container | Port | Postgres | Status | Notes |
|-----|-----------|------|----------|--------|-------|
| flowise | `flowise` | 8355 | shared | active | LLM workflow builder |
| n8n | `n8n` | 5678 | shared | active | Workflow automation; depends on Tailnet domain for webhook/public URL config |

## Password Management

| App | Container | Port | Status | Notes |
|-----|-----------|------|--------|-------|
| vaultwarden | `vaultwarden` | 8359 | active | Requires HTTPS domain and Argon2 admin token |

## Monitoring / Management

| App | Container | Port | Status | Notes |
|-----|-----------|------|--------|-------|
| dockpeek | `dockpeek` | 8368 | active | Lightweight Docker dashboard; mounts Docker socket |
| dozzle | `dozzle` | 8357 | active | Docker log viewer; mounts Docker socket |
| portainer | `portainer` | 8358 (HTTP), 9443 (HTTPS) | active | Docker management UI; mounts Docker socket |
| uptime-kuma | `uptime-kuma` | 8356 | active | Service uptime monitoring; mounts Docker socket |

## Mail / Delivery

| App | Container | Port | Status | Notes |
|-----|-----------|------|--------|-------|
| mailpit | `mailpit` | 8025 (UI), 1025 (SMTP) | active | Local SMTP sink used by Joplin Server, Hoppscotch, and Mealie |

## API Development / Testing

| App | Container | Port | Postgres | Status | Notes |
|-----|-----------|------|----------|--------|-------|
| hoppscotch | `hoppscotch` | 8363 (app), 3100 (admin), 3170 (API) | shared | active | Multi-service API development suite |
| restfox | `restfox` | 8365 | No | active | Lightweight offline-first REST client |
| yaade | `yaade` | 8364 | No | active | Self-hosted API collection manager |

## Utilities

| App | Container | Port | Status | Notes |
|-----|-----------|------|--------|-------|
| vert | `vert` | 8369 | active | File conversion web app |

## Dashboard

| App | Container | Port | Status | Notes |
|-----|-----------|------|--------|-------|
| homepage | `homepage` | 8349 | active | Dashboard / start page; mounts Docker socket |

## Optional / Inactive

| App | Container | Port | Status | Notes |
|-----|-----------|------|--------|-------|
| home-assistant | `home-assistant` | 8362 | inactive | Compose file exists but include is commented out in root `compose.yaml` |

## Ports Quick Reference

> Port assignments must always use namespaced env vars in compose files.
> The current sequential app-port range in active use runs through 8371, so new ports should typically start at 8372 unless an app needs a well-known upstream port.

| Port | App |
|------|-----|
| 1025 | mailpit SMTP |
| 1111 | blinko |
| 1122 | jotty |
| 3000 | open-webui |
| 3010 | affine |
| 3100 | hoppscotch admin |
| 3170 | hoppscotch API |
| 4000 | litellm |
| 5055 | open-notebook API |
| 5230 | memos |
| 5678 | n8n |
| 7788 | karakeep |
| 7889 | docmost |
| 8025 | mailpit UI |
| 8348 | searxng |
| 8349 | homepage |
| 8350 | silverbullet |
| 8351 | trilium-notes |
| 8352 | flatnotes |
| 8353 | freshrss |
| 8354 | super-productivity |
| 8355 | flowise |
| 8356 | uptime-kuma |
| 8357 | dozzle |
| 8358 | portainer HTTP |
| 8359 | vaultwarden |
| 8360 | logseq |
| 8361 | nextcloud |
| 8362 | home-assistant [inactive] |
| 8363 | hoppscotch app |
| 8364 | yaade |
| 8365 | restfox |
| 8367 | mealie |
| 8368 | dockpeek |
| 8369 | vert |
| 8370 | dbgate |
| 8371 | mailpit default UI port in compose |
| 9443 | portainer HTTPS |
| 22300 | joplin-server |

## External Integrations (Shared)

| Service | How to reach | Env Var |
|---------|-------------|---------|
| Ollama (host) | `http://host.docker.internal:11434` | `OLLAMA_BASE_URL` |
| LM Studio (host) | `http://host.docker.internal:1234/v1` | `LM_STUDIO_OPENAI_API_URL` |
| Azure Foundry base URL | `AZURE_FOUNDRY_BASE_URL` | `AZURE_FOUNDRY_API_KEY` or `AZURE_OPENAI_API_KEY` depending on app |
| Azure Foundry OpenAI-compatible URL | `AZURE_FOUNDRY_OPENAI_BASE_URL` | `AZURE_FOUNDRY_API_KEY` or `AZURE_OPENAI_API_KEY` depending on app |
| SearXNG (internal) | `http://searxng:8080` | — |
| Context7 MCP (external) | `https://mcp.context7.com/mcp` | `CONTEXT7_API_KEY` |
| Mermaid MCP (external) | `https://mcp.mermaid.ai/mcp` | — |
| Mailpit SMTP (internal) | `mailpit:1025` | `MAILPIT_SMTP_PORT` |
