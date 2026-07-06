{
  inputs,
  osConfig,
  config,
  system,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib.types) attrs;
  inherit (lib.wktlnix) mkOpt;

  cfg = config.wktlnix.programs.terminal.editors.neovim;

  wktlvimConfiguration = inputs.wktlvim.nixvimConfigurations.${system}.wktlvim.extendModules {
    modules = [ cfg.extendConfig ];
  };
  wktlvim = wktlvimConfiguration.config.build.package;

  persist = osConfig.wktlnix.system.persist.enable;

in
{
  options.wktlnix.programs.terminal.editors.neovim = {
    enable = lib.mkEnableOption "neovim";
    extendConfig = mkOpt attrs { } "extend the neovim configuration.";
  };

  config = lib.mkIf cfg.enable {
    home = {
      sessionVariables = {
        EDITOR = "nvim";
        MANPAGER = "nvim -c 'set ft=man bt=nowrite noswapfile nobk shada=\\\"NONE\\\" ro noma' +Man! -o -";
      };

      packages = [
        wktlvim
        pkgs.wakatime-cli
        pkgs.nvrh
        pkgs.neovide
      ];

      persistence = lib.mkIf persist {
        "/persist" = {
          directories = [
            ".local/share/nvim"
            ".local/state/nvim"
            ".local/cache/nvim"
          ];
        };
      };
    };
  };
}
