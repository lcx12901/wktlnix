# Agent Behavior Configuration — Quick Reference

This is a quick reference for the `settings.agent` section. For the authoritative and complete list of keys, see the upstream sources below.

> **Important**: `settings.agent` is a hermes-agent **application config** key, not a NixOS module option. The NixOS module's `settings` is an open attrset with no schema — the valid keys and types are defined by the hermes-agent app. Always verify against upstream docs.

## Authoritative Sources

- **Example file**: [`cli-config.yaml.example` lines 609–720](https://github.com/NousResearch/hermes-agent/blob/main/cli-config.yaml.example) — full `agent` section with inline comments
- **Docs page**: [Configuration](https://hermes-agent.nousresearch.com/docs/user-guide/configuration) — general config overview

## Wrapper Default

The wrapper module sets this baseline (your `settings.agent` is deep-merged over it):

```nix
agent = {
  max_turns = 90;
  gateway_timeout = 3600;
  gateway_timeout_warning = 900;
  gateway_notify_interval = 180;
  reasoning_effort = "medium";
};
```

## Common Overrides

### Allow longer conversations

```nix
wktlnix.services.hermes-agent.settings.agent = {
  max_turns = 150;
  gateway_timeout = 7200;  # 2 hours
};
```

### Quick responses (lower effort)

```nix
wktlnix.services.hermes-agent.settings.agent = {
  max_turns = 30;
  reasoning_effort = "low";
};
```

### Deep analysis (higher effort)

```nix
wktlnix.services.hermes-agent.settings.agent = {
  max_turns = 200;
  reasoning_effort = "high";
  gateway_timeout = 7200;
  gateway_timeout_warning = 1800;
};
```

### Change only reasoning effort

```nix
wktlnix.services.hermes-agent.settings.agent.reasoning_effort = "high";
```

`recursiveUpdate` preserves the other agent defaults.

## Key Reference (verify against upstream)

| Key | Type | Default (wrapper) | Notes |
|---|---|---|---|
| `max_turns` | integer | `90` | Max conversation turns before auto-termination |
| `gateway_timeout` | integer | `3600` (1h) | Max time for gateway operations in seconds |
| `gateway_timeout_warning` | integer | `900` (15m) | Seconds before timeout to send warning |
| `gateway_notify_interval` | integer | `180` (3m) | Interval between progress notifications in seconds |
| `reasoning_effort` | string | `"medium"` | `"low"` \| `"medium"` \| `"high"` |
| `gateway_drain_timeout` | integer | — | Drain timeout before force-stopping |

> This table is a quick reference only. The example file is authoritative — it may list additional keys.

## Performance Trade-offs

### API Costs

- Higher `max_turns` → more API calls per conversation
- Higher `reasoning_effort` → more tokens per response (higher cost, slower)
- Balance quality vs. cost based on your use case

### Response Time

- `reasoning_effort = "low"`: Fast, suitable for simple questions
- `reasoning_effort = "medium"`: Balanced, good for most tasks (default)
- `reasoning_effort = "high"`: Thorough, better for complex analysis but slower

### Resource Usage

- Longer `gateway_timeout` → operations can run longer but consume more resources
- More `max_turns` → more memory usage per conversation
- Consider your server's capabilities when increasing limits

## Integration with Other Sections

### With Compression

For long conversations, enable compression to manage context:

```nix
settings = {
  agent.max_turns = 150;
  compression = {
    enabled = true;
    threshold = 0.80;
  };
};
```

### With Delegation

Limit delegation iterations to control cost:

```nix
settings = {
  agent.max_turns = 100;
  delegation.max_iterations = 30;
};
```

## See Also

- [discovering-options.md](discovering-options.md) — How to find valid keys for any section.
- [module-defaults.md](module-defaults.md) — All hard-coded defaults in the wrapper.
- [model-options.md](model-options.md) — Model configuration.
