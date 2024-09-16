{
  config,
  lib,
  pkgs,
  namespace,
  ...
}: let
  inherit (config.networking) hostName;

  cfg = config.${namespace}.services.nginx;

  hasMyContainer = containerName: lib.hasAttr containerName config.virtualisation.oci-containers.containers;
in {
  options.${namespace}.services.nginx = {
    enable = lib.${namespace}.mkBoolOpt false "Whether or not to enable nginx.";
  };

  config = lib.mkIf cfg.enable {
    users.users.nginx.extraGroups = ["acme"];

    services.nginx = {
      enable = true;

      package = pkgs.nginxQuic.override {withKTLS = true;};

      defaultHTTPListenPort = 404;
      defaultSSLListenPort = 302;

      # Use recommended settings
      recommendedTlsSettings = true;
      recommendedBrotliSettings = true;
      recommendedOptimisation = true;
      recommendedGzipSettings = true;
      recommendedProxySettings = true;
      recommendedZstdSettings = true;

      clientMaxBodySize = lib.mkDefault "512m";
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
      virtualHosts = {
        "${hostName}.lincx.top" = {
          forceSSL = true;
          sslCertificate = "/var/lib/acme/${hostName}.lincx.top/cert.pem";
          sslCertificateKey = "/var/lib/acme/${hostName}.lincx.top/key.pem";

          locations = lib.mkMerge [
            (lib.mkIf config.services.aria2.enable {
              "/aria2/".proxyPass = "http://127.0.0.1:6800/";
            })
            (lib.mkIf (hasMyContainer "ariang") {
              "/ariang/".proxyPass = "http://127.0.0.1:6880/";
            })
          ];
        };
      };
    };

    networking.firewall.allowedTCPPorts = [302];
  };
}
