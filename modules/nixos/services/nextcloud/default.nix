{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption;

  cfg = config.wktlnix.services.nextcloud;

  domain = "${config.networking.hostName}.lincx.top";
in
{
  options.wktlnix.services.nextcloud = {
    enable = mkEnableOption "Whether or not to enable Nextcloud.";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [ ffmpeg ];

    services.nextcloud = {
      enable = true;
      package = pkgs.nextcloud32;
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

      extraApps = {
        inherit (pkgs.nextcloud31Packages.apps) previewgenerator;
      };

      settings = {
        enable_previews = true;
        enabledPreviewProviders = [
          "OC\\Preview\\BMP"
          "OC\\Preview\\GIF"
          "OC\\Preview\\JPEG"
          "OC\\Preview\\Krita"
          "OC\\Preview\\MarkDown"
          "OC\\Preview\\MP3"
          "OC\\Preview\\OpenDocument"
          "OC\\Preview\\PNG"
          "OC\\Preview\\TXT"
          "OC\\Preview\\XBitmap"
          "OC\\Preview\\HEIC"
          "OC\\Preview\\Movie"
        ];
        preview_max_x = null;
        preview_max_y = null;
        preview_max_filesize_image = -1;
        preview_max_memory = -1;
      };

      phpOptions = {
        "opcache.interned_strings_buffer" = 16;
        "opcache.memory_consumption" = 256;
      };
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
