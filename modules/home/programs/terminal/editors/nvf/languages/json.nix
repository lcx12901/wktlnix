{ lib, pkgs, ... }:
let
  inherit (lib.meta) getExe getExe';
in
{
  programs.nvf.settings = {
    vim = {
      treesitter = {
        enable = true;
        grammars = with pkgs.vimPlugins.nvim-treesitter.builtGrammars; [ json ];
      };

      lsp.servers.jsonls = {
        enable = true;

        cmd = [
          (getExe' pkgs.vscode-langservers-extracted "vscode-json-languageserver")
          "--stdio"
        ];
        filetypes = [
          "json"
          "jsonc"
        ];
        init_options = {
          provideFormatter = true;
        };
        root_markers = [ ".git" ];
      };

      formatter.conform-nvim = {
        enable = true;
        setupOpts = {
          formatters_by_ft.json = [ "jsonfmt" ];
          formatters.jsonfmt.command = getExe (
            pkgs.writeShellApplication {
              name = "jsonfmt";
              runtimeInputs = [ pkgs.jsonfmt ];
              text = "jsonfmt -w -";
            }
          );
        };
      };
    };
  };
}
