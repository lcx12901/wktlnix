{
  config,
  lib,
  pkgs,
  namespace,
  ...
}: let
  inherit (lib) mkIf;
  inherit (lib.${namespace}) mkBoolOpt;

  cfg = config.${namespace}.services.nextcloud;
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
        dbtype = "pgsql";
        adminuser = "wktl";
        adminpassFile = config.age.secrets."nextcloud.pass".path;
      };

      settings = let
        prot = "https";
        host = "${config.networking.hostName}.lincx.top";
        dir = "/nextcloud";
      in {
        overwriteprotocol = prot;
        overwritehost = host;
        overwritewebroot = dir;
        overwrite.cli.url = "${prot}://${host}:302${dir}/";
        htaccess.RewriteBase = dir;
      };
    };
  };
}
