{
  config,
  lib,
  namespace,
  ...
}: let
  inherit (lib) mkIf;
  inherit (lib.${namespace}) mkBoolOpt;

  cfg = config.${namespace}.services.cfdyndns;
in {
  options.${namespace}.services.cfdyndns = {
    enable = mkBoolOpt false "Whether or not to enable Cloudflare Dynamic DNS Client.";
  };

  config = mkIf cfg.enable {
    services.cloudflare-dyndns = {
      inherit (cfg) enable;

      apiTokenFile = config.age.secrets."cfAPI.conf".path;

      domains = ["${config.networking.hostName}.lincx.top"];

      ipv4 = false;
      ipv6 = true;
    };
  };
}
