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

    nixpkgs.config = mkIf cfg.nodejsEnable {
      programs.npm.npmrc = ''
        prefix = ${homeDirectory}/Coding/.npm-global
      '';
    };

    xdg.configFile = mkIf cfg.nodejsEnable {
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
          tools = {
            btop = enabled;
            bat = enabled;
            colorls = enabled;
            git = enabled;
            lazygit = enabled;
            eza = enabled;
            direnv = enabled;
            ripgrep = enabled;
            yazi = enabled;
            zellij = enabled;
          };
          editors.neovim = enabled;
        };
      };
    };

    home.shellAliases = {
      du = "${pkgs.ncdu}/bin/ncdu --color dark -rr -x";
      nsn = "nix shell nixpkgs#";
      nsw = "sudo nixos-rebuild switch --flake .#${osConfig.networking.hostName}";
      nfu = "nix flake update";
    };
  };
}
