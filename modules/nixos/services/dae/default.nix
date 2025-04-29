{
  inputs,
  config,
  lib,
  system,
  namespace,
  ...
}:
let
  inherit (lib.${namespace}) mkBoolOpt;

  cfg = config.${namespace}.services.dae;
in
{

  options.${namespace}.services.dae = {
    enable = mkBoolOpt false "Whether or not to enable dae.";
  };

  config = lib.mkIf cfg.enable {
    services.dae = {
      enable = true;

      openFirewall = {
        enable = true;
        port = 12345;
      };

      configFile = config.sops.templates."config.dae".path;

      package = inputs.daeuniverse.packages.${system}.dae-unstable;
    };

    sops.secrets.dae_nodes = { };

    sops.templates."config.dae".content = ''
      global {
        lan_interface: waydroid0
        wan_interface: auto

        log_level: info
        allow_insecure: false
        auto_config_kernel_parameter: false
      }

      node {
        ${config.sops.placeholder.dae_nodes}
      }

      group {
        proxy {
          policy: random
        }
      }

      dns {
        upstream {
          googledns: 'tcp+udp://dns.google.com:53'
          alidns: 'udp://dns.alidns.com:53'
        }
        routing {
          request {
            qname(geosite:category-ads-all) -> reject
            fallback: alidns
          }
          response {
            upstream(googledns) -> accept
            ip(geoip:private) && !qname(geosite:cn) -> googledns
            fallback: accept
          }
        }
      }

      routing {
        pname(NetworkManager) -> direct
        dip(224.0.0.0/3, 'ff00::/8') -> direct

        domain(geosite: category-ads) -> block

        domain(suffix: ota.waydro.id, suffix: sourceforge.net) -> proxy
        domain(suffix:duckduckgo.com) -> proxy
        domain(suffix: steamcommunity.com, suffix: steampowered.com, suffix: fastly.steamstatic.com, suffix: client-update.steamstatic.com) -> proxy
        domain(suffix: warframe.com) -> proxy

        dip(geoip:cn, geoip:private) -> direct
        domain(geosite:cn) -> direct
        domain(geosite: steam) -> direct

        fallback: proxy
      }
    '';
  };
}
