{
  config,
  # inputs,
  lib,
  pkgs,
  namespace,
  ...
}: let
  inherit (lib) mkIf;
  inherit (lib.${namespace}) mkBoolOpt;

  cfg = config.${namespace}.services.dae;
in {
  # https://github.com/daeuniverse/dae/blob/main/example.dae
  # check dae's log by `journalctl -u dae -n 1000`
  options.${namespace}.services.dae = {
    enable = mkBoolOpt false "Whether or not to enable dae.";
  };

  config = mkIf cfg.enable {
    services.dae = {
      enable = true;
      configFile = config.age.secrets."config.dae".path;
      assets = with pkgs; [v2ray-geoip v2ray-domain-list-community];
      openFirewall = {
        enable = true;
        port = 12345;
      };
    };

    systemd.services.dae.serviceConfig = {
      Restart = "on-failure";
      RestartSec = 10;
    };
  };
}
