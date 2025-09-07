{
  config,
  lib,
  pkgs,
  namespace,
  ...
}:
let
  cfg = config.${namespace}.services.flameshot;
in
{
  options.${namespace}.services.flameshot = {
    enable = lib.mkEnableOption "cliphist";
  };

  config = lib.mkIf cfg.enable {
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
