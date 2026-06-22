{ config, lib, ... }:
let
  inherit (lib) mkIf mkEnableOption;

  cfg = config.wktlnix.services.obsidian-livesync;

  domain = "obsidian.${config.networking.fqdn}";
in
{
  options.wktlnix.services.obsidian-livesync = {
    enable = mkEnableOption "Self-hosted Obsidian LiveSync (CouchDB backend).";

  };

  config = mkIf cfg.enable {
    services.couchdb = {
      enable = true;

      extraConfigFiles = [ config.sops.secrets."obsidian-livesync/adminpass".path ];

      extraConfig = {
        couchdb = {
          single_node = true;
          max_document_size = 50000000;
        };
        chttpd = {
          require_valid_user = true;
          max_http_request_size = 4294967296;
          enable_cors = true;
          bind_address = "127.0.0.1";
        };
        cors = {
          origins = "app://obsidian.md, capacitor://localhost, http://localhost, https://obsidian.emilia.wktl.de";
          credentials = true;
          headers = "accept, authorization, content-type, origin, referer";
          methods = "GET,PUT,POST,HEAD,DELETE";
          max_age = 3600;
        };
      };
    };

    services.nginx = {
      enable = true;

      virtualHosts.${domain} = {
        locations."/" = {
          proxyPass = "http://127.0.0.1:${toString config.services.couchdb.port}";
          extraConfig = ''
            proxy_set_header Host $host;
            proxy_set_header X-Real-IP $remote_addr;
            proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
            proxy_set_header X-Forwarded-Proto $scheme;

            # LiveSync needs large bodies for big journals
            client_max_body_size 4G;

            # Timeout settings for long sync operations
            proxy_read_timeout 300s;
            proxy_send_timeout 300s;
          '';
        };
      };
    };

    sops.secrets = {
      "obsidian-livesync/adminpass" = {
        sopsFile = lib.file.get-file "secrets/obsidian.yaml";
        owner = "couchdb";
        mode = "0440";
      };
    };

    environment.persistence."/persist" = {
      hideMounts = true;

      directories = [
        "/var/lib/couchdb"
      ];
    };
  };
}
