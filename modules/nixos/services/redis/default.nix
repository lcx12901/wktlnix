{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption;

  cfg = config.wktlnix.services;
in
{
  options.wktlnix.services.redis = {
    enable = mkEnableOption "Whether or not to enable Redis.";
  };

  config = mkIf cfg.redis.enable {
    services.redis = {
      package = pkgs.valkey;
    };
  };
}
