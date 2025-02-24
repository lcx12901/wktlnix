{
  config,
  lib,
  namespace,
  ...
}:
let
  inherit (lib.${namespace}) mkBoolOpt;

  cfg = config.${namespace}.services.ollama;
in
{
  options.${namespace}.services.ollama = {
    enable = mkBoolOpt false "Whether to enable ollama.";
    enableDebug = lib.mkEnableOption "debug";
  };

  config = lib.mkIf cfg.enable {
    services.ollama = {
      enable = true;

      openFirewall = true;

      rocmOverrideGfx = "11.0.0";

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
