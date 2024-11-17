{
  config,
  lib,
  pkgs,
  namespace,
  ...
}:
let
  cfg = config.${namespace}.services.cloudflared;
in
{
  options.${namespace}.services.cloudflared = {
    enable = lib.${namespace}.mkBoolOpt false "Whether or not to configure cloudflared";
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      cloudflared
    ];
  };
}
