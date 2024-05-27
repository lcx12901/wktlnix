{
  config,
  lib,
  pkgs,
  namespace,
  ...
}:
let
  inherit (lib) mkIf;
  inherit (lib.${namespace}) enabled;

  cfg = config.${namespace}.suites.common;
in
{
  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      curl
      fd
      unzip
      wget
    ];
  };
}