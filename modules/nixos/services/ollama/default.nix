{ config, lib, ... }:
let
  inherit (lib) mkIf mkEnableOption;

  cfg = config.wktlnix.services.ollama;

  amdCfg = config.wktlnix.hardware.gpu.amd or { };
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

      environmentVariables =
        lib.optionalAttrs cfg.enableDebug {
          OLLAMA_DEBUG = "1";
        }
        // lib.optionalAttrs ((amdCfg.enable or false) && (amdCfg.enableRocmSupport or false)) {
          HCC_AMDGPU_TARGET = "gfx1100";
          HSA_OVERRIDE_GFX_VERSION = "11.0.0";
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
