{
  osConfig,
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib.wktlnix) mkBoolOpt;

  cfg = config.wktlnix.services.openclaw;

  persist = osConfig.wktlnix.system.persist.enable;
in
{
  options.wktlnix.services.openclaw = {
    enable = mkBoolOpt false "Whether to enable OpenClaw.";
  };

  imports = [
    ./agent-list.nix
    ./browser-tools.nix
    ./models.nix
    ./plugins.nix
  ];

  config = lib.mkIf cfg.enable {
    # Ensure secrets are decrypted before OpenClaw gateway starts
    systemd.user.services.openclaw-gateway = {
      Unit = {
        After = [ "sops-nix.service" ];
        Wants = [ "sops-nix.service" ];
      };
    };

    programs.openclaw = {
      enable = true;

      workspace.bootstrapFiles = {
        agents = ./documents/nova/AGENTS.md;
        soul = ./documents/nova/SOUL.md;
        tools = ./documents/nova/TOOLS.md;
        identity = ./documents/nova/IDENTITY.md;
        user = ./documents/nova/USER.md;
      };

      runtimePackages = with pkgs; [
        chromium
      ];

      # Environment variables for secrets not handled by file-backed SecretRefs
      environment = {
        TELEGRAM_BOT_TOKEN = config.sops.secrets."${osConfig.networking.hostName}_telegram_token".path;
        OPENCODE_API_KEY = config.sops.secrets."OPENCODE_API_KEY".path;
        HINDSIGHT_API_TOKEN = config.sops.secrets."hindsight-tenant-api-key".path;
      };

      config =
        let
          domain = osConfig.networking.fqdn;
        in
        {
          secrets.providers.sops = {
            source = "file";
            path = config.sops.secrets."${osConfig.networking.hostName}_openclaw_token".path;
            mode = "singleValue";
          };

          # Gateway reverse proxy config (Nginx terminates TLS, forwards to loopback)
          gateway = {
            mode = "local";
            auth = {
              mode = "token";
              token = {
                source = "file";
                provider = "sops";
                id = "value";
              };
            };
            trustedProxies = [ "127.0.0.1" ];
            controlUi = {
              enabled = true;
              allowedOrigins = [ "https://openclaw.${domain}" ];
            };
          };

          channels.telegram = {
            botToken = {
              source = "env";
              provider = "default";
              id = "TELEGRAM_BOT_TOKEN";
            };
            dmPolicy = "allowlist";
            allowFrom = [ 975201632 ]; # your Telegram user ID
            groups = {
              "*" = {
                requireMention = true;
              };
            };
          };

          # Assistant avatar
          ui.assistant.avatar = "${./avatar/Assistant.jpg}";

          # MCP servers
          mcp = {
            servers = {
              nixos = {
                command = "nix";
                args = [
                  "run"
                  "github:utensils/mcp-nixos"
                  "--"
                ];
              };
            };
          };
        };

      excludeTools = [
        "git"
        "jq"
        "ripgrep"
        "curl"
        "nodejs_22"
      ];

      bundledPlugins.goplaces.enable = false;

      # Skills injected directly to workspace/skills/ via copySkills activation step
      # (bypasses extraDirs hardlink issue in gateway's openPinnedFileSync)
      skills = [ ];
    };

    # SOPS secrets for environment variables
    sops.secrets = {
      "${osConfig.networking.hostName}_openclaw_token" = { };
      "${osConfig.networking.hostName}_telegram_token" = { };
      "OPENCODE_API_KEY" = { };
      "hindsight-tenant-api-key" = { };
    };

    home.persistence = lib.mkIf persist {
      "/persist" = {
        directories = [
          {
            directory = ".openclaw";
            mode = "0700";
          }
        ];
      };
    };
  };
}
