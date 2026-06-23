# Model Configuration — Quick Reference

This is a quick reference for the `settings.model` section. For the authoritative and complete list of keys, types, and defaults, see the upstream sources below.

> **Important**: `settings.model` is a hermes-agent **application config** key, not a NixOS module option. The NixOS module's `settings` is an open attrset with no schema — the valid keys and types are defined by the hermes-agent app. Always verify against upstream docs.

## Authoritative Sources

- **Example file**: [`cli-config.yaml.example` lines 8–87](https://github.com/NousResearch/hermes-agent/blob/main/cli-config.yaml.example) — full `model` section with inline comments
- **Docs page**: [Configuring Models](https://hermes-agent.nousresearch.com/docs/user-guide/configuring-models)
- **Env vars**: [Environment Variables Reference](https://hermes-agent.nousresearch.com/docs/reference/environment-variables)

## Wrapper Default

The wrapper module sets this baseline (your `settings.model` is deep-merged over it):

```nix
model = {
  default = "mimo-v2.5";
  provider = "opencode-go";
};
```

## Common Overrides

### Switch to OpenAI

```nix
wktlnix.services.hermes-agent.settings.model = {
  default = "gpt-4o";
  provider = "openai";
};
```

Requires `OPENAI_API_KEY` in the sops secret `hermes-agent-env`.

### Switch to Anthropic

```nix
wktlnix.services.hermes-agent.settings.model = {
  default = "claude-sonnet-4-20250514";
  provider = "anthropic";
};
```

Requires `ANTHROPIC_API_KEY` in the sops secret `hermes-agent-env`.

### Use a custom OpenAI-compatible endpoint

```nix
wktlnix.services.hermes-agent.settings.model = {
  default = "my-model";
  provider = "my-provider";
  base_url = "https://my-api.example.com/v1";
};
```

Or use `settings.custom_providers` for more control — see the example file.

### Change only the model name (keep provider)

```nix
wktlnix.services.hermes-agent.settings.model.default = "gpt-4o-mini";
```

`recursiveUpdate` preserves `model.provider = "opencode-go"` from the default.

## Key Reference (verify against upstream)

| Key | Type | Default (wrapper) | Notes |
|---|---|---|---|
| `default` | string | `"mimo-v2.5"` | Model name — must be valid for the provider |
| `provider` | string | `"opencode-go"` | Provider identifier |
| `base_url` | string | — | Override API endpoint URL |
| `api_key` | string | — | Usually set via env var instead |
| `context_length` | integer | — | Override context window size |
| `max_tokens` | integer | — | Max output tokens |
| `default_headers` | attrset | — | Extra HTTP headers |
| `auth_mode` | string | — | Authentication mode |
| `entra.*` | attrset | — | Azure Entra ID config |

> This table is a quick reference only. The example file and docs page are authoritative — they may list additional keys or different defaults depending on the locked upstream version.

## Environment Variables

Model providers require API keys. These go in the sops secret `hermes-agent-env` (managed by the wrapper's `environmentFiles`), NOT in `settings`:

```bash
# In the sops secrets file (hermes-agent-env)
OPENAI_API_KEY=sk-...
ANTHROPIC_API_KEY=sk-ant-...
```

The wrapper automatically wires `environmentFiles` to `config.sops.secrets."hermes-agent-env".path`. You don't need to configure this — it's hard-coded.

## See Also

- [discovering-options.md](discovering-options.md) — How to find valid keys for any section.
- [module-defaults.md](module-defaults.md) — All hard-coded defaults in the wrapper.
- [agent-options.md](agent-options.md) — Agent behavior settings.
