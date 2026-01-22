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
      (feishu.override {
        commandLineArgs = "--use-gl=desktop --ozone-platform=wayland --enable-wayland-ime --wayland-text-input-version=3";
      })
    ];

    home.persistence = mkIf persist {
      "/persist" = {
        directories = [ ".config/LarkShell" ];
      };
    };
  };
}
