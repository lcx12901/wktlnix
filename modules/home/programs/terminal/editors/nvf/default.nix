{
  osConfig,
  config,
  lib,
  ...
}:
let
  cfg = config.wktlnix.programs.terminal.editors.nvf;

  persist = osConfig.wktlnix.system.persist.enable;
in
{
  imports = lib.file.get-non-default-nix-files-recursive ./.;

  options.wktlnix.programs.terminal.editors.nvf = {
    enable = lib.mkEnableOption "nvf";
  };

  config = lib.mkIf cfg.enable {
    home.sessionVariables = {
      EDITOR = "nvim";
    };

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

          treesitter = {
            enable = true;
            autotagHtml = true;
            context.enable = true;
            textobjects.enable = true;
          };

          notes.todo-comments.enable = true;

          utility = {
            nix-develop.enable = true;
            vim-wakatime.enable = true;
          };

          visuals.rainbow-delimiters.enable = true;
        };
      };
    };

    home.persistence = lib.mkIf persist {
      "/persist/home/${config.wktlnix.user.name}" = {
        allowOther = true;
        directories = [ ".local/share/nvf" ];
      };
    };

    sops.secrets = {
      wakatime = {
        path = "${config.home.homeDirectory}/.wakatime.cfg";
      };
    };
  };
}
