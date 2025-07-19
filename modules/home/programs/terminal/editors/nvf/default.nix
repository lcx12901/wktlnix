{
  osConfig,
  config,
  lib,
  namespace,
  ...
}:
let
  cfg = config.${namespace}.programs.terminal.editors.nvf;

  persist = osConfig.${namespace}.system.persist.enable;
in
{
  imports = lib.snowfall.fs.get-non-default-nix-files-recursive ./.;

  options.${namespace}.programs.terminal.editors.nvf = {
    enable = lib.mkEnableOption "nvf";
  };

  config = lib.mkIf cfg.enable {
    programs.nvf = {
      enable = true;

      settings = {
        vim = {
          viAlias = false;
          vimAlias = true;

          lazy.enable = true;

          ui.borders.enable = true;

          autopairs.nvim-autopairs = {
            enable = true;

            setupOpts = {
              check_ts = true;
              highlight = "PmenuSel";
              highlight_grey = "LineNr";
            };
          };
        };
      };
    };

    home.persistence = lib.mkIf persist {
      "/persist/home/${config.${namespace}.user.name}" = {
        allowOther = true;
        directories = [ ".local/share/nvf" ];
      };
    };
  };
}
