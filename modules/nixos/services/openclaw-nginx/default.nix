{ config, lib, ... }:
let
  inherit (lib) mkIf;
  inherit (lib.wktlnix) mkBoolOpt;

  cfg = config.wktlnix.services.openclaw-nginx;
  domain = config.networking.fqdn;
in
{
  options.wktlnix.services.openclaw-nginx = {
    enable = mkBoolOpt false "Whether to enable Nginx reverse proxy for OpenClaw.";
  };

  config = mkIf cfg.enable {
    services.nginx.virtualHosts = mkIf config.wktlnix.services.nginx.enable {
      "openclaw.${domain}" = {
        locations."/" = {
          proxyPass = "http://127.0.0.1:18789";
          proxyWebsockets = true;
          recommendedProxySettings = true;
          extraConfig = ''
            proxy_set_header Host $host;
            proxy_set_header X-Real-IP $remote_addr;
            proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
            proxy_set_header X-Forwarded-Proto $scheme;
          '';
        };
      };
    };
  };
}
