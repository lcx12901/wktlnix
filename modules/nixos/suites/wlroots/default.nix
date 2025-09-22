{ config, lib, ... }:
let
  inherit (lib) mkIf mkEnableOption;

  cfg = config.wktlnix.suites.wlroots;
in
{
  options.wktlnix.suites.wlroots = {
    enable = mkEnableOption "Whether or not to enable common wlroots configuration.";
  };

  config = mkIf cfg.enable {
    programs = {
      xwayland.enable = true;
    };
  };
}
