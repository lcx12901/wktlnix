{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption;

  cfg = config.wktlnix.security.sudo-rs;
in
{
  options.wktlnix.security.sudo-rs = {
    enable = mkEnableOption "Whether or not to replace sudo with sudo-rs.";
  };

  config = mkIf cfg.enable {
    security.sudo-rs = {
      enable = true;
      package = pkgs.sudo-rs;

      wheelNeedsPassword = false;
    };
  };
}
