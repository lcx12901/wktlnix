{
  config,
  lib,
  pkgs,
  namespace,
  ...
}: let
  inherit (lib) mkIf mkDefault mkMerge;
  inherit (lib.${namespace}) mkBoolOpt;

  inherit (config.networking) hostName;

  hasMyContainer = containerName: lib.hasAttr containerName config.virtualisation.oci-containers.containers;

  cfg = config.${namespace}.services.nginx;
in {
  options.${namespace}.services.nginx = {
    enable = mkBoolOpt false "Whether or not to enable nginx.";
  };

  config = mkIf cfg.enable {
    users.users.nginx.extraGroups = ["acme"];

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
        "${hostName}.lincx.top" = {
          forceSSL = true;
          sslCertificate = "/var/lib/acme/${hostName}.lincx.top/cert.pem";
          sslCertificateKey = "/var/lib/acme/${hostName}.lincx.top/key.pem";

          listen = [
            {
              addr = "127.0.0.1";
              port = 8080;
            }
          ];

          location = mkMerge [
            (mkIf (hasMyContainer "ddns-go") {
              "/ddns/".proxyPass = "http://127.0.0.1:9876/";
            })
            (mkIf (hasMyContainer "aria2-pro") {
              "/aria2/".proxyPass = "http://127.0.0.1:6800/";
            })
            (mkIf (hasMyContainer "ariang") {
              "/ariang/".proxyPass = "http://127.0.0.1:6880/";
            })
            (mkIf config.services.nextcloud {
              "/nextcloud/" = {
                priority = 9999;
                proxyPass = "http://127.0.0.1:8080/";
              };
              "^~ /.well-known" = {
                priority = 9000;
                extraConfig = ''
                  absolute_redirect off;
                  location ~ ^/\\.well-known/(?:carddav|caldav)$ {
                    return 301 /nextcloud/remote.php/dav;
                  }
                  location ~ ^/\\.well-known/host-meta(?:\\.json)?$ {
                    return 301 /nextcloud/public.php?service=host-meta-json;
                  }
                  location ~ ^/\\.well-known/(?!acme-challenge|pki-validation) {
                    return 301 /nextcloud/index.php$request_uri;
                  }
                  try_files $uri $uri/ =404;
                '';
              };
            })
          ];
        };
      };
    };

    networking.firewall.allowedTCPPorts = [302];
  };
}
