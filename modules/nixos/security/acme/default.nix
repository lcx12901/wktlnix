{
  config,
  lib,
  namespace,
  ...
}: let
  inherit (lib) mkIf;
  inherit (lib.${namespace}) mkBoolOpt;

  cfg = config.${namespace}.security.acme;

  domain = "${config.networking.hostName}.lincx.top";
in {
  options.${namespace}.security.acme = {
    enable = mkBoolOpt false "default ACME configuration";
  };

  config = mkIf cfg.enable {
    security.acme = {
      acceptTerms = true;
      defaults.email = "wktl1991504424@gmail.com";
      certs.${domain} = {
        domain = "*.nezuko.lincx.top";
        group = mkIf config.services.nginx.enable "nginx";
        dnsProvider = "cloudflare";
        dnsResolver = "1.1.1.1:53";
        credentialsFile = config.age.secrets."cloudflare.key".path;
      };
    };
  };
}
