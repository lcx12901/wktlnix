{ config, lib, ... }:
let
  inherit (lib) mkIf mkEnableOption;

  cfg = config.wktlnix.security.acme;

  domain = "${config.networking.hostName}.lincx.top";
in
{
  options.wktlnix.security.acme = {
    enable = mkEnableOption "default ACME configuration";
  };

  config = mkIf cfg.enable {
    security.acme = {
      acceptTerms = true;
      defaults.email = "wktl1991504424@gmail.com";
      certs.${domain} = {
        extraDomainNames = [ "*.${domain}" ];
        group = mkIf config.services.nginx.enable "nginx";
        dnsProvider = "cloudflare";
        environmentFile = config.sops.secrets."cloudflare-cert-api".path;
      };
    };

    environment.persistence."/persist" = {
      hideMounts = true;

      directories = [ "/var/lib/acme" ];
    };

    sops.secrets."cloudflare-cert-api" = { };
  };
}
