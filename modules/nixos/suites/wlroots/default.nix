{
  config,
  inputs,
  lib,
  namespace,
  ...
}:
let
  inherit (lib) mkIf;
  inherit (lib.${namespace}) mkBoolOpt;

  cfg = config.${namespace}.suites.wlroots;
in
{
  options.${namespace}.suites.wlroots = {
    enable = mkBoolOpt false "Whether or not to enable common wlroots configuration.";
  };

  config = mkIf cfg.enable {
    programs = {
      xwayland.enable = true;
    };
  };
}