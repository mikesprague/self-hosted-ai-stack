# Self-Hosted App Stack

Docker Compose workspace for running a personal collection of self-hosted apps across AI and research, knowledge management, feeds, productivity, automation, password management, monitoring and management, and dashboard use cases on a shared network with persistent local storage.

The stack is split into per-app compose files under `stack/` and assembled by the root `compose.yaml` using Compose `include`. Persistent data lives under `local-volumes/`.

Several note-taking and knowledge-management apps are included on purpose. They each have different strengths around capture, organization, collaboration, publishing, or personal knowledge management, and this stack is being used to evaluate them side by side before settling on a smaller long-term set.

## Included Services

| Service | Purpose |
| --- | --- |
| **AI / Research** | |
| [Open WebUI](https://openwebui.com/) | Unified chat interface for local and cloud LLMs |
| [SearXNG](https://searxng.org/) | Private internet metasearch engine that aggregates results from several search services |
| [Open Notebook](https://www.open-notebook.ai/) | Private, multi-model, 100% local, full-featured alternative to Notebook LM |
| **Knowledge Management** | |
| [Affine](https://affine.pro/) | Workspace with fully merged docs, whiteboards and databases |
| [Blinko](https://blinko.space/) | AI-powered card notes for quick capture and organization |
| [Docmost](https://docmost.com/) | Collaborative wiki with real-time editing, team spaces, and AI |
| [Flatnotes](https://github.com/Dullage/flatnotes) | Distraction-free markdown notes stored as plain searchable files |
| [Jotty](https://github.com/fccview/jotty) | Personal checklists and rich text notes with file-based storage |
| [Karakeep](https://karakeep.app/) | Save bookmarks, notes, and images with AI auto-tagging |
| [Memos](https://www.usememos.com/) | Quick-capture markdown notes on a private personal timeline |
| [Silverbullet](https://silverbullet.md/) | Programmable markdown knowledge base with live queries and scripting |
| [Trilium Notes](https://triliumnext.github.io/Notes/) | Hierarchical note-taking for building rich personal knowledge bases |
| **Feeds** | |
| [FreshRSS](https://freshrss.org/) | Fast, customizable RSS and Atom feed aggregator |
| **Productivity** | |
| [Super Productivity](https://super-productivity.com/) | Privacy-focused deep work system with tasks, time tracking, and focus tools |
| **Automation / Workflows** | |
| [Flowise](https://flowiseai.com/) | Drag-and-drop platform for building AI agents and chatbots |
| [n8n](https://n8n.io/) | Workflow automation connecting APIs, apps, and services |
| **Password Management** | |
| [Vaultwarden](https://vaultwarden.net/) | Lightweight Bitwarden-compatible server for encrypted credentials |
| **Monitoring & Management** | |
| [Dozzle](https://dozzle.dev/) | Real-time web-based viewer for Docker container logs |
| [Uptime Kuma](https://github.com/louislam/uptime-kuma) | Customizable uptime monitor for sites and network services |
| [Portainer](https://www.portainer.io/) | Visual Docker management dashboard for containers and stacks |
| **Dashboard** | |
| [Homepage](https://gethomepage.dev/) | Highly customizable app dashboard with 100+ service integrations |

<details>
<summary>Local URLs</summary>

| Service | Local URL |
| --- | --- |
| Open WebUI | <http://localhost:3000> |
| SearXNG | <http://localhost:8348> |
| Open Notebook | <http://localhost:8502> |
| Karakeep | <http://localhost:7788> |
| Affine | <http://localhost:3010> |
| Blinko | <http://localhost:1111> |
| Docmost | <http://localhost:7889> |
| Flatnotes | <http://localhost:8352> |
| Jotty | <http://localhost:1122> |
| Memos | <http://localhost:5230> |
| Silverbullet | <http://localhost:8350> |
| Trilium Notes | <http://localhost:8351> |
| FreshRSS | <http://localhost:8353> |
| Super Productivity | <http://localhost:8354> |
| Flowise | <http://localhost:8355> |
| n8n | <http://localhost:5678> |
| Vaultwarden | <http://localhost:8359> |
| Dozzle | <http://localhost:8357> |
| Uptime Kuma | <http://localhost:8356> |
| Portainer | <http://localhost:8358> |
| Homepage | <http://localhost:8349> |

</details>

## Quick Start

Requires [Docker Desktop](https://www.docker.com/products/docker-desktop/) (or Podman / OrbStack) with modern Compose support and enough disk space for databases, indexes, and uploads under `local-volumes/`. [Ollama](https://ollama.com/) is needed only for AI features — `gemma4` and `embeddinggemma` are good starting models.

1. Clone the repository.
2. Copy the example environment file.
3. Fill in the required secrets and credentials. For any field marked `openssl rand -hex 32`, run that command in your terminal to generate a secure value.
4. Start the stack with Docker Compose.

```sh
git clone https://github.com/mikesprague/self-hosted-app-stack.git
cd self-hosted-app-stack
cp .env.example .env
docker compose pull
docker compose up -d
```

To stop everything:

```sh
docker compose down
```

**Optional providers:** [Context7](https://context7.com/) (free) for the preconfigured MCP integration in Open WebUI, [Jina AI](https://jina.ai/) (free) for Jina-backed features, [LM Studio](https://lmstudio.ai/) (free) as an alternative local model runner, and [Azure Foundry](https://ai.azure.com/) if you prefer cloud-hosted models over local ones.

## Configuration

The root compose file loads environment variables from `.env` and includes the per-service definitions from `stack/`. Start with `.env.example` and review these groups before bringing the stack up:

| Variable group | Affects | Required |
| --- | --- | --- |
| `SEARXNG_SECRET_KEY` | SearXNG | Yes |
| `OPEN_WEBUI_*` | Open WebUI | Yes |
| `OPEN_NOTEBOOK_ENCRYPTION_KEY` | Open Notebook | Yes |
| `KARAKEEP_*` | Karakeep | Yes |
| `AFFINE_*` | Affine | Yes |
| `DOCMOST_*` | Docmost | Yes |
| `BLINKO_*` | Blinko | Yes |
| `FLATNOTES_*` | Flatnotes | Yes |
| `MEMOS_*` | Memos | Yes |
| `SILVERBULLET_*` | Silverbullet | Yes |
| `FRESHRSS_*` | FreshRSS | Yes |
| `SP_WEBDAV_*` | Super Productivity | Yes |
| `FLOWISE_*` | Flowise | Yes |
| `N8N_*` | n8n | Yes |
| `HOMEPAGE_*` | Homepage | Yes |
| `PORTAINER_*` | Portainer | Yes |
| `VAULTWARDEN_*` | Vaultwarden | Yes |
| `TZ` | All services | Yes — set to your timezone (e.g. `America/New_York`) |
| `AZURE_*`, `OLLAMA_*` | AI-enabled apps | Only if using that provider |
| `CONTEXT7_API_KEY`, `JINA_API_KEY`, `UNSPLASH_*` | Open WebUI and others | Optional |

If you switch between Azure Foundry, Ollama, or another model provider, update the values consumed by Karakeep, Docmost, Open WebUI, and Open Notebook. Dozzle, Homepage, Jotty, Trilium Notes, and Uptime Kuma have no required `.env` entries.

### Homepage Configuration

The Homepage config lives under [local-volumes/homepage/config](local-volumes/homepage/config). The included [settings.yaml](local-volumes/homepage/config/settings.yaml) and [custom.css](local-volumes/homepage/config/custom.css) are meant to be tweaked as desired for your preferred look and behavior.

To use the bundled examples for service and widget definitions, copy [services.example.yaml](local-volumes/homepage/config/services.example.yaml) and [widgets.example.yaml](local-volumes/homepage/config/widgets.example.yaml), remove the `.example` suffix, and edit them as needed.

## Integrations

Some parts of the stack are wired together out of the box:

- **Open WebUI → SearXNG**: web-enabled LLM workflows use the local SearXNG instance by default.
- **Open WebUI → Ollama**: preconfigured via `OLLAMA_API_URL` and `OLLAMA_API_KEY`.
- **Open WebUI → Context7 MCP**: pulls current library and framework docs when `CONTEXT7_API_KEY` is set.

Two services require manual setup after startup:

- **Open Notebook**: provider and application-level configuration must be completed manually.
- **Vaultwarden**: requires a valid HTTPS `VAULTWARDEN_DOMAIN` and a generated Argon2 admin token before first use.

## Service Layout

Each app has its own compose file at `stack/<service>/compose.yaml` and a matching data folder at `local-volumes/<service>/` for databases, uploads, indexes, and app state. The root `compose.yaml` assembles them all via Compose `include`.

## Operating The Stack

```sh
docker compose ps
docker compose logs -f
docker compose logs -f open-webui
docker compose restart
docker compose pull && docker compose up -d
```

You can also operate services individually by name. For example, `docker compose up -d docmost` starts only Docmost and its dependencies, while `docker compose stop docmost` stops that service without tearing down the rest of the stack.

```sh
docker compose up -d docmost
docker compose stop docmost
docker compose restart docmost
docker compose logs -f docmost
docker compose rm -f docmost   # remove a stopped container without losing data
```

## Notes

- All services share the `self-hosted-app-stack-network` Docker network. Data under `local-volumes/` survives container removal.
- Homepage mounts the Docker socket for container-aware widgets — treat that as privileged access.
- Affine has extra startup orchestration for migrations and may take longer to become ready on first boot.
- Keep provider URLs, keys, and model names aligned across AI-enabled services when changing providers.

## Recommended First Checks

After startup:

1. `docker compose ps` — all containers healthy or running.
2. Homepage at <http://localhost:8349> loads and links to enabled services.
3. Vaultwarden at <http://localhost:8359> — verify HTTPS domain and admin token are set correctly before use.
4. Any service with a database — check logs for migration errors on first boot.
