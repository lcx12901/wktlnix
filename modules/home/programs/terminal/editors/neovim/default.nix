{
  osConfig,
  config,
  lib,
  pkgs,
  namespace,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf;

  cfg = config.${namespace}.programs.terminal.editors.neovim;

  persist = osConfig.${namespace}.system.persist.enable;
in
{
  options.${namespace}.programs.terminal.editors.neovim = {
    enable = mkEnableOption "neovim";
  };

  config = mkIf cfg.enable {
    home = {
      sessionVariables = {
        EDITOR = "nvim";
      };

      packages = [
        pkgs.neovide
        (pkgs.${namespace}.wktlvim.extend {
          plugins.codeium-nvim.settings = {
            config_path = "${osConfig.age.secrets."codeium.config".path}";
          };
        })
      ];

      persistence = mkIf persist {
        "/persist/home/${config.${namespace}.user.name}" = {
          allowOther = true;
          files = [ ".local/cache/nvim/codeium/config.json" ];
          directories = [ ".local/share/nvim" ];
        };
      };
    };
  };
}
