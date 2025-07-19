{ lib, pkgs, ... }:
{
  programs.nvf.settings = {
    vim.formatter.conform-nvim = {
      enable = true;

      setupOpts = {
        formatters_by_ft = {
          nix = [ "nixfmt" ];
          typescript = [ "eslint_d" ];
          typescriptreact = [ "eslint_d" ];
          vue = [ "eslint_d" ];
        };
        formatters = {
          nixfmt.command = lib.getExe pkgs.nixfmt-rfc-style;
          eslint_d.command = lib.getExe pkgs.eslint_d;
        };
      };
    };
  };
}
