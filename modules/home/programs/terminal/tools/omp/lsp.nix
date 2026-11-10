{
  config,
  lib,
  pkgs,
}:

let
  inherit (lib)
    getExe
    getExe'
    ;
in
(pkgs.formats.yaml { }).generate "omp-lsp.yml" {
  servers = {
    nixd = {
      command = getExe pkgs.nixd;
      fileTypes = [ ".nix" ];
      rootMarkers = [
        "flake.nix"
        "default.nix"
        "shell.nix"
      ];
      initOptions = {
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
    typescript-language-server = {
      command = getExe pkgs.typescript-language-server;
      args = [ "--stdio" ];
      fileTypes = [
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
    vue-language-server = {
      command = getExe pkgs.vue-language-server;
      args = [ "--stdio" ];
      fileTypes = [ ".vue" ];
    };
    eslint = {
      command = getExe' pkgs.vscode-langservers-extracted "vscode-eslint-language-server";
      args = [ "--stdio" ];
      fileTypes = [
        ".js"
        ".jsx"
        ".ts"
        ".tsx"
        ".vue"
      ];
    };
    yamlls = {
      command = getExe pkgs.yaml-language-server;
      args = [ "--stdio" ];
      fileTypes = [
        ".yaml"
        ".yml"
      ];
    };
    vscode-json-language-server = {
      command = getExe' pkgs.vscode-langservers-extracted "vscode-json-language-server";
      args = [ "--stdio" ];
      fileTypes = [
        ".json"
        ".jsonc"
      ];
    };
    bashls = {
      command = getExe pkgs.bash-language-server;
      args = [ "start" ];
      fileTypes = [
        ".sh"
        ".bash"
      ];
    };
    marksman = {
      command = getExe pkgs.marksman;
      fileTypes = [
        ".md"
        ".mdx"
      ];
    };
    rust-analyzer = {
      command = getExe pkgs.rust-analyzer;
      fileTypes = [ ".rs" ];
    };
  };
}
