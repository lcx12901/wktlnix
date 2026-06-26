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
  nginxEnabled = osConfig.wktlnix.services.openclaw-nginx.enable;

  # Shared skills - filtered for opencode
  sharedSkills = import (lib.file.get-file "modules/common/skills/default.nix") {
    inherit pkgs lib;
  };

  # Patch OpenClaw to fix btrfs hardlink rejection bug.
  # On btrfs, all files have nlink > 1 due to content-addressed storage.
  # OpenClaw's openPinnedFileSync defaults rejectHardlinks=true, which rejects
  # every SKILL.md file. Patch the default to false for skill file reading.
  patchedGateway =
    pkgs.runCommand "openclaw-gateway-patched"
      {
        preferLocalBuild = true;
      }
      ''
        cp -r ${pkgs.openclaw-gateway} $out
        chmod -R u+w $out
        # Fix 1: Patch rejectHardlinks default to allow btrfs nlink > 1
        find $out -name "root-file-*.js" -exec sed -i \
          's/params\.rejectHardlinks ?? true/params.rejectHardlinks ?? false/g' {} \;
        # Fix 2: The bin/openclaw wrapper has a hardcoded path to the original
        # gateway's dist/index.js. Update it to point to $out.
        sed -i "s|${pkgs.openclaw-gateway}/lib|$out/lib|g" $out/bin/openclaw
      '';
  patchedOpenclaw = pkgs.openclaw.override {
    openclaw-gateway = patchedGateway;
  };
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
      package = patchedOpenclaw;

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
        OPENCLAW_GATEWAY_TOKEN = config.sops.secrets."${osConfig.networking.hostName}_openclaw_token".path;
      };

      config =
        let
          domain = osConfig.networking.fqdn;
        in
        {
          # Gateway reverse proxy config (Nginx terminates TLS, forwards to loopback)
          gateway = {
            mode = "local";
            auth = {
              mode = "token";
              token = {
                source = "env";
                provider = "default";
                id = "OPENCLAW_GATEWAY_TOKEN";
              };
            };
          }
          // lib.mkIf nginxEnabled {
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

          # Skills: point at the skills collection directory.
          # OpenClaw scans each extraDir for subdirectories containing SKILL.md.
          skills = {
            load = {
              extraDirs = [ (toString sharedSkills.openclaw) ];
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
