{
  osConfig,
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption;

  persist = osConfig.wktlnix.system.persist.enable;

  cfg = config.wktlnix.programs.terminal.tools.opencode;

  agents = import ./agents.nix { inherit lib; };
  commands = import ./commands.nix { inherit lib; };

  # Shared skills - filtered for opencode
  sharedSkills = import (lib.file.get-file "modules/common/skills/default.nix") {
    inherit pkgs lib;
  };
in
{
  imports = [
    ./lsp.nix
    ./formatters.nix
    ./permission.nix
    ./openagent.nix
  ];

  options.wktlnix.programs.terminal.tools.opencode = {
    enable = mkEnableOption "opencode";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [ lsof ];

    programs = {
      opencode = {
        enable = true;

        enableMcpIntegration = false;

        tui = {
          theme = "catppuccin-frappe";
        };

        settings = {
          model = "opencode-go/mimo-v2.5";
          autoshare = false;
          autoupdate = false;

          plugin = [
            "@tarquinen/opencode-dcp@latest"
            "opencode-pty"
            "oh-my-openagent"
            [
              "@vectorize-io/opencode-hindsight"
              {
                hindsightApiUrl = "https://hindsight.milet.lincx.top";
                hindsightApiToken = "{file:${config.sops.secrets."hindsight-tenant-api-key".path}}";
                bankId = "opencode";
                autoRecall = true;
                autoRetain = true;
                recallBudget = "high";
                recallMaxTokens = 2048; # 增加 token 预算
                retainEveryNTurns = 2; # 更频繁保留
                retainOverlapTurns = 3; # 增加重叠窗口
                retainMode = "full-session"; # 保留完整会话
              }
            ]
          ];

          provider = {
            opencode-go = {
              options = {
                apiKey = "{file:${config.sops.secrets."OPENCODE_API_KEY".path}}";
              };
            };
          };

          mcp = {
            nixos = {
              enabled = true;
              type = "local";
              command = [
                "nix"
                "run"
                "github:utensils/mcp-nixos"
                "--"
              ];
              timeout = 300000;
            };
          };
        };

        # Shared skills - filtered for opencode
        # This uses the dedicated home-manager option, not settings.skills
        # Convert derivation to string path for type compatibility
        skills = toString sharedSkills.opencode;

        agents = agents.renderAgents;
        commands = commands.renderCommands;
        context = builtins.readFile ./rules/base.md;
      };
    };

    home.persistence = lib.mkIf persist {
      "/persist" = {
        directories = [
          ".local/share/opencode"
          ".local/cache/opencode"
          ".local/cache/oh-my-opencode"
        ];
      };
    };

    sops.secrets = {
      "OPENCODE_API_KEY" = { };
      "hindsight-tenant-api-key" = { };
    };
  };
}
