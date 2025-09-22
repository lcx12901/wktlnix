{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption getExe;

  cfg = config.wktlnix.programs.terminal.tools.eza;
in
{
  options.wktlnix.programs.terminal.tools.eza = {
    enable = mkEnableOption "Whether or not to enable eza.";
  };

  config = mkIf cfg.enable {
    programs.eza = {
      enable = true;
      package = pkgs.eza;

      enableBashIntegration = true;
      enableZshIntegration = true;
      enableFishIntegration = true;
      enableNushellIntegration = true;

      extraOptions = [
        "--group-directories-first"
        "--header"
      ];

      git = true;
      icons = "auto";
    };

    home.shellAliases =
      let
        eza = config.programs.eza.package;
      in
      {
        la = lib.mkForce "${getExe eza} -lah --tree";
        tree = lib.mkForce "${getExe eza} --tree --icons=always";
      };
  };
}
