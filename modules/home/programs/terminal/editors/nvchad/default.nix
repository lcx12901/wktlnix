{
  osConfig,
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib.wktlnix) enabled;

  cfg = config.wktlnix.programs.terminal.editors.nvchad;

  persist = osConfig.wktlnix.system.persist.enable;
in
{
  options.wktlnix.programs.terminal.editors.nvchad = {
    enable = lib.mkEnableOption "nvchad";
  };

  config = lib.mkIf cfg.enable {
    home.sessionVariables = {
      EDITOR = "nvim";
    };

    wktlnix.programs.terminal.tools.fzf = enabled;

    programs.nvchad = {
      enable = true;
      extraPackages = with pkgs; [
        wl-clipboard
        wakatime-cli

        # lsp servers
        nixd
        bash-language-server
        yaml-language-server
        typescript-language-server
        vue-language-server
        emmet-language-server
        wktlnix.unocss-language-server
        vscode-langservers-extracted

        # formatters
        nixfmt
        stylua

        # linters
        statix
        deadnix
        eslint_d

        # need by avante.nvim
        gnumake
        imagemagick
      ];
      neovim = pkgs.neovim-nightly;
      hm-activation = true;
      backup = false;

      extraConfig = ''
        vim.g.sqlite_clib_path = "${pkgs.sqlite.out}/lib/libsqlite3${pkgs.stdenv.hostPlatform.extensions.sharedLibrary}"
      '';
    };

    home.persistence = lib.mkIf persist {
      "/persist/home/${config.wktlnix.user.name}" = {
        allowOther = true;
        directories = [
          ".local/share/nvim"
          ".local/state/nvim"
        ];
      };
    };

    sops.secrets = {
      wakatime = {
        path = "${config.home.homeDirectory}/.wakatime.cfg";
      };
    };
  };
}
