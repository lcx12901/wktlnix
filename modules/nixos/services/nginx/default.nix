{
  config,
  lib,
  pkgs,
  namespace,
  ...
}: let
  inherit (lib) mkIf mkDefault;
  inherit (lib.${namespace}) mkBoolOpt hasContainer;

  inherit (config.networking) hostName;

  hasMyContainer = containerName: lib.hasAttr containerName config.virtualisation.oci-containers.containers;

  cfg = config.${namespace}.services.nginx;
in {
  options.${namespace}.services.nginx = {
    enable = mkBoolOpt false "Whether or not to enable nginx.";
  };

  config = mkIf cfg.enable {
    services.nginx = {
      enable = true;
      package = pkgs.nginxQuic.override {withKTLS = true;};

      defaultSSLListenPort = 302;

      recommendedTlsSettings = true;
      recommendedBrotliSettings = true;
      recommendedOptimisation = true;
      recommendedGzipSettings = true;
      recommendedProxySettings = true;
      recommendedZstdSettings = true;

      clientMaxBodySize = mkDefault "512m";
      serverNamesHashBucketSize = 1024;

      appendHttpConfig = ''
        # set the maximum size of the headers hash tables to 1024 bytes
        # this applies to the total size of all headers in a client request
        # or a server response.
        proxy_headers_hash_max_size 1024;

        # set the bucket size for the headers hash tables to 256 bytes
        #  bucket size determines how many entries can be stored in
        # each hash table bucket
        proxy_headers_hash_bucket_size 256;
      '';

      # lets be more picky on our ciphers and protocols
      sslCiphers = "EECDH+aRSA+AESGCM:EDH+aRSA:EECDH+aRSA:+AES256:+AES128:+SHA1:!CAMELLIA:!SEED:!3DES:!DES:!RC4:!eNULL";
      sslProtocols = "TLSv1.3 TLSv1.2";

      virtualHosts = {
        "${hostName}" = {
          forceSSL = true;
          sslCertificate = "/etc/lincx.top/nezuko.pem";
          sslCertificateKey = "/etc/lincx.top/nezuko.key";

          locations."/ddns" = mkIf (hasMyContainer "ddns-go") {
            proxyPass = "http://127.0.0.1:9876";
          };
        };
      };
    };

    systemd.services.nginx.serviceConfig.ExecStartPre = ''
      cp ${config.age.secrets."nezuko.pem".path} /etc/lincx.top/nezuko.pem
      cp ${config.age.secrets."nezuko.key".path} /etc/lincx.top/nezuko.key
      chown nginx:nginx /etc/lincx.top/nezuko.key /etc/lincx.top/nezuko.key
      chmod 640 /etc/lincx.top/nezuko.pem /etc/lincx.top/nezuko.key
    '';

    networking.firewall.allowedTCPPorts = [302];
  };
}
