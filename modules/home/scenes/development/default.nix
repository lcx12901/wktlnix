{
  osConfig,
  config,
  lib,
  pkgs,
  namespace,
  ...
}:
let
  inherit (lib) mkIf;
  inherit (lib.${namespace}) mkBoolOpt enabled;

  homeDirectory = config.${namespace}.user.home;

  persist = osConfig.${namespace}.system.persist.enable;

  cfg = config.${namespace}.scenes.development;
in
{
  options.${namespace}.scenes.development = {
    enable = mkBoolOpt false "Whether or not to enable development configuration.";
    nodejsEnable = mkBoolOpt false "Whether or not to enable nodejs development configuration.";
  };

  config = mkIf cfg.enable {
    home = {
      packages =
        with pkgs;
        lib.optionals cfg.nodejsEnable [
          nodejs
          pnpm
          bun
        ];

      persistence = mkIf (persist && cfg.nodejsEnable) {
        "/persist/home/${config.${namespace}.user.name}" = {
          allowOther = true;
          directories = [ ".bun" ];
        };
      };
    };

    xdg.configFile = mkIf cfg.nodejsEnable {
      "pnpm/rc".text = ''
        cache-dir=${homeDirectory}/Coding/.pnpm-store/cache
        global-bin-dir=${homeDirectory}/Coding/.pnpm-store
        state-dir=${homeDirectory}/Coding/.pnpm-store/state
        global-dir=${homeDirectory}/Coding/.pnpm-store/global
      '';
    };

    wktlnix = {
      programs = {
        terminal = {
          tools = {
            btop = enabled;
            bat = enabled;
            colorls = enabled;
            git = enabled;
            lazygit = enabled;
            eza = enabled;
            direnv = enabled;
            jq = enabled;
            ripgrep = enabled;
            yazi = enabled;
          };
          editors.nvf = enabled;
        };
      };
    };
  };
}
