{
  config,
  lib,
  pkgs,
  namespace,
  ...
}: let
  inherit (lib.${namespace}) mkIf;
  inherit (lib.${namespace}) mkBoolOpt;

  cfg = config.${namespace}.services.nextcloud.enable;
in {
  options.${namespace}.services.nextcloud = {
    enable = mkBoolOpt false "Whether or not to open nextcloud.";
  };

  config = mkIf cfg.enable {
    services.nextcloud = {
      enable = true;
      package = pkgs.nextcloud29;

      nginx.recommendedHttpHeaders = true;
      maxUploadSize = "4G";
      enableImagemagick = true;

      autoUpdateApps = {
        enable = true;
        startAt = "03:00";
      };

      config = {
        adminuser = "wktl";
        adminpassFile = config.age.secrets.nextcloud-secret.path;
      };
    };
  };
}
