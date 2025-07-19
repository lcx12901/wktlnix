{ lib, pkgs, ... }:
let
  inherit (lib.generators) mkLuaInline;
in
{
  programs.nvf.settings = {
    vim = {
      treesitter = {
        enable = true;
        grammars = with pkgs.vimPlugins.nvim-treesitter.builtGrammars; [ nix ];
      };

      lsp.servers.nil_ls = {
        enable = true;

        capabilities = mkLuaInline "capabilities";
        on_attach = mkLuaInline "default_on_attach";

        cmd = [ "${pkgs.nil}/bin/nil" ];

        settings = {
          nix = {
            flake = {
              autoArchive = true;
            };
          };
        };
      };
    };
  };
}
