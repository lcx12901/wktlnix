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
    getExe
    mkForce
    ;

  cfg = config.wktlnix.programs.terminal.tools.ripgrep;
in
{
  options.wktlnix.programs.terminal.tools.ripgrep = {
    enable = mkEnableOption "Whether or not to enable ripgrep.";
  };

  config = mkIf cfg.enable {
    programs.ripgrep = {
      enable = true;
      package = pkgs.ripgrep;

      arguments = [
        # Don't have ripgrep vomit a bunch of stuff on the screen
        # show a preview of the match
        "--max-columns=150"
        "--max-columns-preview"

        # ignore git files
        "--glob=!.git/*"

        "--smart-case"
      ];
    };

    home.shellAliases = {
      grep = mkForce (getExe config.programs.ripgrep.package);
    };
  };
}
