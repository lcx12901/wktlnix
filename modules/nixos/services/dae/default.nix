{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption;
  inherit (lib.wktlnix) mkOpt;

  cfg = config.wktlnix.services.dae;
in
{

  options.wktlnix.services.dae = {
    enable = mkEnableOption "Whether or not to enable dae.";
    openFirewall = mkEnableOption "Whether or not to open the dae port in the firewall.";
    extraNodes = mkOpt lib.types.str "" "extra nodes to add to the dae configuration.";
    extraGroups = mkOpt lib.types.str "" "extra groups to add to the dae configuration.";
    extraRules = mkOpt lib.types.str "" "extra routing rules to add to the dae configuration.";
  };

  config = mkIf cfg.enable {
    services.dae = {
      enable = true;

      openFirewall = {
        enable = cfg.openFirewall;
        port = 12345;
      };

      configFile = config.sops.templates."config.dae".path;

      package = pkgs.dae;
    };

    sops.secrets.dae_nodes = { };

    sops.templates."config.dae".content = ''
      global {
        lan_interface: waydroid0, virbr0, eno1, enp5s0
        wan_interface: auto

        log_level: info
        allow_insecure: false
        auto_config_kernel_parameter: false
        dial_mode: domain++
      }

      node {
        ${config.sops.placeholder.dae_nodes}
        ${cfg.extraNodes}
      }

      group {
        proxy {
          policy: random
          filter: name(milet)
        }

        ${cfg.extraGroups}
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
        pname(NetworkManager, aria2c, frpc, sing-box, inadyn) -> direct
        dip(224.0.0.0/3, 'ff00::/8') -> direct

        domain(ifconfig.me) -> direct

        ${cfg.extraRules}

        domain(geosite:category-ads) -> block

        domain(suffix:ota.waydro.id, suffix:sourceforge.net) -> proxy
        domain(suffix:duckduckgo.com) -> proxy
        domain(suffix:steamcommunity.com, suffix:steampowered.com, suffix:fastly.steamstatic.com, suffix:client-update.steamstatic.com) -> proxy
        domain(suffix:warframe.com) -> proxy

        dip(geoip:cn, geoip:private) -> direct
        domain(geosite:cn) -> direct
        domain(geosite:steam) -> direct

        fallback: proxy
      }
    '';
  };
}
