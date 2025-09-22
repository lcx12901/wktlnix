{ config, lib, ... }:
let
  inherit (lib) mkIf mkEnableOption;

  cfg = config.wktlnix.services.open-webui;
in
{
  options.wktlnix.services.open-webui = {
    enable = mkEnableOption "Whether to enable ollama ui.";
  };

  config = mkIf cfg.enable {
    services.open-webui = {
      enable = true;
      openFirewall = true;
    };
  };
}
