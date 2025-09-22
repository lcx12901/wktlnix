{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption;

  cfg = config.wktlnix.hardware.bluetooth;
in
{
  options.wktlnix.hardware.bluetooth = {
    enable = mkEnableOption "Whether or not to enable support for extra bluetooth devices.";
  };

  config = mkIf cfg.enable {
    hardware.bluetooth = {
      enable = true;

      package = pkgs.bluez-experimental;

      powerOnBoot = true;

      settings = {
        General = {
          Experimental = true;
          JustWorksRepairing = "always";
          MultiProfile = "multiple";
        };
      };
    };

    boot.kernelParams = [ "btusb" ];

    services.blueman = {
      enable = true;
    };
  };
}
