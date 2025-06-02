{
  config,
  lib,
  namespace,
  ...
}:
let
  inherit (lib) mkIf;
  inherit (lib.${namespace}) mkBoolOpt;

  cfg = config.${namespace}.programs.graphical.browsers.chromium;
in
{
  options.${namespace}.programs.graphical.browsers.chromium = {
    enable = mkBoolOpt false "Whether or not to enable chromium.";
  };

  config = mkIf cfg.enable {

    programs.chromium = {
      enable = true;
    };
  };
}
