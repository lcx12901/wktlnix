# Hard-Coded Defaults in the Wrapper Module

The wrapper module at `modules/nixos/services/hermes-agent/default.nix` applies `lib.recursiveUpdate { <these defaults> } cfg.settings`. This means the values listed here are the **baseline** — your `settings` only needs to specify what you want to override.

## Why You Need to Know This

1. **Don't re-specify what's already set.** If the default `agent.max_turns = 90` is fine, don't include it in your `settings`.
2. **Know what you're overriding.** If you set `settings.model = { default = "gpt-4"; }`, this replaces `model.default` but preserves `model.provider = "opencode-go"` (because `recursiveUpdate` merges attrsets deeply). If you want to change the provider too, set it explicitly.
3. **Lists are replaced, not merged.** If a default is a list (like `toolsets = [ "all" ]`) and you set `toolsets = [ "bash" ]`, the result is `[ "bash" ]`, not `[ "all" "bash" ]`.

---

## The Complete Defaults (lines 48–131 of the wrapper)

### `model`

```nix
model = {
  default = "mimo-v2.5";
  provider = "opencode-go";
};
```

### `toolsets`

```nix
toolsets = [ "all" ];
```

> This is a list — if you override it, you replace it entirely. To enable specific toolsets only, set `toolsets = [ "bash" "web" "read" ];` etc. See the [toolsets reference](https://hermes-agent.nousresearch.com/docs/reference/toolsets-reference) for available toolset names.

### `agent`

```nix
agent = {
  max_turns = 90;
  gateway_timeout = 3600;
  gateway_timeout_warning = 900;
  gateway_notify_interval = 180;
  reasoning_effort = "medium";
};
```

### `terminal`

```nix
terminal = {
  backend = "local";
  cwd = "/var/lib/hermes/workspace";  # workingDirectory in the module
  timeout = 300;
  persistent_shell = true;
};
```

> `cwd` is derived from `stateDir = "/var/lib/hermes"` → `workingDirectory = "${stateDir}/workspace"`. If you change `terminal.cwd`, make sure the directory exists and is accessible to the `hermes` user.

### `compression`

```nix
compression = {
  enabled = true;
  threshold = 0.80;
  target_ratio = 0.25;
  protect_last_n = 24;
  abort_on_summary_failure = true;
};
```

### `delegation`

```nix
delegation = {
  model = "mimo-v2.5";
  reasoning_effort = "medium";
  max_iterations = 50;
  child_timeout_seconds = 900;
  max_concurrent_children = 3;
};
```

### `display`

```nix
display = {
  compact = false;
  personality = "pragmatic";
  busy_input_mode = "steer";
  bell_on_complete = false;
  show_reasoning = false;
  streaming = false;
  timestamps = true;
  runtime_footer = {
    enabled = true;
    fields = [ "model" "context_pct" "cwd" ];
  };
};
```

### `dashboard`

```nix
dashboard.show_token_analytics = false;
```

### `memory`

```nix
memory = {
  provider = "hindsight";
  memory_enabled = true;
  user_profile_enabled = true;
  memory_char_limit = 3000;
  user_char_limit = 1800;
};
```

> The hindsight backend connection is configured separately via a hard-coded activation script that writes `config.json` to `/var/lib/hermes/.hermes/hindsight/`. The API URL (`https://hindsight.milet.lincx.top`), bank settings, and retain/recall parameters are all in the activation script — to change them, edit the wrapper module.

### `skills`

```nix
skills = {
  external_dirs = [ <shared-skills-path> ];  # derived from sharedSkills.hermes
};
```

> `external_dirs` is a list — if you override it, you replace it entirely. To keep the shared skills AND add your own, include both paths:
> ```nix
> settings.skills.external_dirs = [
>   "/var/lib/hermes/.hermes/skills"  # keep the default (verify actual path)
>   "/path/to/my/skills"
> ];
> ```
> Actually, the shared skills path is computed at eval time from `sharedSkills.hermes`. To preserve it, either don't override `external_dirs`, or check what path the wrapper computes and include it in your override.

### `tool_loop_guardrails`

```nix
tool_loop_guardrails = {
  warnings_enabled = true;
  hard_stop_enabled = true;
};
```

---

## What Is NOT in `settings` (Hard-Coded Outside `settings`)

These are set on the upstream `services.hermes-agent.*` module directly, not through `settings`. They cannot be changed via `wktlnix.services.hermes-agent.settings`:

| Option | Value | Module line |
|---|---|---|
| `services.hermes-agent.enable` | `true` | 34 |
| `services.hermes-agent.extraDependencyGroups` | `["messaging" "voice" "hindsight"]` | 36–40 |
| `services.hermes-agent.addToSystemPackages` | `true` | 42 |
| `services.hermes-agent.restart` | `"always"` | 43 |
| `services.hermes-agent.restartSec` | `5` | 44 |
| `services.hermes-agent.environmentFiles` | `[ config.sops.secrets."hermes-agent-env".path ]` | 46 |
| `services.hermes-agent.mcpServers` | filesystem, sequential-thinking, nixos | 133–160 |
| `services.hermes-agent.extraPackages` | bashInteractive, coreutils, curl, direnv, fd, git, gnumake, jq, nix, nix-direnv, nodejs, python312, ptyprocess, fastapi, uvicorn, ripgrep, tmux, uv | 162–181 |

To change any of these, edit `modules/nixos/services/hermes-agent/default.nix` directly. See [mcp-servers.md](mcp-servers.md) for guidance.

---

## Other Hard-Coded Bits in the Wrapper

| What | Where | Value |
|---|---|---|
| State directory | line 16 | `/var/lib/hermes` |
| Working directory | line 17 | `/var/lib/hermes/workspace` |
| tmpfiles rule | line 185 | `/var/lib/hermes/.hermes/pairing` (0750 hermes:hermes) |
| SOUL.md | line 189 | Installed from `documents/SOUL.md` to `/var/lib/hermes/.hermes/SOUL.md` |
| Hindsight config | lines 192–214 | JSON written to `/var/lib/hermes/.hermes/hindsight/config.json` |
| Sops secret | lines 216–221 | `hermes-agent-env` (mode 0400, owned by hermes-agent service user) |
| Persistence | lines 223–229 | `/var/lib/hermes` persisted to `/persist` |

---

## See Also

- [discovering-options.md](discovering-options.md) — How to find valid `settings.*` keys from upstream docs.
- [mcp-servers.md](mcp-servers.md) — How MCP servers and other hard-coded options work.
- [SKILL.md](../SKILL.md) — The main skill file with the configuration workflow.
