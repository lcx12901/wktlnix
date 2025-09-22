{ config, lib, ... }:
let
  inherit (lib) mkIf mkEnableOption;

  cfg = config.wktlnix.services.ollama;
in
{
  options.wktlnix.services.ollama = {
    enable = mkEnableOption "Whether to enable ollama.";
    enableDebug = mkEnableOption "debug";
  };

  config = mkIf cfg.enable {
    services.ollama = {
      enable = true;

      openFirewall = true;

      rocmOverrideGfx = "11.0.0";

      loadModels = [
        "qwen2.5-coder:32b"
      ];

      environmentVariables =
        lib.optionalAttrs cfg.enableDebug {
          OLLAMA_DEBUG = "1";
        }
        // {
          HCC_AMDGPU_TARGET = "gfx1100";
          AMD_LOG_LEVEL = lib.mkIf cfg.enableDebug "3";
        };
    };

    environment.persistence."/persist" = {
      hideMounts = true;

      directories = [
        "/var/lib/private/ollama"
      ];

    };
  };
}
