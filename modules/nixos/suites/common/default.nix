{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption;

  cfg = config.wktlnix.suites.common;
in
{
  options.wktlnix.suites.common = {
    enable = mkEnableOption "Whether or not to enable common configuration.";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      curl
      fd
      unzip
      wget
      less
    ];

    zramSwap.enable = true;

    hardware.ksm = {
      enable = true;
      sleep = 100; # ms between scans (lower = more aggressive dedup, slightly more CPU)
    };
  };
}
