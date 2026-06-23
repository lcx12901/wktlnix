# Troubleshooting Guide

## Common Issues

### Configuration Not Taking Effect

**Symptoms**: Changes to `settings` don't appear to work at runtime.

**Solutions**:

1. **Verify the attribute path** — the user-facing API is `wktlnix.services.hermes-agent.settings`, not `services.hermes-agent.settings`:
   ```nix
   # Correct
   wktlnix.services.hermes-agent.settings.model.default = "gpt-4";

   # Wrong — this sets the upstream module directly, bypassing the wrapper
   services.hermes-agent.settings.model.default = "gpt-4";
   ```

2. **Check for typos in key names** — `settings` is an open attrset with no schema validation. Misspelled keys are silently ignored by hermes-agent. Verify key names against [upstream docs](discovering-options.md).

3. **Remember the deep-merge** — your `settings` is `lib.recursiveUpdate`d over [hard-coded defaults](module-defaults.md). You only need to specify the delta. But if you set an entire section (e.g. `settings.agent = { ... }`), it merges key-by-key with the default, not replaces it.

4. **Lists are replaced, not merged** — if the default is `toolsets = [ "all" ]` and you set `toolsets = [ "bash" ]`, you get `[ "bash" ]`, not `[ "all" "bash" ]`.

5. **Rebuild and restart**:
   ```bash
   sudo nixos-rebuild switch
   sudo systemctl restart hermes-agent
   ```

6. **Check logs for config warnings**:
   ```bash
   journalctl -u hermes-agent -f | grep -i "config\|unknown\|warn"
   ```

### Service Won't Start

**Symptoms**: `systemctl start hermes-agent` fails.

**Solutions**:

1. Check logs:
   ```bash
   journalctl -u hermes-agent -f
   ```

2. Verify the build succeeds:
   ```bash
   nixos-rebuild build
   ```

3. Check sops secrets exist:
   ```bash
   sudo sops -d /path/to/secrets.yaml | grep hermes-agent-env
   ```

4. Verify the hermes user and state directory:
   ```bash
   ls -la /var/lib/hermes/
   id hermes
   ```

### MCP Server Not Starting

**Symptoms**: MCP servers not responding or failing to start.

> **Note**: MCP servers are hard-coded in the wrapper module. You cannot add or change them via `settings`. See [mcp-servers.md](mcp-servers.md) for how to edit the wrapper.

**Solutions**:

1. Check MCP server logs:
   ```bash
   journalctl -u hermes-agent -f | grep -i mcp
   ```

2. Verify the command exists in the service's PATH:
   ```bash
   # npx (from nodejs in extraPackages)
   sudo -u hermes /run/current-system/sw/bin/npx --version

   # nix
   sudo -u hermes /run/current-system/sw/bin/nix --version
   ```

3. Test MCP server manually:
   ```bash
   sudo -u hermes npx -y @modelcontextprotocol/server-filesystem /tmp
   ```

4. Check file permissions on workspace:
   ```bash
   ls -la /var/lib/hermes/workspace
   ```

### Memory/Hindsight Issues

**Symptoms**: Memory not persisting or profile not loading.

**Solutions**:

1. Check hindsight config exists (written by the wrapper's activation script):
   ```bash
   ls -la /var/lib/hermes/.hermes/hindsight/config.json
   ```

2. Verify hindsight service is accessible:
   ```bash
   curl -s https://hindsight.milet.lincx.top/health
   ```

3. Check memory settings in config:
   ```nix
   # The wrapper sets these defaults:
   settings.memory = {
     memory_enabled = true;
     memory_char_limit = 3000;
     user_char_limit = 1800;
   };
   ```

4. Check logs for hindsight errors:
   ```bash
   journalctl -u hermes-agent -f | grep -i hindsight
   ```

> The hindsight backend connection (API URL, bank ID, retain/recall params) is hard-coded in the wrapper's activation script. To change it, edit `modules/nixos/services/hermes-agent/default.nix`.

### Performance Issues

**Symptoms**: Slow responses, high resource usage.

**Solutions**:

1. Reduce reasoning effort:
   ```nix
   wktlnix.services.hermes-agent.settings.agent.reasoning_effort = "low";
   ```

2. Lower turn limits:
   ```nix
   wktlnix.services.hermes-agent.settings.agent.max_turns = 30;
   ```

3. Enable or adjust compression:
   ```nix
   wktlnix.services.hermes-agent.settings.compression.threshold = 0.70;
   ```

4. Check resource usage:
   ```bash
   top -u hermes
   ```

## Debugging Commands

### Check Configuration

```bash
# Build configuration (catches eval errors)
nixos-rebuild build

# Evaluate the hermes-agent settings
nix eval .#nixosConfigurations.<hostname>.config.wktlnix.services.hermes-agent.settings
```

### Inspect Service

```bash
# Service status
systemctl status hermes-agent

# Service logs (follow)
journalctl -u hermes-agent -f

# Service logs (last 100 lines)
journalctl -u hermes-agent -n 100

# Service properties
systemctl show hermes-agent
```

### Check Environment

```bash
# Check that sops secret is wired
systemctl show hermes-agent | grep -i environment

# File permissions
ls -la /var/lib/hermes/

# Disk space
df -h /var/lib/hermes
```

### Check Generated Config

The upstream NixOS module serializes `settings` to a YAML file. To see the generated config:

```bash
# Find the generated config file
find /nix/store -path '*hermes*' -name 'config.yaml' 2>/dev/null

# Or check the service's Environment/ExecStart to see where it reads config from
systemctl cat hermes-agent
```

## Common Error Messages

### "Permission denied"

- Check file ownership: `ls -la /var/lib/hermes/`
- Verify user groups: `groups hermes`
- The state directory should be owned by `hermes:hermes`

### "Command not found" (in MCP servers)

- The command must be in `extraPackages` (hard-coded in the wrapper)
- To add a command, edit the wrapper module — see [mcp-servers.md](mcp-servers.md)
- Use full path as workaround: `/run/current-system/sw/bin/npx`

### "Unknown configuration key" (in hermes-agent logs)

- hermes-agent warns about unknown root-level keys
- Check spelling against [upstream docs](discovering-options.md)

## Getting Help

### Log Collection

```bash
# Service logs
journalctl -u hermes-agent -n 500 > hermes-logs.txt

# System information
uname -a > system-info.txt
nixos-version >> system-info.txt

# Hermes-agent version (if available)
hermes --version >> system-info.txt 2>&1
```

### Community Resources

- [hermes-agent docs](https://hermes-agent.nousresearch.com/docs/)
- [hermes-agent GitHub](https://github.com/NousResearch/hermes-agent)
- [NixOS Discourse](https://discourse.nixos.org/)

## See Also

- [discovering-options.md](discovering-options.md) — How to find valid config keys.
- [module-defaults.md](module-defaults.md) — Hard-coded defaults in the wrapper.
- [mcp-servers.md](mcp-servers.md) — MCP server configuration (hard-coded).
