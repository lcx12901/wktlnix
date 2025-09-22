{
  config,
  osConfig,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption;

  persist = osConfig.wktlnix.system.persist.enable;

  cfg = config.wktlnix.scenes.business;
in
{
  options.wktlnix.scenes.business = {
    enable = mkEnableOption "Whether or not to enable business configuration.";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      feishu
    ];

    home.persistence = mkIf persist {
      "/persist/home/${config.wktlnix.user.name}" = {
        directories = [ ".config/LarkShell" ];
      };
    };
  };
}
