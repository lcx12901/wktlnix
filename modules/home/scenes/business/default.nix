{
  config,
  osConfig,
  lib,
  pkgs,
  namespace,
  ...
}:
let
  inherit (lib) mkIf;
  inherit (lib.${namespace}) mkBoolOpt enabled;

  persist = osConfig.${namespace}.system.persist.enable;

  cfg = config.${namespace}.scenes.business;
in
{
  options.${namespace}.scenes.business = {
    enable = mkBoolOpt false "Whether or not to enable business configuration.";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      feishu
    ];

    home.persistence = mkIf persist {
      "/persist/home/${config.${namespace}.user.name}" = {
        directories = [".config/LarkShell"];
      };
    };
  };
}
