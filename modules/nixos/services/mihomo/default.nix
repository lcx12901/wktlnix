{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption;

  cfg = config.wktlnix.services.mihomo;
in
{
  options.wktlnix.services.mihomo = {
    enable = mkEnableOption "Whether or not to enable mihomo.";
  };

  config = mkIf cfg.enable {
    services.mihomo = {
      enable = true;
      configFile = config.sops.secrets."mihomo_config".path;
      webui = pkgs.metacubexd;
      tunMode = true;
      processesInfo = true;
    };

    systemd.tmpfiles.rules = [
      "L+ /var/lib/mihomo/GeoIP.dat - - - - ${pkgs.v2ray-geoip}/share/v2ray/geoip.dat"
      "L+ /var/lib/mihomo/GeoSite.dat - - - - ${pkgs.v2ray-domain-list-community}/share/v2ray/geosite.dat"
    ];

    sops.secrets."mihomo_config" = {
      sopsFile = lib.file.get-file "secrets/mihomo.yaml";
    };
  };
}
