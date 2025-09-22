{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption;

  cfg = config.wktlnix.hardware.graphics;
in
{
  options.wktlnix.hardware.graphics = {
    enable = mkEnableOption "Whether or not to enable support for graphics.";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      libva-utils
      vdpauinfo
    ];

    hardware.graphics = {
      enable = true;
      enable32Bit = true;
      extraPackages = with pkgs; [
        libva-vdpau-driver
        libvdpau-va-gl
        libva
        libvdpau
        libdrm
      ];
    };
  };
}
