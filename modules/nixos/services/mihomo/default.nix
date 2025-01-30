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

  mihomoConfig = import ./config.nix;

  format = pkgs.formats.yaml { };
  configFile = format.generate "config.yaml" mihomoConfig;

  sopsFile = lib.snowfall.fs.get-file "secrets/default.yaml";

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
      configFile = config.sops.templates."config.yaml".path;
      webui = pkgs.metacubexd;
    };

    systemd.services.mihomo.serviceConfig = {
      ExecStartPre = [
        "${pkgs.coreutils}/bin/ln -sf ${
          pkgs.${namespace}.v2ray-rules-dat
        }/share/geoip.dat /var/lib/private/mihomo/GeoIP.dat"
        "${pkgs.coreutils}/bin/ln -sf ${
          pkgs.${namespace}.v2ray-rules-dat
        }/share/geosite.dat /var/lib/private/mihomo/GeoSite.dat"
        "${pkgs.coreutils}/bin/ln -sf ${config.sops.secrets.mihomo_nodes.path} /var/lib/private/mihomo/nodes.yaml"
        "${pkgs.coreutils}/bin/ln -sf ${configFile} /var/lib/private/mihomo/text.yaml"
      ];
      AmbientCapabilities = lib.mkForce "CAP_NET_ADMIN CAP_NET_RAW CAP_NET_BIND_SERVICE CAP_SYS_TIME CAP_SYS_PTRACE CAP_DAC_READ_SEARCH CAP_DAC_OVERRIDE";
      CapabilityBoundingSet = lib.mkForce "CAP_NET_ADMIN CAP_NET_RAW CAP_NET_BIND_SERVICE CAP_SYS_TIME CAP_SYS_PTRACE CAP_DAC_READ_SEARCH CAP_DAC_OVERRIDE";
    };

    networking.firewall.allowedTCPPorts = [ 9090 ];

    sops.secrets = {
      "mihomo_nodes" = {
        inherit sopsFile;
      };
      "mihomo_secret" = {
        inherit sopsFile;
      };
    };

    sops.templates."config.yaml".content = ''
      secret: ${config.sops.placeholder.mihomo_secret}
      ${builtins.readFile configFile}
    '';
  };
}
