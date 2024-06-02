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

  cfg = config.${namespace}.services.dae;
in {
  options.${namespace}.services.dae = {
    enable = mkBoolOpt false "Whether or not to enable dae.";
  };

  config = mkIf cfg.enable {
    services.dae = {
      enable = true;
      configFile = config.age.secrets."config.dae".path;
    };
    
  };
}