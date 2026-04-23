{
  osConfig,
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.wktlnix.programs.terminal.editors.nvchad;

  persist = osConfig.wktlnix.system.persist.enable;
in
{
  options.wktlnix.programs.terminal.editors.nvchad = {
    enable = lib.mkEnableOption "nvchad";
  };

  config = lib.mkIf cfg.enable {
    programs.nvchad = {
      enable = true;
      extraPackages = with pkgs; [
        wl-clipboard
        wakatime-cli

        # lsp servers
        nixd
        vscode-langservers-extracted
        typescript-language-server
        vue-language-server
        emmet-language-server
        bash-language-server
        prisma-language-server
        cargo
        clippy
        rust-analyzer
        rustc
        marksman
        wktlnix.unocss-language-server
        yaml-language-server

        # formatters
        nixfmt
        statix
        deadnix
        stylua
        rustfmt
        eslint_d
        deno
      ];
      neovim = pkgs.neovim-nightly;
      hm-activation = true;
      backup = false;
    };

    home = {
      sessionVariables = {
        EDITOR = "nvim";
        MANPAGER = "nvim -c 'set ft=man bt=nowrite noswapfile nobk shada=\\\"NONE\\\" ro noma' +Man! -o -";
      };

      persistence = lib.mkIf persist {
        "/persist" = {
          directories = [
            ".local/share/nvim"
            ".local/state/nvim"
          ];
        };
      };
    };

    sops.secrets =
      let
        dir = config.home.homeDirectory;
      in
      {
        wakatime = {
          path = "${dir}/.wakatime.cfg";
        };
      };
  };
}
