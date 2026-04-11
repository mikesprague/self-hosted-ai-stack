# Self-Hosted App Stack

Docker Compose workspace for running a personal collection of AI, knowledge, notes, and dashboard services on a shared network with persistent local storage.

The stack is split into per-app compose files under `stack/` and assembled by the root `compose.yaml` using Compose `include`. Persistent data lives under `local-volumes/`.

Several note-taking apps are included on purpose. They each have different strengths around capture, organization, collaboration, publishing, or personal knowledge management, and this stack is being used to evaluate them side by side before settling on a smaller long-term set.

Because of that, it is recommended to comment out some of the note app entries in the root `compose.yaml` and only run the ones you actually want to use or compare at a given time.

## Included Services

| Service | Purpose | Website | Documentation | Local URL |
| --- | --- | --- | --- | --- |
| **Core** | | | | |
| Open WebUI | LLM chat UI and tools hub | [openwebui.com](https://openwebui.com/) | [docs.openwebui.com](https://docs.openwebui.com/) | <http://localhost:3000> |
| SearXNG | Private metasearch engine | [searxng.org](https://searxng.org/) | [docs.searxng.org](https://docs.searxng.org/) | <http://localhost:8348> |
| Open Notebook | Notebook-style research app (API: port 5055) | [open-notebook.ai](https://www.open-notebook.ai/) | [open-notebook.ai/get-started](https://www.open-notebook.ai/get-started.html) | <http://localhost:8502> |
| Karakeep | Bookmark everything app w/ AI features | [karakeep.app](https://karakeep.app/) | [docs.karakeep.app](https://docs.karakeep.app/) | <http://localhost:7788> |
| **Notes** | | | | |
| Affine | Docs and collaborative workspace | [affine.pro](https://affine.pro/) | [docs.affine.pro](https://docs.affine.pro/) | <http://localhost:3010> |
| Blinko | Notes and capture app | [blinko.space](https://blinko.space/) | [docs.blinko.space](https://docs.blinko.space/) | <http://localhost:1111> |
| Docmost | Team docs / wiki | [docmost.com](https://docmost.com/) | [docmost.com/docs](https://docmost.com/docs) | <http://localhost:7889> |
| Flatnotes | Lightweight self-hosted markdown notes | [GitHub](https://github.com/Dullage/flatnotes) | [github.com/Dullage/flatnotes](https://github.com/Dullage/flatnotes) | <http://localhost:8352> |
| Jotty | Lightweight notes app | [GitHub](https://github.com/fccview/jotty) | [github.com/fccview/jotty/howto](https://github.com/fccview/jotty/tree/main/howto) | <http://localhost:1122> |
| Memos | Notes and journaling | [usememos.com](https://www.usememos.com/) | [usememos.com/docs](https://www.usememos.com/docs) | <http://localhost:5230> |
| Silverbullet | Markdown-based personal knowledge base | [silverbullet.md](https://silverbullet.md/) | [silverbullet.md/Manual](https://silverbullet.md/Manual) | <http://localhost:8350> |
| Trilium Notes | Hierarchical notes | [TriliumNext](https://triliumnext.github.io/Notes/) | [triliumnext.github.io/Docs](https://triliumnext.github.io/Docs/) | <http://localhost:8351> |
| **Feeds** | | | | |
| FreshRSS | RSS reader and feed aggregator | [freshrss.org](https://freshrss.org/) | [freshrss.github.io/FreshRSS](https://freshrss.github.io/FreshRSS/) | <http://localhost:8353> |
| **Productivity** | | | | |
| Super Productivity | Task and time management app with WebDAV sync | [super-productivity.com](https://super-productivity.com/) | [GitHub](https://github.com/johannesjo/super-productivity) | <http://localhost:8354> |
| **Automation / Workflow** | | | | |
| Flowise | Visual AI workflow builder | [flowiseai.com](https://flowiseai.com/) | [docs.flowiseai.com](https://docs.flowiseai.com/) | <http://localhost:8355> |
| n8n | Workflow automation platform | [n8n.io](https://n8n.io/) | [docs.n8n.io](https://docs.n8n.io/) | <http://localhost:5678> |
| **Monitoring** | | | | |
| Dozzle | Real-time Docker container log viewer | [dozzle.dev](https://dozzle.dev/) | [dozzle.dev/guide/getting-started](https://dozzle.dev/guide/getting-started) | <http://localhost:8357> |
| Uptime Kuma | Uptime and status monitoring | [GitHub](https://github.com/louislam/uptime-kuma) | [uptimekuma.org](https://uptimekuma.org/) | <http://localhost:8356> |
| **Management** | | | | |
| Portainer | Docker environment management UI | [portainer.io](https://www.portainer.io/) | [docs.portainer.io](https://docs.portainer.io/) | <http://localhost:8358> |
| **Dashboard** | | | | |
| Homepage | Dashboard for the stack | [gethomepage.dev](https://gethomepage.dev/) | [gethomepage.dev/configs](https://gethomepage.dev/configs/) | <http://localhost:8349> |

## Prerequisites

### Required

- [Docker Desktop](https://www.docker.com/products/docker-desktop/) with modern Docker Compose support. [OrbStack](https://orbstack.dev/) is a solid alternative on macOS, and parts of this repo are already tuned for it.
- [Ollama](https://ollama.com/) for local model access used by the preconfigured Open WebUI setup. It is free.
- Recommended Ollama starting points are `gemma4` for general/text generation and `embeddinggemma` for embeddings. Those are a good default fit for this stack, but it is encouraged to try other models as well.
- Enough disk space for databases, indexes, uploads, and other persistent data under `local-volumes/`.

### Optional

- [Context7](https://context7.com/) API key for the preconfigured Context7 MCP integration in Open WebUI. It is free to sign up for.
- [Jina AI](https://jina.ai/) API key for features that use Jina services. It is free to sign up for.
- [LM Studio](https://lmstudio.ai/) as an optional free local model runner if you want to use it alongside Ollama for some workflows. It is free.
- [Azure Foundry](https://ai.azure.com/) as a cloud inference provider for Karakeep, Docmost, and Open WebUI. Required only if you prefer cloud-hosted models over local ones.

## Quick Start

1. Clone the repository.
2. Copy the example environment file.
3. Fill in the required secrets and credentials. For any field marked `openssl rand -hex 32`, run that command in your terminal to generate a secure value.
4. Comment out any services you do not want to run in the root `compose.yaml` include list, especially note apps you are not currently evaluating.
5. Start the stack with Docker Compose.

```sh
git clone https://github.com/mikesprague/self-hosted-ai-stack.git
cd self-hosted-ai-stack
cp .env.example .env
docker compose pull
docker compose up -d
```

To stop everything:

```sh
docker compose down
```

## Configuration

The root compose file loads environment variables from `.env` and includes the per-service definitions from `stack/`.

Start with `.env.example`. At minimum, review these groups before bringing the stack up:

- `SEARXNG_SECRET_KEY`
- `OPEN_WEBUI_*`
- `OPEN_NOTEBOOK_ENCRYPTION_KEY`
- `KARAKEEP_*`
- `AFFINE_*`
- `DOCMOST_*`
- `BLINKO_*`
- `FLATNOTES_*`
- `MEMOS_*`
- `SILVERBULLET_*`
- `FRESHRSS_*`
- `SP_WEBDAV_*`
- `FLOWISE_*`
- `N8N_*`
- `PORTAINER_*`
- `TZ` — set to your local timezone (e.g. `America/New_York`)
- Shared provider settings such as `AZURE_*`, `OLLAMA_*`, `CONTEXT7_API_KEY`, `JINA_API_KEY`, and `UNSPLASH_*`

If you are not using a given provider, you can usually leave its optional settings unset, but apps that are configured to depend on that provider still need valid values. Karakeep and Docmost are the main places to check if you switch between Azure Foundry and Ollama-backed models.

Services without required entries in `.env.example` right now include Dozzle, Jotty, Trilium Notes, and Uptime Kuma.

### Homepage Configuration

The Homepage config lives under [local-volumes/homepage/config](local-volumes/homepage/config). The included [local-volumes/homepage/config/settings.yaml](local-volumes/homepage/config/settings.yaml) and [local-volumes/homepage/config/custom.css](local-volumes/homepage/config/custom.css) are meant to be tweaked as desired for your preferred look and behavior.

If you want to start from the bundled examples for service and widget definitions, use [local-volumes/homepage/config/services.example.yaml](local-volumes/homepage/config/services.example.yaml) and [local-volumes/homepage/config/widgets.example.yaml](local-volumes/homepage/config/widgets.example.yaml) as templates, then rename them by removing `.example` so they become `services.yaml` and `widgets.yaml`, and edit them as needed.

## Preconfigured Integrations

Some parts of the stack are wired together on purpose so the default experience is useful without much extra setup.

- SearXNG can be used as a standalone private metasearch service at <http://localhost:8348>.
- Open WebUI is preconfigured to use the local SearXNG instance for web search, so web-enabled LLM workflows can search through that service by default.
- Open WebUI is preconfigured for local models through Ollama, using the shared `OLLAMA_API_URL` and `OLLAMA_API_KEY` settings.
- Open WebUI is also preconfigured with the Context7 MCP server, so it can pull current library and framework documentation when `CONTEXT7_API_KEY` is set.

### Manual Setup Notes

- Open Notebook currently does not have an equivalent preconfiguration path in this stack, so its provider and application-level setup still need to be completed manually after startup.
- The Open Notebook compose file currently includes OrbStack-specific settings in [stack/open-notebook/compose.yaml](stack/open-notebook/compose.yaml).

> [!IMPORTANT]
> If you are running standard Docker/Docker Desktop (rather than OrbStack), explicitly comment out the OrbStack label and related URL settings before starting that service.

## Service Layout

```text
.
├── compose.yaml              # root stack definition
├── .env                      # local secrets and config
├── .env.example              # safe template for config
├── stack/                    # per-app compose files
└── local-volumes/            # persistent data for apps and databases
```

Each application has its own compose file in `stack/<service>/compose.yaml`. Most services also have a matching folder under `local-volumes/` for database files, uploads, indexes, and app state.

## Operating The Stack

Useful commands:

```sh
docker compose ps
docker compose logs -f
docker compose logs -f open-webui
docker compose restart
docker compose pull && docker compose up -d
```

If you only want a subset of apps, the simplest approach in this repo is to comment out the corresponding entries in the root `compose.yaml` include list and then run `docker compose up -d` again. This is especially useful for the note-taking apps, since they overlap in purpose and are intended to be enabled selectively during evaluation.

## Notes And Caveats

- All services share the `self-hosted-ai-stack-network` Docker network.
- Data is persisted locally under `local-volumes/`, so deleting containers does not remove application data by itself.
- Homepage mounts the Docker socket to display container-aware widgets. Treat that as privileged access.
- Affine has extra startup orchestration for migrations and may take longer to become ready on first boot.
- The current configuration uses a mix of AI backends. Keep provider URLs, keys, and model names aligned with the apps that consume them.

## Recommended First Checks

After startup, verify these in order:

1. `docker compose ps` shows containers healthy or running.
2. Homepage loads at <http://localhost:8349> and links to the services you enabled.
3. Open WebUI at <http://localhost:3000> can reach your selected model provider.
4. SearXNG responds at <http://localhost:8348>.
5. Apps with their own databases finish startup without migration errors.
