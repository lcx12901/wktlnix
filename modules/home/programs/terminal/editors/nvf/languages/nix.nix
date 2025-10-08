{ lib, pkgs, ... }:
let
  inherit (lib.meta) getExe;
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

        cmd = [ (getExe pkgs.nil) ];

        filetypes = [ "nix" ];
        root_markers = [
          ".git"
          "flake.nix"
        ];

        settings = {
          nix = {
            flake = {
              autoArchive = true;
            };
          };
        };
      };

      formatter.conform-nvim = {
        enable = true;
        setupOpts = {
          formatters_by_ft.nix = [ "nixfmt" ];
          formatters.nixfmt.command = getExe pkgs.nixfmt;
        };
      };

      diagnostics.nvim-lint = {
        enable = true;
        linters_by_ft.nix = [
          "statix"
          "deadnix"
        ];
        linters = {
          statix.cmd = getExe pkgs.statix;
          deadnix.cmd = getExe pkgs.deadnix;
        };
      };
    };
  };
}
