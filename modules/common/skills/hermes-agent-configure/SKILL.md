---
name: hermes-agent-configure
description: 配置 hermes-agent NixOS 模块设置。必须使用此技能当用户询问：修改 hermes-agent 模型、设置 MCP 服务器、调整对话限制、修改终端设置、启用/禁用功能、排查 hermes-agent 问题、查找可用配置选项时。触发短语："hermes-agent 配置"、"hermes 设置"、"配置 hermes"、"修改 hermes 模型"、"添加 MCP 服务器"、"hermes 超时"、"hermes 对话轮数"、"hermes 推理"。当用户提及 hermes-agent 配置文件、NixOS 模块选项或 hermes 服务设置时也应使用。此技能涵盖 hermes-agent 的所有配置方面，包括模型选择、MCP 服务器、对话管理、终端设置、压缩、委派、显示、记忆、技能、工具循环防护等。当用户想要修改、添加、删除或查询 hermes-agent 的任何配置时，都必须使用此技能。
---

# Hermes Agent Configuration Skill

This skill helps you configure the `wktlnix.services.hermes-agent` NixOS module correctly.

The module is a thin wrapper at `modules/nixos/services/hermes-agent/default.nix` around the upstream `services.hermes-agent` module (from flake input `github:NousResearch/hermes-agent`).

## The Core Mental Model — Read This First

Before configuring anything, understand these five facts. They determine everything about how you should approach the task:

### 1. The user-facing API is only `enable` and `settings`

The wrapper module exposes exactly two options:

```nix
wktlnix.services.hermes-agent = {
  enable = true;        # bool — whether to enable the service
  settings = { ... };   # attrs — hermes-agent YAML config
};
```

That's it. Everything else (`mcpServers`, `extraPackages`, `environmentFiles`, `restart`, etc.) is **hard-coded inside the wrapper** and is NOT user-configurable through `wktlnix.services.hermes-agent.*`. See [What You CANNOT Configure](#what-you-cannot-configure-via-settings) below.

### 2. `settings` is an open attrset with no NixOS-level schema

```nix
settings = mkOpt lib.types.attrs { } "Hermes YAML config settings.";
```

`lib.types.attrs` is `lazyAttrsOf unspecified` — it accepts any attribute set, at any nesting depth, with any value types. The NixOS module does **zero validation** on what keys you put in `settings`. This is functionally equivalent to the upstream `deepConfigType` (open attrset, no schema).

**Consequence**: You cannot discover valid `settings.*` keys by reading the NixOS module. The valid keys, their types, and their defaults are defined by the **hermes-agent application itself** — documented in its official docs and example config. See [Discovering Valid Options](#discovering-valid-settings-keys).

### 3. `settings` is deep-merged over hard-coded defaults

The wrapper does:

```nix
settings = lib.recursiveUpdate { <hard-coded defaults> } cfg.settings;
```

This means the user's `settings` is a **delta** — you only specify what you want to override. Everything in the hard-coded defaults that you don't touch is preserved. See [references/module-defaults.md](references/module-defaults.md) for the full list of defaults baked into the wrapper.

### 4. `settings` becomes `~/.hermes/config.yaml`

The upstream NixOS module serializes the `settings` attrset to YAML and writes it to `~/.hermes/config.yaml` (the hermes-agent application's config file). So `settings` is literally a Nix representation of the YAML config.

- **Secrets** (API keys, bot tokens) do NOT go in `settings` — they go in `~/.hermes/.env`, managed via `environmentFiles` (which is hard-coded to `config.sops.secrets."hermes-agent-env".path` in this wrapper).
- **Env-var substitution** in the YAML: hermes-agent supports `${VAR_NAME}` syntax inside config values.

### 5. Config precedence (hermes-agent app side)

When hermes-agent runs, it resolves config values in this order:

1. **CLI arguments** (per-invocation, e.g. `hermes chat --model anthropic/claude-sonnet-4`)
2. **`~/.hermes/config.yaml`** (what `settings` becomes)
3. **`~/.hermes/.env`** (env vars — also override YAML for the same logical setting)
4. **Built-in defaults** (in the application code)

---

## The Configuration Workflow

When a user asks to configure hermes-agent, follow this workflow:

### Step 1 — Identify what section the user wants to change

Common sections: `model`, `agent`, `terminal`, `compression`, `delegation`, `display`, `memory`, `skills`, `tool_loop_guardrails`. There are 30+ sections total — see [Discovering Valid Options](#discovering-valid-settings-keys) for how to find them all.

### Step 2 — Look up the valid keys from upstream docs

**Do NOT guess key names.** Since `settings` has no schema, a misspelled key will be silently ignored by hermes-agent (it only warns on unknown root-level keys, and does nothing for unknown nested keys). Always verify the key name, type, and allowed values against the authoritative source.

→ Read [references/discovering-options.md](references/discovering-options.md) for the exact URLs and workflow.

### Step 3 — Check the hard-coded defaults

Before writing your override, check [references/module-defaults.md](references/module-defaults.md) to see what the wrapper already sets. You only need to specify the delta. For example, if the user wants to change only the model name, you don't need to re-specify the entire `model` section — just override `model.default`.

### Step 4 — Write the Nix config

```nix
wktlnix.services.hermes-agent = {
  enable = true;
  settings = {
    # Only the keys you want to override
    model.default = "claude-sonnet-4-20250514";
    model.provider = "anthropic";
  };
};
```

### Step 5 — Verify

- `nixos-rebuild build` — check for eval errors (though `settings` won't error since it's untyped)
- `systemctl restart hermes-agent` after applying
- `journalctl -u hermes-agent -f` — check for hermes-agent's own config warnings about unknown keys

---

## Discovering Valid `settings` Keys

The authoritative sources for what keys `settings` accepts, in priority order:

1. **`cli-config.yaml.example`** (1260 lines) — the most complete single-file reference, every section with inline comments on type, default, and allowed values.
   - URL: `https://github.com/NousResearch/hermes-agent/blob/main/cli-config.yaml.example`
   - Raw: `https://raw.githubusercontent.com/NousResearch/hermes-agent/main/cli-config.yaml.example`

2. **Official docs site** — `https://hermes-agent.nousresearch.com/docs/`
   - **LLM-optimized dump**: `/llms.txt` (~17KB index) and `/llms-full.txt` (~1.8MB, all pages concatenated). These are explicitly designed for LLM/agent ingestion — prefer them over scraping individual pages.
   - Configuration page: `/docs/user-guide/configuration`
   - Per-section pages: see [references/discovering-options.md](references/discovering-options.md) for the full URL table.

3. **`hermes_cli/config.py`** (7155 lines) — the config loader/validator code. Last resort when a key is undocumented elsewhere. Contains `_KNOWN_ROOT_KEYS` set (line ~4415) listing all recognized root-level sections.

→ For the full discovery workflow and per-section URL table, read [references/discovering-options.md](references/discovering-options.md).

---

## What You CANNOT Configure via `settings`

These are hard-coded inside the wrapper module (`modules/nixos/services/hermes-agent/default.nix`) and are **not exposed** as `wktlnix.services.hermes-agent.*` options:

| What | Hard-coded value | How to change |
|---|---|---|
| `mcpServers` | filesystem, sequential-thinking, nixos | Edit the wrapper module |
| `extraPackages` | bashInteractive, coreutils, curl, git, nix, nodejs, python312, ripgrep, etc. | Edit the wrapper module |
| `environmentFiles` | `config.sops.secrets."hermes-agent-env".path` | Edit the wrapper module |
| `extraDependencyGroups` | `["messaging" "voice" "hindsight"]` | Edit the wrapper module |
| `addToSystemPackages` | `true` | Edit the wrapper module |
| `restart` / `restartSec` | `"always"` / `5` | Edit the wrapper module |
| `sops.secrets."hermes-agent-env"` | auto-created | Edit the wrapper module |
| State directory | `/var/lib/hermes` | Edit the wrapper module |
| Hindsight config | auto-generated `config.json` | Edit the wrapper module |
| SOUL.md | installed via activation script | Edit the wrapper module |

If the user wants to change any of these, you must edit `modules/nixos/services/hermes-agent/default.nix` directly — there is no `settings` key for them. See [references/mcp-servers.md](references/mcp-servers.md) for guidance on editing the wrapper.

> **Note**: hermes-agent does have an `mcp_servers` key in its YAML config (separate from the NixOS module's `mcpServers`). But in this wrapper, MCP servers are configured via the NixOS module's `mcpServers` option (which is hard-coded), NOT via `settings.mcp_servers`. Do not confuse the two.

---

## Common Configuration Tasks

These are quick examples. Always verify key names against upstream docs before writing.

### Change the default model

```nix
wktlnix.services.hermes-agent.settings.model = {
  default = "claude-sonnet-4-20250514";
  provider = "anthropic";
};
```

Requires `ANTHROPIC_API_KEY` in the sops secret `hermes-agent-env`.

### Adjust conversation limits

```nix
wktlnix.services.hermes-agent.settings.agent = {
  max_turns = 150;           # default 90
  reasoning_effort = "high"; # "low" | "medium" | "high"
};
```

### Enable streaming

```nix
wktlnix.services.hermes-agent.settings.display.streaming = true;
```

### Adjust compression

```nix
wktlnix.services.hermes-agent.settings.compression = {
  threshold = 0.90;  # compress at 90% context (default 0.80)
  target_ratio = 0.20;
};
```

### Add external skill directories

```nix
wktlnix.services.hermes-agent.settings.skills.external_dirs = [
  "/path/to/my/skills"
];
```

> The wrapper already adds the shared skills directory. Your `external_dirs` is merged via `recursiveUpdate`, so it **replaces** the list (Nix lists don't deep-merge — they override). If you want to keep the default AND add your own, include both paths.

### Configure memory/hindsight

```nix
wktlnix.services.hermes-agent.settings.memory = {
  memory_enabled = true;
  memory_char_limit = 5000;  # default 3000
};
```

> The hindsight backend connection is hard-coded in the wrapper (activation script writes `config.json` to `/var/lib/hermes/.hermes/hindsight/`). To change the hindsight API URL or bank settings, edit the wrapper module.

---

## Gotchas

1. **Lists don't deep-merge.** `lib.recursiveUpdate` merges attrsets recursively, but lists are replaced entirely. If the default is `toolsets = [ "all" ]` and you set `toolsets = [ "bash" "web" ]`, the result is `[ "bash" "web" ]`, not `[ "all" "bash" "web" ]`.

2. **Misspelled keys are silently ignored.** hermes-agent warns on unknown root-level keys but does nothing for unknown nested keys. Always verify against upstream docs.

3. **Env vars override YAML.** If a setting is defined both in `config.yaml` (via `settings`) and in `.env` (via `environmentFiles`), the env var wins. Don't duplicate secrets in `settings`.

4. **`settings` is serialized to YAML.** Nix booleans become YAML booleans, Nix strings become YAML strings, etc. Nix `null` becomes YAML `null`. Nix lists become YAML lists.

---

## Reference Files

- [references/discovering-options.md](references/discovering-options.md) — How to find valid `settings.*` keys: authoritative sources, URL table for every config section, discovery workflow.
- [references/module-defaults.md](references/module-defaults.md) — The complete hard-coded defaults baked into the wrapper module (the baseline your `settings` overrides).
- [references/model-options.md](references/model-options.md) — Quick reference for `settings.model` with examples and upstream doc pointer.
- [references/agent-options.md](references/agent-options.md) — Quick reference for `settings.agent` with examples and upstream doc pointer.
- [references/mcp-servers.md](references/mcp-servers.md) — How MCP servers work in this wrapper (hard-coded), and how to edit the module if you need to change them.
- [references/troubleshooting.md](references/troubleshooting.md) — Common issues and debugging commands.
