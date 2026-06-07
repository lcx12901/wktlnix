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
          ];

          provider = {
            opencode-go = {
              options = {
                apiKey = "{file:${config.sops.secrets."OPENCODE_API_KEY".path}}";
              };
            };
          };
        };

        agents = agents.renderAgents;
        commands = commands.renderCommands;
        context = builtins.readFile ./rules/base.md;
      };
    };

    home.persistence = lib.mkIf persist {
      "/persist" = {
        directories = [
          "./opencode"
          ".local/share/opencode"
          ".local/cache/opencode"
          ".local/cache/oh-my-opencode"
        ];
      };
    };

    sops.secrets = {
      "OPENCODE_API_KEY" = { };
    };
  };
}
