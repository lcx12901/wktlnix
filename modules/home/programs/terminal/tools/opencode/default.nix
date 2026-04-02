{
  inputs,
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
in
{
  imports = [
    ./lsp.nix
    ./permission.nix
  ];

  options.wktlnix.programs.terminal.tools.opencode = {
    enable = mkEnableOption "opencode";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [ lsof ];

    programs.opencode = {
      enable = true;

      enableMcpIntegration = false;

      settings = {
        theme = "catppuccin-frappe";
        model = "github-copilot/gpt-5.2-codex";
        autoshare = false;
        autoupdate = false;

        plugin = [
          # Dynamic context pruning
          "@tarquinen/opencode-dcp@latest"
          # Support background shell commands
          "opencode-pty"
          #
          "oh-my-opencode"
        ];
      };
    };

    xdg.configFile."opencode/skill" = {
      source = "${inputs.antfu-skills}/skills";
      recursive = true;
    };

    sops.secrets."opencode_auth" = {
      path = "/home/${config.wktlnix.user.name}/.local/share/opencode/auth.json";
    };

    home.persistence = lib.mkIf persist {
      "/persist" = {
        directories = [ ".local/share/opencode" ];
      };
    };
  };
}
