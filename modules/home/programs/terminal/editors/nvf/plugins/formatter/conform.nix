{ lib, pkgs, ... }:
let
  inherit (lib.generators) mkLuaInline;
in
{
  programs.nvf.settings = {
    vim.formatter.conform-nvim = {
      enable = true;

      setupOpts = {
        formatters_by_ft = {
          nix = [ "nixfmt" ];
          toml = [ "taplo" ];
          yaml = [ "yamlfmt" ];
          sql = [ "sqlfluff" ];
          json = [
            "eslint_d"
            "jq"
            (mkLuaInline ''stop_after_first = true'')
          ];
          jsonc = [
            "eslint_d"
            "jq"
            (mkLuaInline ''stop_after_first = true'')
          ];
          typescript = [
            "eslint_d"
            "oxlint"
            (mkLuaInline ''stop_after_first = true'')
          ];
          typescriptreact = [
            "eslint_d"
            "oxlint"
            (mkLuaInline ''stop_after_first = true'')
          ];
          vue = [
            "eslint_d"
            "oxlint"
            (mkLuaInline ''stop_after_first = true'')
          ];
        };
        formatters = {
          nixfmt.command = lib.getExe pkgs.nixfmt;
          eslint_d = {
            command = lib.getExe pkgs.eslint_d;
            cwd = mkLuaInline ''
              require("conform.util").root_file({
                ".eslintrc",
                ".eslintrc.js",
                ".eslintrc.cjs",
                ".eslintrc.yaml",
                ".eslintrc.yml",
                ".eslintrc.json",
                "eslint.config.js",
                "eslint.config.mjs",
                "eslint.config.cjs",
                "eslint.config.ts",
                "eslint.config.mts",
                "eslint.config.cts",
              })
            '';
            require_cwd = true;
          };
          oxlint.command = lib.getExe pkgs.oxlint;
          jq.command = lib.getExe pkgs.jq;
          taplo.command = lib.getExe pkgs.taplo;
          sqlfluff.command = lib.getExe pkgs.sqlfluff;
          yamlfmt.command = lib.getExe pkgs.yamlfmt;
        };
      };
    };
  };
}
