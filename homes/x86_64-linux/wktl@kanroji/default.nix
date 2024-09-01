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

    system.xdg = enabled;

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
        launchers.rofi = enabled;
        video = enabled;
      };
      terminal = {
        media.spicetify = enabled;
        tools = {
          git = enabled;
          direnv = enabled;
          cava = enabled;
        };
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
