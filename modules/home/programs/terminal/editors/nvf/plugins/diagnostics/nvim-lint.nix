{ lib, pkgs, ... }:
{
  programs.nvf.settings = {
    vim.diagnostics.nvim-lint = {
      enable = true;
      linters_by_ft = {
        nix = [
          "statix"
          "deadnix"
        ];
        typescript = [ "eslint_d" ];
        typescriptreact = [ "eslint_d" ];
        vue = [ "eslint_d" ];
      };
      linters = {
        statix.cmd = lib.getExe pkgs.statix;
        deadnix.cmd = lib.getExe pkgs.deadnix;
        eslint_d.cmd = lib.getExe pkgs.eslint_d;
      };
    };
  };
}
