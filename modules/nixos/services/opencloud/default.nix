{ config, lib, ... }:
let
  inherit (lib) mkIf mkEnableOption;

  cfg = config.wktlnix.services.opencloud;

  domain = config.networking.fqdn;
in
{
  options.wktlnix.services.opencloud = {
    enable = mkEnableOption "Whether or not to enable OpenCloud.";
  };

  config = mkIf cfg.enable {
    services.opencloud = {
      enable = true;
      url = "https://cloud.${domain}:12901";

      environment = {
        OC_INSECURE = "true"; # allow http internally behind reverse-proxy
        PROXY_TLS = "false"; # disable https when behind reverse-proxy
      };

      environmentFile = config.sops.templates."opencloud-env".path;

      settings = {
        default_language = "zh-CN";
      };
    };

    services.nginx.virtualHosts."cloud.${domain}" = {
      locations."/" = {
        proxyPass = "http://127.0.0.1:9200";
        proxyWebsockets = true;

        recommendedProxySettings = false;
        extraConfig = ''
          proxy_set_header Host $host:$server_port;
          proxy_set_header X-Real-IP $remote_addr;
          proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
          proxy_set_header X-Forwarded-Proto $scheme;
          proxy_set_header X-Forwarded-Host $host;
          proxy_set_header X-Forwarded-Server $hostname;
        '';
      };
    };

    environment.persistence."/persist" = {
      hideMounts = true;

      directories = [
        "/var/lib/opencloud"
      ];
    };

    sops = {
      secrets."opencloud_adminpass" = { };

      templates."opencloud-env" = {
        content = ''
          IDM_ADMIN_PASSWORD=${config.sops.placeholder."opencloud_adminpass"}
        '';
      };
    };
  };
}
