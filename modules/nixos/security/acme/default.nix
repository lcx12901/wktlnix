{
  config,
  lib,
  namespace,
  ...
}: let
  inherit (lib) mkIf;
  inherit (lib.${namespace}) mkBoolOpt;

  cfg = config.${namespace}.security.acme;
in {
  options.${namespace}.security.acme = {
    enable = mkBoolOpt false "default ACME configuration";
  };

  config = mkIf cfg.enable {
    security.acme = {
      acceptTerms = true;
      defaults.email = "wktl1991504424@gmail.com";
    };
  };
}
