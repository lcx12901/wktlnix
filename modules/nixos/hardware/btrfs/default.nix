{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption;

  cfg = config.wktlnix.hardware.btrfs;
in
{
  options.wktlnix.hardware.btrfs = {
    enable = mkEnableOption "Whether or not to enable support for btrfs devices.";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      btdu
      btrfs-assistant
      btrfs-snap
      # compsize # https://github.com/kilobyte/compsize/issues/52
      snapper
    ];

    services = {
      btrfs = {
        autoScrub = {
          enable = true;
          fileSystems = [ "/" ];
          interval = "weekly";
        };
      };
    };
  };
}
