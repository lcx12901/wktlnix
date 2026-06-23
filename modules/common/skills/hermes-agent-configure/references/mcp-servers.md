# MCP Servers and Hard-Coded Options

This file explains how MCP servers, extra packages, and environment files work in the hermes-agent wrapper — and why they are **not configurable via `settings`**.

## The Key Distinction

hermes-agent has two separate ways to configure MCP servers:

1. **`mcp_servers` in the YAML config** (`settings.mcp_servers`) — the application-level config. hermes-agent supports this.
2. **`mcpServers` on the NixOS module** (`services.hermes-agent.mcpServers`) — the NixOS-level option that the upstream module uses to generate MCP server definitions with proper Nix packaging.

**In this wrapper, MCP servers are configured via the NixOS `mcpServers` option (option 2), which is hard-coded.** The wrapper does NOT use `settings.mcp_servers`. If you add `settings.mcp_servers`, it will be serialized to the YAML config and may conflict with the NixOS-level `mcpServers` — avoid this.

## What's Hard-Coded

The wrapper sets these on the upstream `services.hermes-agent.*` module directly (lines 133–181 of `modules/nixos/services/hermes-agent/default.nix`):

### MCP Servers (lines 133–160)

```nix
mcpServers = {
  filesystem = {
    command = "npx";
    args = [ "-y" "@modelcontextprotocol/server-filesystem"
             "/var/lib/hermes/workspace" "/var/lib/hermes" ];
  };

  sequential-thinking = {
    command = "npx";
    args = [ "-y" "@modelcontextprotocol/server-sequential-thinking" ];
  };

  nixos = {
    command = "nix";
    args = [ "run" "github:utensils/mcp-nixos" "--" ];
  };
};
```

### Extra Packages (lines 162–181)

```nix
extraPackages = with pkgs; [
  bashInteractive  coreutils       curl        direnv
  fd               git             gnumake     jq
  nix              nix-direnv      nodejs      python312
  python312Packages.ptyprocess     python312Packages.fastapi
  python312Packages.uvicorn        ripgrep     tmux
  uv
];
```

### Environment Files (line 46)

```nix
environmentFiles = [ config.sops.secrets."hermes-agent-env".path ];
```

This is wired to a sops secret named `hermes-agent-env`, which the wrapper auto-creates (lines 216–221).

## How to Change These

Since these are hard-coded in the wrapper, you cannot change them via `wktlnix.services.hermes-agent.settings`. You must edit the wrapper module directly.

### Adding a new MCP server

Edit `modules/nixos/services/hermes-agent/default.nix`, find the `mcpServers` block (around line 133), and add your server:

```nix
mcpServers = {
  # ... existing servers ...

  my-new-server = {
    command = "npx";
    args = [ "-y" "@my-org/my-mcp-server" ];
    env = {
      API_KEY = "needed-here";  # but prefer sops for secrets
    };
  };
};
```

For secrets in MCP server env vars, use sops:

```nix
# In the wrapper, after adding the MCP server:
mcpServers.my-server.env.API_KEY_FILE =
  config.sops.secrets."my-mcp-api-key".path;
```

And add the sops secret:

```nix
sops.secrets."my-mcp-api-key" = {
  mode = "0400";
  owner = config.services.hermes-agent.user;
  group = config.services.hermes-agent.group;
  restartUnits = [ "hermes-agent.service" ];
};
```

### Adding a package to `extraPackages`

Edit the wrapper, find `extraPackages` (around line 162), and add:

```nix
extraPackages = with pkgs; [
  # ... existing packages ...
  python312Packages.requests  # add your package
];
```

### Changing the environment files source

The wrapper hard-codes `environmentFiles` to the sops secret `hermes-agent-env`. If you need additional env files, edit line 46:

```nix
environmentFiles = [
  config.sops.secrets."hermes-agent-env".path
  config.sops.secrets."hermes-agent-extra-env".path  # add more
];
```

## MCP Server Configuration Guidelines

### Use absolute paths

MCP servers run as the `hermes` user with `/var/lib/hermes` as the state directory. Always use absolute paths in args:

```nix
# Correct
args = [ "/var/lib/hermes/workspace" ];

# Incorrect (will fail)
args = [ "./workspace" ];
args = [ "~/workspace" ];
```

### Ensure commands are available

The command (`npx`, `nix`, etc.) must be available in the hermes-agent service's PATH. The wrapper's `extraPackages` includes `nodejs` (for `npx`) and `nix`. If your MCP server needs a different runtime, add it to `extraPackages`.

### Check upstream MCP docs

For the full MCP config reference:
- **Docs**: [MCP Config Reference](https://hermes-agent.nousresearch.com/docs/reference/mcp-config-reference)
- **Feature guide**: [MCP Integration](https://hermes-agent.nousresearch.com/docs/user-guide/features/mcp)

## See Also

- [module-defaults.md](module-defaults.md) — All hard-coded defaults including the full `extraPackages` list.
- [discovering-options.md](discovering-options.md) — How to find valid `settings.*` keys (for app-level config, not NixOS-level).
- [troubleshooting.md](troubleshooting.md) — Common issues including MCP server problems.
