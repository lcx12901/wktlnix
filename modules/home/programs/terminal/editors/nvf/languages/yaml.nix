{ lib, pkgs, ... }:
let
  inherit (lib.meta) getExe;
in
{
  programs.nvf.settings = {
    vim = {
      treesitter = {
        enable = true;
        grammars = with pkgs.vimPlugins.nvim-treesitter.builtGrammars; [ yaml ];
      };

      lsp.servers.yaml-language-server = {
        enable = true;

        cmd = [
          (getExe pkgs.yaml-language-server)
          "--stdio"
        ];
        filetypes = [
          "yaml"
          "yaml.docker-compose"
          "yaml.gitlab"
          "yaml.helm-values"
        ];
        root_markers = [ ".git" ];
        # -- https://github.com/redhat-developer/vscode-redhat-telemetry#how-to-disable-telemetry-reporting
        settings = {
          redhat = {
            telemetry = {
              enabled = false;
            };
          };
        };
      };

      formatter.conform-nvim = {
        enable = true;
        setupOpts = {
          formatters_by_ft.yaml = [ "yamlfmt" ];
          formatters.yamlfmt.command = getExe pkgs.yamlfmt;
        };
      };
    };
  };
}
