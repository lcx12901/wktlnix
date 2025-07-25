{
  lib,
  pkgs,
  namespace,
  ...
}:
{
  programs.nvf.settings = {
    vim = {
      treesitter = {
        enable = true;
        grammars = with pkgs.vimPlugins.nvim-treesitter.builtGrammars; [
          css
          scss
        ];
      };

      lsp.servers.unocss = {
        enable = true;

        cmd = [
          "${lib.getExe pkgs.${namespace}.unocss-language-server}"
          "--stdio"
        ];
      };
    };
  };
}
