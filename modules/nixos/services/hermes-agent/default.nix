{
  config,
  lib,
  inputs,
  pkgs,
  ...
}:
let
  cfg = config.wktlnix.services.hermes-agent;
  inherit (cfg) stateDir;
  workingDirectory = "${stateDir}/workspace";
in
{
  imports = lib.optional (
    inputs ? hermes-agent
    && inputs.hermes-agent ? nixosModules
    && inputs.hermes-agent.nixosModules ? default
  ) inputs.hermes-agent.nixosModules.default;

  options.wktlnix.services.hermes-agent = {
    enable = lib.mkEnableOption "Hermes agent";

    environmentFiles = lib.mkOption {
      type = lib.types.listOf (lib.types.either lib.types.path lib.types.str);
      default = [ ];
      description = "Files sourced into Hermes service environment.";
    };

    stateDir = lib.mkOption {
      type = lib.types.str;
      default = "/var/lib/hermes";
      description = "Hermes state directory.";
    };

    settings = lib.mkOption {
      type = lib.types.attrs;
      default = { };
      description = "Hermes YAML config settings.";
    };

    enableDefaultMcpServers = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable low-friction filesystem and sequential-thinking MCP servers.";
    };
  };

  config = lib.mkIf cfg.enable {
    services.hermes-agent = {
      enable = true;
      addToSystemPackages = true;
      restart = "always";
      restartSec = 5;
      inherit stateDir workingDirectory;

      environmentFiles = map toString cfg.environmentFiles;

      settings = lib.recursiveUpdate {
        model = {
          default = "deepseek-v4-flash";
          provider = "opencode-go";
        };

        toolsets = [ "all" ];

        telegram = {
          require_mention = true;
          exclusive_bot_mentions = true;
          allowed_users = [ 975201632 ];
        };

        group_sessions_per_user = true;

        agent = {
          max_turns = 90;
          gateway_timeout = 3600;
          gateway_timeout_warning = 900;
          gateway_notify_interval = 180;
          reasoning_effort = "medium";
        };

        terminal = {
          backend = "local";
          cwd = workingDirectory;
          timeout = 300;
          persistent_shell = true;
        };

        compression = {
          enabled = true;
          threshold = 0.80;
          target_ratio = 0.25;
          protect_last_n = 24;
          abort_on_summary_failure = true;
        };

        delegation = {
          model = "deepseek-v4-flash";
          reasoning_effort = "medium";
          max_iterations = 50;
          child_timeout_seconds = 900;
          max_concurrent_children = 3;
        };

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
            fields = [
              "model"
              "context_pct"
              "cwd"
            ];
          };
        };

        dashboard.show_token_analytics = false;

        memory = {
          memory_enabled = true;
          user_profile_enabled = true;
          memory_char_limit = 3000;
          user_char_limit = 1800;
        };

        tool_loop_guardrails = {
          warnings_enabled = true;
          hard_stop_enabled = true;
        };
      } cfg.settings;

      mcpServers = lib.optionalAttrs cfg.enableDefaultMcpServers {
        filesystem = {
          command = "npx";
          args = [
            "-y"
            "@modelcontextprotocol/server-filesystem"
            workingDirectory
            stateDir
          ];
        };

        sequential-thinking = {
          command = "npx";
          args = [
            "-y"
            "@modelcontextprotocol/server-sequential-thinking"
          ];
        };
      };

      extraPackages = [
        pkgs.bashInteractive
        pkgs.coreutils
        pkgs.curl
        pkgs.fd
        pkgs.git
        pkgs.gnumake
        pkgs.iproute2
        pkgs.jq
        pkgs.openssh
        (pkgs.nodejs_22 or pkgs.nodejs)
        pkgs.python312
        pkgs.ripgrep
        pkgs.tailscale
        pkgs.tmux
        pkgs.uv
      ];

      container = {
        backend = lib.mkDefault "podman";
        hostUsers = lib.mkDefault [ config.wktlnix.user.name ];
      };
    };

    environment.persistence."/persist" = {
      hideMounts = true;

      directories = [
        stateDir
      ];
    };
  };
}
