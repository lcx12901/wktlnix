{
  config,
  lib,
  pkgs,
  namespace,
  ...
}: let
  inherit (lib) mkIf;
  inherit (lib.${namespace}) mkBoolOpt;

  cfg = config.${namespace}.scenes.development;
in {
  options.${namespace}.scenes.development = {
    enable = mkBoolOpt false "Whether or not to enable development configuration.";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      nodejs_20
      yarn
      pnpm
    ];
  };
}
