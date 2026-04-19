<!-- markdownlint-disable MD060 -->

# Environment Variable Conventions

All environment variables are defined in a single `.env` file at the workspace root. That file is loaded by the root `compose.yaml` `include:` block and made available to all app compose files via interpolation.

## File Structure

The `.env` file is organized into sections using a consistent delimiter pattern:

```bash
### APP NAME ###
APP_VAR_ONE="value"
APP_VAR_TWO="value"
### END APP NAME ###
```

- Section headers use all-caps display names.
- Variable names use upper snake case.
- String values are usually quoted.
- Numeric and boolean values may be left unquoted when that matches existing stack usage.
- Comments within a section use `#`.
- Related vars within a section may be grouped with comment headers.

## Variable Naming Convention

All variables are prefixed with the app's namespace in screaming snake case:

```text
APP_NAME_VAR_DESCRIPTION
```

### Standard Variable Patterns

| Purpose | Variable Name Pattern | Example |
|---------|----------------------|---------|
| Published port | `APP_PORT` | `OPEN_WEBUI_PORT=3000` |
| Secondary/admin/API port | `APP_ADMIN_PORT`, `APP_API_PORT` | `HOPPSCOTCH_ADMIN_PORT=3100` |
| Secret/signing key | `APP_SECRET_KEY` | `OPEN_WEBUI_SECRET_KEY="..."` |
| Postgres DB name | `APP_POSTGRES_DB` | `MEMOS_POSTGRES_DB="memos"` |
| Postgres username | `APP_POSTGRES_USER` | `MEMOS_POSTGRES_USER="memos"` |
| Postgres password | `APP_POSTGRES_PASSWORD` | `MEMOS_POSTGRES_PASSWORD="..."` |
| Admin email | `APP_ADMIN_EMAIL` | `OPEN_WEBUI_ADMIN_EMAIL="..."` |
| Admin password | `APP_ADMIN_PASSWORD` | `OPEN_WEBUI_ADMIN_PASSWORD="..."` |
| Admin username | `APP_ADMIN_USERNAME` | `YAADE_ADMIN_USERNAME="admin"` |
| Encryption key | `APP_ENCRYPTION_KEY` | `OPEN_NOTEBOOK_ENCRYPTION_KEY="..."` |
| Meilisearch master key | `APP_MEILI_MASTER_KEY` | `KARAKEEP_MEILI_MASTER_KEY="..."` |
| NextAuth secret | `APP_NEXTAUTH_SECRET` | `KARAKEEP_NEXTAUTH_SECRET="..."` |

Postgres vars define per-app credentials on the shared `postgres-shared` instance. The hostname in compose is always `postgres-shared`, never an app-specific database container.

## Shared / Cross-App Variables

These variables live in the `### SHARED ###` section or other shared infrastructure sections:

| Variable | Purpose |
|----------|---------|
| `TZ` | Timezone |
| `TAILNET_IP_ADDRESS` | Tailnet IP used by apps that need absolute callback URLs |
| `TAILNET_DOMAIN` | Tailnet domain used by apps like n8n |
| `OLLAMA_BASE_URL` | Ollama API URL |
| `OLLAMA_API_KEY` | Ollama API key if enabled |
| `LM_STUDIO_OPENAI_API_URL` | LM Studio OpenAI-compatible URL |
| `AZURE_FOUNDRY_API_KEY` | Azure Foundry API key used by some apps |
| `AZURE_OPENAI_API_KEY` | Azure OpenAI-compatible key used by some apps |
| `AZURE_FOUNDRY_BASE_URL` | Azure Foundry base URL |
| `AZURE_FOUNDRY_OPENAI_BASE_URL` | Azure OpenAI-compatible URL |
| `AZURE_OPENAI_API_VERSION` | Azure API version |
| `CONTEXT7_API_KEY` | Context7 MCP API key |
| `JINA_API_KEY` | Jina AI API key |
| `UNSPLASH_ACCESS_KEY` | Unsplash access key |
| `UNSPLASH_SECRET_KEY` | Unsplash secret key |

Infrastructure-specific shared vars also exist outside `### SHARED ###`, for example:

| Variable | Purpose |
|----------|---------|
| `POSTGRES_SHARED_HOST` | Shared Postgres hostname |
| `POSTGRES_SHARED_PORT` | Shared Postgres published port |
| `POSTGRES_SHARED_SUPERUSER` | Shared Postgres admin user |
| `POSTGRES_SHARED_SUPERUSER_PASSWORD` | Shared Postgres admin password |
| `POSTGRES_SHARED_DEFAULT_DB` | Shared Postgres bootstrap DB |
| `MAILPIT_PORT` | Mailpit web UI port |
| `MAILPIT_SMTP_PORT` | Mailpit SMTP port |
| `DBGATE_PORT` | DBGate published port |

## Adding Variables for a New App

1. Open `.env`.
2. Add a new section before the shared sections unless there is a better existing grouping.
3. Follow the same section/comment style already used by nearby apps.

Example:

```bash
### NEW APP ###
NEWAPP_PORT=8372
NEWAPP_SECRET_KEY="<generated-random-hex>"

# PostgreSQL (credentials on shared postgres-shared instance)
NEWAPP_POSTGRES_DB="newapp"
NEWAPP_POSTGRES_USER="newapp"
NEWAPP_POSTGRES_PASSWORD="<strong-password>"
### END NEW APP ###
```

Reference these vars in compose with `${NEWAPP_PORT}`, `${NEWAPP_SECRET_KEY}`, etc.

For Postgres apps, use a connection string like:

```text
postgresql://${NEWAPP_POSTGRES_USER}:${NEWAPP_POSTGRES_PASSWORD}@postgres-shared:5432/${NEWAPP_POSTGRES_DB}
```

Before starting the app, create the role and database in `postgres-shared`:

```sql
CREATE ROLE newapp WITH LOGIN PASSWORD 'replace-with-your-password';
CREATE DATABASE newapp OWNER newapp;
```

Add `CREATE EXTENSION IF NOT EXISTS vector;` only if the specific app needs `pgvector`.

## Secret Generation

Generate secrets using:

```bash
# 32-byte hex secret
openssl rand -hex 32

# 32-byte base64 secret
openssl rand -base64 32
```

## Variable Syntax in Compose Files

| Syntax | Meaning |
|--------|---------|
| `${VAR}` | Required, no default |
| `${VAR:-default}` | Optional with default fallback |
| `${VAR:?missing}` | Required and fails fast if unset |

Use `${VAR:?missing}` for secrets and required auth credentials.
Use `${VAR:-default}` for ports and optional toggles.

## Example: Complete App Section

```bash
### FRESHRSS ###
FRESHRSS_PUBLISHED_PORT=8353
FRESHRSS_ADMIN_EMAIL="user@example.com"
FRESHRSS_ADMIN_PASSWORD="<password>"
FRESHRSS_ADMIN_API_PASSWORD="<password>"
FRESHRSS_POSTGRES_DB="freshrss"
FRESHRSS_POSTGRES_USER="freshrss"
FRESHRSS_POSTGRES_PASSWORD="<password>"
### END FRESHRSS ###
```
