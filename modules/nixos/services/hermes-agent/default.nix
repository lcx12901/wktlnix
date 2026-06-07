{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption;
  inherit (lib.wktlnix) mkOpt;

  cfg = config.wktlnix.services.hermes-agent;

  stateDir = "/var/lib/hermes";
  workingDirectory = "${stateDir}/workspace";
in
{
  options.wktlnix.services.hermes-agent = {
    enable = mkEnableOption "Whether to enable hermes-agent.";
    settings = mkOpt lib.types.attrs { } "Hermes YAML config settings.";
  };

  config = mkIf cfg.enable {
    services.hermes-agent = {
      enable = true;

      addToSystemPackages = true;
      restart = "always";
      restartSec = 5;

      environmentFiles = [ config.sops.secrets."hermes-agent-env".path ];

      settings = lib.recursiveUpdate {
        model = {
          default = "mimo-v2.5";
          provider = "opencode-go";
        };

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
          model = "Mimo-v2.5";
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

      mcpServers = {
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

      extraPackages = with pkgs; [
        bashInteractive
        coreutils
        curl
        fd
        git
        gnumake
        jq
        nodejs
        python312
        ripgrep
        uv
      ];
    };

    sops.secrets."hermes-agent-env" = { };

    # environment.persistence."/persist" = {
    #   hideMounts = true;
    #
    #   directories = [
    #     stateDir
    #   ];
    # };
  };
}
