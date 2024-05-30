{
  config,
  lib,
  inputs,
  pkgs,
  namespace,
  ...
}: let
  inherit (lib) mkIf;
  inherit (lib.${namespace}) mkBoolOpt;

  cfg = config.${namespace}.services.mihomo;
in {
  options.${namespace}.services.mihomo = {
    enable = mkBoolOpt false "Whether or not to enable mihomo.";
  };

  config = mkIf cfg.enable {
    services.mihomo = {
      enable = true;
      tunMode = true;

      webui = inputs.metacubexd;

      configFile = config.age.secrets."mihomo.conf".path;
    };
  };
}