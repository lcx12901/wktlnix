{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption;

  cfg = config.wktlnix.services.flameshot;
in
{
  options.wktlnix.services.flameshot = {
    enable = mkEnableOption "cliphist";
  };

  config = mkIf cfg.enable {
    services.flameshot = {
      enable = true;

      # Enable wayland support with this build flag
      package = pkgs.flameshot.override {
        enableWlrSupport = true;
      };

      settings = {
        General = {
          disabledTrayIcon = true;
          showStartupLaunchMessage = false;

          # Auto save to this path
          savePath = "${config.home.homeDirectory}/Pictures/screenshots";
          savePathFixed = true;
          saveAsFileExtension = ".jpg";
          filenamePattern = "%F_%H-%M";
          drawThickness = 1;
          copyPathAfterSave = true;

          # For wayland
          useGrimAdapter = true;
        };
      };
    };
  };
}
