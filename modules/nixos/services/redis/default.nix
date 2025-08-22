{
  config,
  lib,
  pkgs,
  namespace,
  ...
}:
let
  cfg = config.${namespace}.services;
in
{
  options.${namespace}.services.redis = {
    enable = lib.mkEnableOption "Whether or not to enable Redis.";
  };

  config = lib.mkIf cfg.redis.enable {
    services.redis = {
      package = pkgs.valkey;
    };
  };
}
