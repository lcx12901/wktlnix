{ lib, pkgs, ... }:
let
  inherit (lib.meta) getExe;
  inherit (lib.generators) mkLuaInline;
in
{
  programs.nvf.settings = {
    vim = {
      treesitter = {
        enable = true;
        grammars = with pkgs.vimPlugins.nvim-treesitter.builtGrammars; [ bash ];
      };

      lsp.servers.bash-ls = {
        enable = true;

        cmd = [
          (getExe pkgs.bash-language-server)
          "start"
        ];
        filetypes = [
          "bash"
          "sh"
        ];
        root_markers = [ ".git" ];
        settings = {
          basheIde = {
            globPattern = mkLuaInline "vim.env.GLOB_PATTERN or '*@(.sh|.inc|.bash|.command)'";
          };
        };
      };

      formatter.conform-nvim = {
        enable = true;
        setupOpts = {
          formatters_by_ft.sh = [ "shfmt" ];
          formatters.shfmt.command = getExe pkgs.shfmt;
        };
      };

      diagnostics.nvim-lint = {
        enable = true;
        linters_by_ft.sh = [ "shellcheck" ];
        linters.shellcheck.cmd = getExe pkgs.shellcheck;
      };
    };
  };
}
