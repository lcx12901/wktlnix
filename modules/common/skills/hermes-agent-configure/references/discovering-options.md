# Discovering Valid `settings.*` Options

The NixOS module's `settings` option is an open attrset (`lib.types.attrs`) with no schema validation. This means **the NixOS module cannot tell you what keys are valid** — the valid keys, types, and defaults are defined by the hermes-agent application itself.

This file teaches you how to find the authoritative documentation for any `settings.*` key.

## Why This Matters

If you put a misspelled or non-existent key in `settings`, the NixOS evaluation will succeed (no type error), and `nixos-rebuild` will complete — but hermes-agent will silently ignore the invalid key at runtime. The app only warns on unknown **root-level** keys; unknown nested keys produce no warning at all. This makes typos very hard to debug.

**Always verify key names against the authoritative source before writing config.**

---

## Authoritative Sources (Priority Order)

### 1. `cli-config.yaml.example` — the most complete single reference

This is a 1260-line example config file in the repo root, with every section fully written out and inline comments documenting type, default, and allowed values for each key.

- **Browse**: `https://github.com/NousResearch/hermes-agent/blob/main/cli-config.yaml.example`
- **Raw text** (best for fetching): `https://raw.githubusercontent.com/NousResearch/hermes-agent/main/cli-config.yaml.example`

**When to use**: When you need to see the full structure of a section with all keys and their defaults at a glance. This is usually the fastest way to verify a key name and its expected type.

### 2. Official docs site — `https://hermes-agent.nousresearch.com/docs/`

The docs site has per-section pages with explanations, examples, and edge cases.

**LLM-optimized endpoints** (prefer these over scraping individual pages — they are explicitly designed for agent ingestion):

- **`/llms.txt`** (~17KB): `https://hermes-agent.nousresearch.com/docs/llms.txt` — a curated index of all doc pages with short descriptions. Use this first to find which page covers your topic.
- **`/llms-full.txt`** (~1.8MB): `https://hermes-agent.nousresearch.com/docs/llms-full.txt` — all doc pages concatenated into one file. Use this when you need deep coverage of multiple sections and have context budget for it.

**Key pages**:

| Page | URL |
|---|---|
| Configuration overview | `/docs/user-guide/configuration` |
| Configuring models | `/docs/user-guide/configuring-models` |
| Environment variables | `/docs/reference/environment-variables` |
| MCP config reference | `/docs/reference/mcp-config-reference` |
| Toolsets reference | `/docs/reference/toolsets-reference` |
| CLI commands | `/docs/reference/cli-commands` |
| Memory | `/docs/user-guide/features/memory` |
| Delegation | `/docs/user-guide/features/delegation` |
| Skills | `/docs/user-guide/features/skills` |
| Fallback providers | `/docs/user-guide/features/fallback-providers` |
| Credential pools | `/docs/user-guide/features/credential-pools` |
| Context compression | `/docs/developer-guide/context-compression-and-caching` |
| Context files | `/docs/user-guide/features/context-files` |
| Session storage | `/docs/developer-guide/session-storage` |
| Tools | `/docs/user-guide/features/tools` |
| MCP | `/docs/user-guide/features/mcp` |

### 3. `hermes_cli/config.py` — the config loader/validator (last resort)

7155 lines of Python. Contains:

- **`_KNOWN_ROOT_KEYS`** set (around line 4415) — the canonical list of recognized root-level config sections.
- **`validate_config_structure()`** (around line 4445) — partial validation logic; shows what the app checks for.
- Default value constants scattered throughout.

- **Browse**: `https://github.com/NousResearch/hermes-agent/blob/main/hermes_cli/config.py`

**When to use**: When a key is not in the example file and not documented on the docs site, but you suspect it exists from reading code or issue trackers.

---

## The `_KNOWN_ROOT_KEYS` Set

This is the validator's authoritative list of recognized root-level config sections (from `hermes_cli/config.py`):

```python
_KNOWN_ROOT_KEYS = {
    "_config_version", "model", "providers", "fallback_model",
    "fallback_providers", "credential_pool_strategies", "toolsets",
    "agent", "terminal", "display", "compression", "delegation",
    "auxiliary", "custom_providers", "context", "memory", "gateway",
    "sessions", "streaming", "updates", "mcp_servers",
}
```

> **Note**: The example file contains additional root-level keys not in this set (e.g. `browser`, `tool_loop_guardrails`, `stt`, `code_execution`, `session_reset`, `max_concurrent_sessions`, `group_sessions_per_user`, `security`, `privacy`, `hooks`, `dashboard`, `provider_routing`, `openrouter`, `prompt_caching`, `worktree`, `skills`, `platform_toolsets`, per-platform sections like `discord`, `telegram`, `slack`). The validator only *warns* on unknown root keys — it does not error. These keys are safe to use; the validator's list is incomplete.

---

## Per-Section Documentation Table

For each common `settings.*` section, where to find the authoritative documentation:

| Section | Example file lines | Docs page | What it controls |
|---|---|---|---|
| `model` | 8–87 | `/docs/user-guide/configuring-models` | `provider`, `default`, `base_url`, `api_key`, `context_length`, `max_tokens`, `default_headers`, `auth_mode`, `entra.*` |
| `providers` | 89–120 | — (example only) | Per-provider: `request_timeout_seconds`, `stale_timeout_seconds`, per-model timeouts |
| `provider_routing` | 122–146 | — (example only) | OpenRouter routing: `sort`, `only`, `ignore`, `order`, `data_collection` |
| `openrouter` | 148–158 | — (example only) | OpenRouter: `response_cache`, `response_cache_ttl` |
| `fallback_model` | — | `/docs/user-guide/features/fallback-providers` | Single dict or list of dicts (chain): `provider`, `model` |
| `fallback_providers` | — | `/docs/user-guide/features/fallback-providers` | Chain of fallback providers |
| `credential_pool_strategies` | — | `/docs/user-guide/features/credential-pools` | Credential pool selection strategies |
| `custom_providers` | — | — (example only) | List of custom OpenAI-compatible endpoints: `name`, `base_url`, `api_key`, `api_mode`, `model`, `models`, `context_length`, `rate_limit_delay`, `extra_body`, `key_env` |
| `toolsets` | — | `/docs/user-guide/features/tools` + `/docs/reference/toolsets-reference` | Which toolsets enabled/disabled |
| `agent` | 609–720 | — (example only) | `max_turns`, `gateway_timeout`, `gateway_timeout_warning`, `gateway_drain_timeout`, `reasoning_effort` |
| `terminal` | 180–326 | `/docs/user-guide/configuration#terminal-backend-configuration` | `backend` (local\|docker\|ssh\|modal\|daytona\|singularity), `cwd`, `timeout`, `home_mode`, `persistent_shell`, `lifetime_seconds`, per-backend config |
| `browser` | 341–347 | — (example only) | `inactivity_timeout` |
| `tool_loop_guardrails` | 349–366 | — (example only) | `warnings_enabled`, `hard_stop_enabled`, `warn_after.*`, `hard_stop_after.*` |
| `compression` | 368–430 | `/docs/developer-guide/context-compression-and-caching` | `enabled`, `threshold`, `target_ratio`, `protect_last_n`, `abort_on_summary_failure` |
| `prompt_caching` | 428–510 | `/docs/developer-guide/context-compression-and-caching` | Anthropic prompt caching settings |
| `delegation` | 942–976 | `/docs/user-guide/features/delegation` | `model`, `reasoning_effort`, `max_iterations`, `child_timeout_seconds`, `max_concurrent_children` |
| `auxiliary` | 432–502 | — (example only) | Per-task models: `vision`, `web_extract`, `tts_audio_tags`, `session_search` — each with `provider`, `model`, `timeout` |
| `memory` | 504–530 | `/docs/user-guide/features/memory` | `provider`, `memory_enabled`, `user_profile_enabled`, `memory_char_limit`, `user_char_limit`, `write_approval`, `nudge_interval`, `flush_min_turns` |
| `session_reset` | 532–557 | — (example only) | `mode` (both\|idle\|daily\|none), `idle_minutes`, `at_hour` |
| `max_concurrent_sessions` | 566 | — (example only) | Top-level cap on concurrent sessions |
| `group_sessions_per_user` | 572 | — (example only) | Per-user session isolation in shared channels |
| `streaming` | 575–585 | — (example only) | `enabled`, `transport`, `edit_interval`, `buffer_threshold`, `cursor` |
| `skills` | 588–607 | `/docs/user-guide/features/skills` | `creation_nudge_interval`, `external_dirs`, `config.<skill_name>.*`, `guard_agent_created`, `write_approval` |
| `platform_toolsets` | 715–892 | — (example only) | Per-platform toolset overrides |
| `stt` | 893–932 | — (example only) | Speech-to-text config |
| `code_execution` | 933–941 | — (example only) | Code execution settings |
| `display` | 977–1200 | — (example only) | `compact`, `personality`, `busy_input_mode`, `bell_on_complete`, `show_reasoning`, `streaming`, `timestamps`, `runtime_footer.*`, `tool_progress`, `tool_progress_command` |
| `updates` | 1198–1217 | — (example only) | `pre_update_backup`, `backup_keep`, `non_interactive_local_changes` |
| `mcp_servers` | — | `/docs/user-guide/features/mcp` + `/docs/reference/mcp-config-reference` | MCP server definitions (but in this wrapper, MCP is configured via the NixOS `mcpServers` option, not `settings.mcp_servers`) |
| `gateway` | — | `/docs/user-guide/messaging/` | Global gateway + per-platform settings |
| `context` | — | `/docs/user-guide/features/context-files` | Context file truncation rules |
| `sessions` | — | `/docs/developer-guide/session-storage` | Session storage settings |
| `worktree` / `worktree_sync` | 160–178 | — (example only) | Git worktree isolation |
| `security` | 327–339 | — (example only) | Tirith pre-exec command scanning |
| `privacy` | 1151–1160 | — (example only) | `redact_pii` |
| `hooks` / `hooks_auto_accept` | 1162–1196 | — (example only) | Shell-script plugin hooks |
| `dashboard` | 1219–1259 | — (example only) | Web dashboard OAuth config: `show_token_analytics` |
| `telegram` | — | `/docs/user-guide/messaging/telegram` | Telegram bot settings |
| `slack` | — | `/docs/user-guide/messaging/slack` | Slack Socket Mode settings |

> Other messaging platforms (whatsapp, signal, email, sms, matrix, mattermost, homeassistant, dingtalk, feishu, wecom, google_chat, teams, etc.) — see the [messaging platform index](https://hermes-agent.nousresearch.com/docs/user-guide/messaging/).

---

## Discovery Workflow

When a user asks to configure something and you're not sure what key to use:

### Step 1 — Fetch the example file

```
webfetch https://raw.githubusercontent.com/NousResearch/hermes-agent/main/cli-config.yaml.example
```

Search it for the section name (e.g. `compression:`, `agent:`) and read the inline comments. This is usually sufficient for verifying key names and types.

### Step 2 — If you need more context, fetch the relevant docs page

Use the per-section table above to find the right URL. Or fetch `/llms.txt` first to find which page covers the topic:

```
webfetch https://hermes-agent.nousresearch.com/docs/llms.txt
```

Then fetch the specific page for detailed explanations and edge cases.

### Step 3 — If still unclear, check the config code

```
webfetch https://github.com/NousResearch/hermes-agent/blob/main/hermes_cli/config.py
```

Search for the section name or key to see how it's loaded and validated.

### Step 4 — If the key truly doesn't exist

The user may be asking for a feature hermes-agent doesn't support. Check:

- The [GitHub issues](https://github.com/NousResearch/hermes-agent/issues) for feature requests
- The [changelog](https://github.com/NousResearch/hermes-agent/releases) for newer versions

---

## See Also

- [module-defaults.md](module-defaults.md) — The hard-coded defaults in the wrapper that your `settings` overrides.
- [model-options.md](model-options.md) — Quick reference for `settings.model`.
- [agent-options.md](agent-options.md) — Quick reference for `settings.agent`.
