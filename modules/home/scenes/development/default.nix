{
  osConfig,
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption;
  inherit (lib.wktlnix) enabled;

  homeDirectory = config.wktlnix.user.home;

  persist = osConfig.wktlnix.system.persist.enable;

  cfg = config.wktlnix.scenes.development;
in
{
  options.wktlnix.scenes.development = {
    enable = mkEnableOption "Whether or not to enable development configuration.";
    nodejsEnable = mkEnableOption "Whether or not to enable nodejs development configuration.";
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
        "/persist" = {
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
            oh-my-posh = enabled;
            ripgrep = enabled;
            yazi = enabled;
          };
        };
      };
    };
  };
}
