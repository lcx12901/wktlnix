{
  lib,
  config,
  pkgs,
  ...
}: {
  plugins = {
    conform-nvim = {
      enable = true;

      settings = {
        formatters_by_ft = {
          lua = ["stylua"];
          nix = ["nixfmt"];
          toml = ["taplo"];
          yaml = ["yamlfmt"];
          "_" = [
            "squeeze_blanks"
            "trim_whitespace"
            "trim_newlines"
          ];
          json = ["eslint_d"];
          jsonc = ["eslint_d"];
          typescript = ["eslint_d"];
          javascript = ["eslint_d"];
          typescriptreact = ["eslint_d"];
          vue = ["eslint_d"];
          css = ["eslint_d"];
          scss = ["eslint_d"];
        };

        formatters = {
          stylua = {
            command = lib.getExe pkgs.stylua;
          };
          nixfmt = {
            command = lib.getExe pkgs.nixfmt-rfc-style;
          };
          jq = {
            command = lib.getExe pkgs.jq;
          };
          taplo = {
            command = lib.getExe pkgs.taplo;
          };
          yamlfmt = {
            command = lib.getExe pkgs.yamlfmt;
          };
          eslint_d = {
            command = lib.getExe pkgs.eslint_d;
          };
        };
      };
    };
  };

  autoCmd = lib.mkIf config.plugins.conform-nvim.enable [
    {
      event = "BufWritePre";
      pattern = ["*"];
      callback.__raw = ''
        function(args) require("conform").format({ bufnr = args.buf }) end
      '';
    }
  ];
}
