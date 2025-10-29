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

        # lsp servers
        nixd
        typescript-language-server
        vue-language-server
        emmet-language-server
        wktlnix.unocss-language-server

        # formatters
        nixfmt
        stylua
        eslint_d
      ];
      neovim = pkgs.neovim-nightly;
      hm-activation = true;
      backup = false;
    };

    home.persistence = lib.mkIf persist {
      "/persist/home/${config.wktlnix.user.name}" = {
        allowOther = true;
        directories = [ ".local/share/nvim" ];
      };
    };
  };
}
