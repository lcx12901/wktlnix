{
  config,
  lib,
  pkgs,
  namespace,
  ...
}:
let
  inherit (lib) types mkOption mkDefault;

  cfg = config.${namespace}.services.nginx;

  domain = "${config.networking.hostName}.lincx.top";
in
{
  options.services.nginx.virtualHosts = mkOption {
    type = types.attrsOf (
      types.submodule (
        { ... }:
        {
          freeformType = types.attrsOf types.anything;

          config = {
            quic = mkDefault true;
            forceSSL = mkDefault true;
            enableACME = mkDefault false;
            useACMEHost = mkDefault domain;
          };
        }
      )
    );
  };

  options.${namespace}.services.nginx = {
    enable = lib.${namespace}.mkBoolOpt false "Whether or not to enable nginx.";
  };

  config = lib.mkIf cfg.enable {
    users.users.nginx.extraGroups = [ "acme" ];

    services.nginx = {
      enable = true;

      package = pkgs.nginxQuic.override { withKTLS = true; };

      defaultSSLListenPort = 12901;

      commonHttpConfig = ''
        add_header 'Referrer-Policy' 'origin-when-cross-origin';
        add_header X-Frame-Options "SAMEORIGIN" always;
        add_header X-Content-Type-Options nosniff;
      '';

      recommendedTlsSettings = true;
      recommendedBrotliSettings = true;
      recommendedOptimisation = true;
      recommendedGzipSettings = true;
      recommendedProxySettings = true;

      experimentalZstdSettings = true;

      sslCiphers = "EECDH+aRSA+AESGCM:EDH+aRSA:EECDH+aRSA:+AES256:+AES128:+SHA1:!CAMELLIA:!SEED:!3DES:!DES:!RC4:!eNULL";
      sslProtocols = "TLSv1.3 TLSv1.2";
    };

    networking.firewall.allowedTCPPorts = [
      80
      12901
    ];
  };
}
