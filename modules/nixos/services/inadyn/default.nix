{
  config,
  lib,
  namespace,
  ...
}:
let
  cfg = config.${namespace}.services.inadyn;
in
{
  options.${namespace}.services.inadyn = {
    enable = lib.${namespace}.mkBoolOpt false "Whether or not to configure inadyn for ddns.";
    configFile = lib.${namespace}.mkOpt lib.types.path "" "path to singularity config";
  };
  # check ipv6 address: https://dns64.cloudflare-dns.com/cdn-cgi/trace
  config = lib.mkIf cfg.enable {
    services.inadyn = {
      inherit (cfg) configFile;

      enable = true;
    };
  };
}
