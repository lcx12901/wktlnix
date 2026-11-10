{
  config,
  lib,
  pkgs,
}:

let
  inherit (lib) getExe;
in
(pkgs.formats.json { }).generate "omp-mcp.json" {
  "$schema" =
    "https://raw.githubusercontent.com/can1357/oh-my-pi/main/packages/coding-agent/src/config/mcp-schema.json";
  mcpServers = {
    nixos = {
      command = getExe pkgs.mcp-nixos;
    };
    codegraph = {
      command = getExe pkgs.codegraph;
      args = [
        "serve"
        "--mcp"
      ];
    };
  }
  // lib.optionalAttrs config.wktlnix.programs.terminal.tools.mnemos.enable {
    mnemos = {
      command = getExe pkgs.wktlnix.mnemos-continuity;
      args = [ "serve" ];
    };
  };
}
