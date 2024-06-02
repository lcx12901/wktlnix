{
  config,
  lib,
  inputs,
  pkgs,
  namespace,
  ...
}: let
  inherit (lib) mkIf;
  inherit (lib.${namespace}) mkBoolOpt;

  cfg = config.${namespace}.services.mihomo;
in {
  options.${namespace}.services.mihomo = {
    enable = mkBoolOpt false "Whether or not to enable mihomo.";
  };

  config = mkIf cfg.enable {
    services.mihomo = {
      enable = true;
      tunMode = true;

      webui = inputs.metacubexd;

      configFile = config.age.secrets."mihomo.conf".path;
    };

    systemd.services.mihomo.serviceConfig.ExecStartPre = [
      # "${pkgs.coreutils}/bin/ln -sf ${pkgs.${namespace}.country-mmdb}/Country-ASN.mmdb /var/lib/private/mihomo/ASN.mmdb"
      "${pkgs.coreutils}/bin/ln -sf ${pkgs.v2ray-geoip}/share/v2ray/geoip.dat /var/lib/private/mihomo/GeoIP.dat"
      "${pkgs.coreutils}/bin/ln -sf ${pkgs.v2ray-domain-list-community}/share/v2ray/geosite.dat /var/lib/private/mihomo/GeoSite.dat"
    ];
  };
}