{
  config,
  lib,
  ...
}:
let
  cfg = config.wktlnix.services.jellyfin;

  domain = "${config.networking.hostName}.lincx.top";

  inherit (lib) mkIf mkEnableOption;
in
{
  options.wktlnix.services.jellyfin = {
    enable = mkEnableOption "jellyfin";
  };

  config = mkIf cfg.enable {
    services = {
      jellyfin = {
        enable = true;
        user = config.wktlnix.user.name;
      };

      nginx.virtualHosts."jellyfin.${domain}" = {
        locations = {
          "/" = {
            proxyPass = "http://localhost:8096";
            extraConfig = ''
              # Disable buffering when the nginx proxy gets very resource heavy upon streaming
              proxy_buffering off;
            '';
          };
          "/socket" = {
            proxyPass = "http://localhost:8096";
            extraConfig = ''
              proxy_http_version 1.1;
              proxy_set_header Upgrade $http_upgrade;
              proxy_set_header Connection "Upgrade";
            '';
          };
        };
      };
    };

    environment.persistence."/persist" = {
      hideMounts = true;

      directories = [
        config.services.jellyfin.dataDir
      ];
    };
  };
}
