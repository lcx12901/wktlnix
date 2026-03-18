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
        wktlnix.unocss-language-server

        # formatters
        nixfmt
        statix
        deadnix
        stylua
        eslint_d

        tree-sitter
      ];
      neovim = pkgs.neovim-nightly;
      hm-activation = true;
      backup = false;
    };

    home.persistence = lib.mkIf persist {
      "/persist" = {
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
