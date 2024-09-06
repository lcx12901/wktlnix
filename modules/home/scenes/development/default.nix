{
  osConfig,
  config,
  lib,
  pkgs,
  namespace,
  ...
}: let
  inherit (lib) mkIf;
  inherit (lib.${namespace}) mkBoolOpt enabled;

  homeDirectory = config.${namespace}.user.home;

  persist = osConfig.${namespace}.system.persist.enable;

  cfg = config.${namespace}.scenes.development;
in {
  options.${namespace}.scenes.development = {
    enable = mkBoolOpt false "Whether or not to enable development configuration.";
  };

  config = mkIf cfg.enable {
    home = {
      packages = with pkgs; [
        nodejs_20
        yarn
        pnpm
        bun
      ];

      persistence = mkIf persist {
        "/persist/home/${config.${namespace}.user.name}" = {
          allowOther = true;
          directories = [".bun"];
        };
      };
    };

    nixpkgs.config = {
      programs.npm.npmrc = ''
        prefix = ${homeDirectory}/Coding/.npm-global
      '';
    };

    xdg.configFile = {
      "pnpm/rc".text = ''
        cache-dir=${homeDirectory}/Coding/.pnpm-store/cache
        global-bin-dir=${homeDirectory}/Coding/.pnpm-store
        state-dir=${homeDirectory}/Coding/.pnpm-store/state
        global-dir=${homeDirectory}/Coding/.pnpm-store/global
      '';

      ".bunfig.toml".text = ''
        [install]
        # where `bun install --global` installs packages
        globalDir = "~/.bun/install/global"

        # where globally-installed package bins are linked
        globalBinDir = "~/.bun/bin"

        [install.cache]
        # the directory to use for the cache
        dir = "~/.bun/install/cache"

        # when true, don't load from the global cache.
        # Bun may still write to node_modules/.cache
        disable = false

        # when true, always resolve the latest versions from the registry
        disableManifest = false
      '';
    };

    wktlnix = {
      programs = {
        terminal = {
          tools.lazygit = enabled;
          # editors.neovim = enabled;
        };
      };
    };
  };
}
