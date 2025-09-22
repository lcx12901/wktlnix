{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib)
    mkIf
    mkEnableOption
    mkOption
    mkDefault
    ;
  inherit (lib.types) submodule attrsOf anything;

  cfg = config.wktlnix.services.nginx;

  domain = "${config.networking.hostName}.lincx.top";
in
{
  options.services.nginx.virtualHosts = mkOption {
    type = attrsOf (
      submodule (_: {
        freeformType = attrsOf anything;

        config = {
          quic = mkDefault true;
          forceSSL = mkDefault true;
          enableACME = mkDefault false;
          useACMEHost = mkDefault domain;
        };
      })
    );
  };

  options.wktlnix.services.nginx = {
    enable = mkEnableOption "Whether or not to enable nginx.";
  };

  config = mkIf cfg.enable {
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
