{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption;

  cfg = config.wktlnix.programs.terminal.tools.colorls;
in
{
  options.wktlnix.programs.terminal.tools.colorls = {
    enable = mkEnableOption "Whether or not to enable colorls.";
  };

  config = mkIf cfg.enable {
    home = {
      packages = with pkgs; [ colorls ];

      shellAliases = {
        lc = "colorls --sd";
        lcg = "lc --gs";
        lcl = "lc -1";
        lclg = "lc -1 --gs";
        lcu = "colorls -U";
        lclu = "colorls -U -1";
      };
    };
  };
}
