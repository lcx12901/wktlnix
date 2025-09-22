{ config, lib, ... }:
let
  inherit (lib) mkIf mkEnableOption;

  cfg = config.wktlnix.services.dbus;
in
{
  options.wktlnix.services.dbus = {
    enable = mkEnableOption "Whether or not to enable dbus service.";
  };

  config = mkIf cfg.enable {
    services.dbus = {
      enable = true;

      implementation = "broker";
    };
  };
}
