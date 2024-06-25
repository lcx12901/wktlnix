{
  config,
  lib,
  namespace,
  ...
}: let
  inherit (lib) mkIf;
  inherit (lib.types) str;
  inherit (lib.${namespace}) mkBoolOpt mkOpt;

  cfg = config.${namespace}.services.cfdyndns;
in {
  options.${namespace}.services.cfdyndns = {
    enable = mkBoolOpt false "Whether or not to enable Cloudflare Dynamic DNS Client.";
    email = mkOpt str "wktl1991504424@gmail.com" "The email address to use to authenticate to CloudFlare.";
  };

  config = mkIf cfg.enable {
    services.cfdyndns = {
      inherit (cfg) enable email;

      apiTokenFile = config.age.secrets."cfAPI.conf".path;

      records = ["${config.networking.hostName}.lincx.top"];
    };
  };
}
