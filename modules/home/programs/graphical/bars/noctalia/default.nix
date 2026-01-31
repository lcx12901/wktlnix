{ config, lib, ... }:
let
  inherit (lib) mkIf mkEnableOption;

  cfg = config.wktlnix.programs.graphical.bars.noctalia;
in
{
  options.wktlnix.programs.graphical.bars.noctalia = {
    enable = mkEnableOption "noctalia";
  };

  config = mkIf cfg.enable {
    programs.noctalia-shell = {
      enable = true;

      settings = { };
    };
  };
}
