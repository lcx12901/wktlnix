{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib)
    mkIf
    mkEnableOption
    ;
  inherit (lib.wktlnix) mkOpt;

  cfg = config.wktlnix.services.hermes-agent;

  stateDir = "/var/lib/hermes";
  workingDirectory = "${stateDir}/workspace";

  # Shared skills - filtered for hermes
  sharedSkills = import (lib.file.get-file "modules/common/skills/default.nix") {
    inherit pkgs lib;
  };
in
{
  options.wktlnix.services.hermes-agent = {
    enable = mkEnableOption "Whether to enable hermes-agent.";
    settings = mkOpt lib.types.attrs { } "Hermes YAML config settings.";
  };

  config = mkIf cfg.enable {
    wktlnix.user.extraGroups = [ "hermes" ];

    services.hermes-agent = {
      enable = true;

      extraDependencyGroups = [
        "messaging"
        "voice"
        "hindsight"
      ];

      addToSystemPackages = true;
      restart = "always";
      restartSec = 5;

      environmentFiles = [ config.sops.secrets."hermes-agent-env".path ];

      settings = lib.recursiveUpdate {
        model = {
          default = "mimo-v2.5";
          provider = "opencode-go";
        };

        toolsets = [ "all" ];

        discord = {
          require_mention = true;
          thread_require_mention = true;
          auto_thread = true;
          reactions = true;
          reply_to_mode = "first";
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
          model = "mimo-v2.5";
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
          provider = "hindsight";
          memory_enabled = true;
          user_profile_enabled = true;
          memory_char_limit = 3000;
          user_char_limit = 1800;
        };

        skills = {
          external_dirs = [ (toString sharedSkills.hermes) ];
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

        nixos = {
          command = "nix";
          args = [
            "run"
            "github:utensils/mcp-nixos"
            "--"
          ];
        };
      };

      extraPackages = with pkgs; [
        bashInteractive
        coreutils
        curl
        direnv
        fd
        git
        gnumake
        jq
        nix
        nix-direnv
        nodejs
        python312
        python312Packages.ptyprocess # Dashboard Chat 标签页需要
        python312Packages.fastapi # Dashboard Web 服务器
        python312Packages.uvicorn # Dashboard ASGI 服务器
        ripgrep
        tmux
        uv
      ];
    };

    systemd.tmpfiles.rules = [
      "d ${stateDir}/.hermes/pairing 0750 hermes hermes -"
    ];

    system.activationScripts.hermes-soul = ''
      install -o hermes -g hermes -m 0640 ${./documents/SOUL.md} ${stateDir}/.hermes/SOUL.md
    '';

    system.activationScripts.hindsight-config =
      let
        cfg = builtins.toJSON {
          mode = "local_external";
          api_url = "https://hindsight.${config.networking.fqdn}";
          bank_id = "hermes";
          recall_budget = "mid";
          memory_mode = "hybrid";
          recall_max_tokens = 2048;
          retain_every_n_turns = 10;
          retain_overlap_turns = 3;
          retain_async = true;
          auto_retain = true;
          auto_recall = true;
        };
      in
      ''
        mkdir -p /var/lib/hermes/.hermes/hindsight
        echo '${cfg}' > /var/lib/hermes/.hermes/hindsight/config.json
        chown -R hermes:hermes /var/lib/hermes/.hermes
      '';

    sops.secrets."hermes-agent-env" = {
      mode = "0400";
      owner = config.services.hermes-agent.user;
      group = config.services.hermes-agent.group;
      restartUnits = [ "hermes-agent.service" ];
    };

    environment.persistence."/persist" = {
      hideMounts = true;

      directories = [
        stateDir
      ];
    };
  };
}
