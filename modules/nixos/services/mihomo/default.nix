{
  config,
  lib,
  pkgs,
  namespace,
  ...
}:
let
  inherit (lib) mkIf;
  inherit (lib.${namespace}) mkBoolOpt;

  cfg = config.${namespace}.services.mihomo;
in
{
  options.${namespace}.services.mihomo = {
    enable = mkBoolOpt false "Whether or not to enable mihomo.";
  };

  config = mkIf cfg.enable {
    services.mihomo = {
      enable = true;
      tunMode = true;
      package = pkgs.${namespace}.mihomo-alpha;
      configFile = config.age.secrets."mihomo.yaml".path;
      webui = pkgs.metacubexd;
    };

    systemd.services.mihomo.serviceConfig = {
      ExecStartPre = [
        "${pkgs.coreutils}/bin/ln -sf ${pkgs.v2ray-geoip}/share/v2ray/geoip.dat /var/lib/private/mihomo/GeoIP.dat"
        "${pkgs.coreutils}/bin/ln -sf ${pkgs.v2ray-domain-list-community}/share/v2ray/geosite.dat /var/lib/private/mihomo/GeoSite.dat"
      ];
      AmbientCapabilities = lib.mkForce "CAP_NET_ADMIN CAP_NET_RAW CAP_NET_BIND_SERVICE CAP_SYS_TIME CAP_SYS_PTRACE CAP_DAC_READ_SEARCH CAP_DAC_OVERRIDE";
      CapabilityBoundingSet = lib.mkForce "CAP_NET_ADMIN CAP_NET_RAW CAP_NET_BIND_SERVICE CAP_SYS_TIME CAP_SYS_PTRACE CAP_DAC_READ_SEARCH CAP_DAC_OVERRIDE";
    };

    networking.firewall.allowedTCPPorts = [ 9090 ];
  };
}
