{
  config,
  lib,
  namespace,
  ...
}: let
  inherit (lib.${namespace}) enabled;
in {
  wktlnix = {
    user = {
      enable = true;
      inherit (config.snowfallorg.user) name;
    };

    programs = {
      graphical = {
        wms.hyprland = enabled;
        browsers.firefox = {
          enable = true;
          gpuAcceleration = true;
          hardwareDecoding = true;
        };
        editors.vscode = {
          enable = true;
          zoomLevel = 0.5;
        };
        apps.discord = enabled;
        video = enabled;
      };
    };

    scenes = {
      daily = enabled;
      business = enabled;
      development = enabled;
      games = enabled;
    };
  };

  home.stateVersion = "24.05";
}
