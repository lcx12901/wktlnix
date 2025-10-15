{ config, lib, ... }:
let
  inherit (lib) mkIf mkEnableOption;

  cfg = config.wktlnix.programs.terminal.tools.nh;
in
{

  options.wktlnix.programs.terminal.tools.nh = {
    enable = mkEnableOption "Whether or not to enable nh.";
  };

  config = mkIf cfg.enable {
    programs.nh = {
      enable = true;

      clean = {
        enable = true;
      };

      flake = "${config.home.homeDirectory}/Coding/wktlnix";
    };

    home = {
      sessionVariables = {
        NH_SEARCH_PLATFORM = 1;
      };
      shellAliases = {
        nos = "nh os switch";
      };
    };
  };
}
