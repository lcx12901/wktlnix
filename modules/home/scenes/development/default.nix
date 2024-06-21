{
  config,
  lib,
  pkgs,
  namespace,
  ...
}: let
  inherit (lib) mkIf;
  inherit (lib.${namespace}) mkBoolOpt;

  homeDirectory = config.${namespace}.user.home;

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

    nixpkgs.config = {
      programs.npm.npmrc = ''
        prefix = ${homeDirectory}/Coding/.npm-global
      '';
    };

    xdg.configFile."pnpm/rc".text = ''
      cache-dir=${homeDirectory}/Coding/.pnpm-store/cache
      global-bin-dir=${homeDirectory}/Coding/.pnpm-store
      state-dir=${homeDirectory}/Coding/.pnpm-store/state
      global-dir=${homeDirectory}/Coding/.pnpm-store/global
    '';
  };
}
