{ config, lib, ... }:
let
  inherit (lib) mkIf mkEnableOption;

  cfg = config.wktlnix.services.ollama-ui;
in
{
  options.wktlnix.services.ollama-ui = {
    enable = mkEnableOption "Whether to enable ollama ui.";
  };

  config = mkIf cfg.enable {
    services.nextjs-ollama-llm-ui = {
      enable = true;
      port = 3001;
    };
  };
}
