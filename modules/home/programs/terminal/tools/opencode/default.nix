{
  inputs,
  config,
  lib,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption;

  cfg = config.wktlnix.programs.terminal.tools.opencode;
in
{
  options.wktlnix.programs.terminal.tools.opencode = {
    enable = mkEnableOption "opencode";
  };

  config = mkIf cfg.enable {
    programs.opencode = {
      enable = true;

      enableMcpIntegration = false;

      settings = {
        theme = "opencode";
        model = "github-copilot/gpt-5.2-codex";
        autoshare = false;
        autoupdate = false;
      };
    };

    xdg.configFile.".opencode/skills" = {
      source = "${inputs.antfu-skills}/skills";
      recursive = true;
    };

    sops.secrets."opencode_auth" = {
      path = "/home/${config.wktlnix.user.name}/.local/share/opencode/auth.json";
    };
  };
}
