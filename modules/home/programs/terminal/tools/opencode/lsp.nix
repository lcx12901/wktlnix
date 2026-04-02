{
  config,
  lib,
  pkgs,
  ...
}:
{
  config = {
    programs.opencode.settings.lsp = {
      nixd = {
        command = [ (lib.getExe pkgs.nixd) ];
        extensions = [ ".nix" ];
        initialization = {
          formatting = {
            command = [ (lib.getExe pkgs.nixfmt) ];
          };
          options = {
            nixos = {
              expr = "(builtins.getFlake \"${config.home.homeDirectory}/Coding/wktlnix\").nixosConfigurations.kanroji.options";
            };
            home-manager = {
              expr = "(builtins.getFlake \"${config.home.homeDirectory}/Coding/wktlnix\").homeConfigurations.\"wktl@kanroji\".options";
            };
          };
        };
      };

      typescript = {
        command = [
          (lib.getExe pkgs.typescript-language-server)
          "--stdio"
        ];
        extensions = [
          ".ts"
          ".tsx"
          ".js"
          ".jsx"
          ".mjs"
          ".cjs"
          ".mts"
          ".cts"
        ];
      };

      vue = {
        command = [
          (lib.getExe pkgs.vue-language-server)
          "--stdio"
        ];
        extensions = [
          ".vue"
        ];
      };

      yamlls = {
        command = [
          (lib.getExe pkgs.yaml-language-server)
          "--stdio"
        ];
        extensions = [
          ".yaml"
          ".yml"
        ];
      };

      jsonls = {
        command = [
          (lib.getExe' pkgs.vscode-langservers-extracted "vscode-json-language-server")
          "--stdio"
        ];
        extensions = [
          ".json"
          ".jsonc"
        ];
      };
    };
  };
}
