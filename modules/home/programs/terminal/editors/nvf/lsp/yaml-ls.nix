{ lib, pkgs, ... }:
let
  inherit (lib.generators) mkLuaInline;
in
{
  programs.nvf.settings = {
    vim = {
      treesitter = {
        enable = true;
        grammars = with pkgs.vimPlugins.nvim-treesitter.builtGrammars; [ yaml ];
      };

      lsp.servers.yamlls = {
        enable = true;

        capabilities = mkLuaInline "capabilities";
        on_attach = mkLuaInline "default_on_attach";

        cmd = [
          "${pkgs.yaml-language-server}/bin/yaml-language-server"
          "--stdio"
        ];
      };
    };
  };
}
