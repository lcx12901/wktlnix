{
  config,
  lib,
  pkgs,
  namespace,
  ...
}: let
  inherit (lib) mkIf;
  inherit (lib.${namespace}) mkBoolOpt;

  cfg = config.${namespace}.hardware.btrfs;
in {
  options.${namespace}.hardware.btrfs = {
    enable = mkBoolOpt false "Whether or not to enable support for btrfs devices.";
    autoScrub = mkBoolOpt true "Whether to enable btrfs autoScrub;";
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
        autoScrub = mkIf cfg.autoScrub {
          enable = true;
          fileSystems = ["/"];
          interval = "weekly";
        };
      };
    };
  };
}
