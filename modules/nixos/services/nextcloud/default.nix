{
  config,
  lib,
  pkgs,
  namespace,
  ...
}:
let
  cfg = config.${namespace}.services.nextcloud;

  domain = "${config.networking.hostName}.lincx.top";
in
{
  options.${namespace}.services.nextcloud = {
    enable = lib.mkEnableOption "Whether or not to enable Nextcloud.";
  };

  config = lib.mkIf cfg.enable {
    services.nextcloud = {
      enable = true;
      package = pkgs.nextcloud31;
      https = true;
      hostName = "nextcloud.${domain}";

      config = {
        adminuser = "lincx";
        adminpassFile = config.sops.secrets."nextcloud_adminpass".path;

        dbtype = "pgsql";
      };

      maxUploadSize = "4G";
      database.createLocally = true;
      configureRedis = true;
    };

    sops.secrets = {
      "nextcloud_adminpass" = { };
    };

    environment.persistence."/persist" = {
      hideMounts = true;

      directories = [
        "/var/lib/nextcloud"
        "/var/lib/postgresql"
        "/var/lib/redis-nextcloud"
      ];
    };
  };
}
