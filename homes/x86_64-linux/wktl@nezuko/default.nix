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
          gpuAcceleration = true;
          hardwareDecoding = true;
        };
        editors.vscode = enabled;
        launchers.rofi = enabled;
        video = enabled;
      };
      terminal = {
        emulators.kitty = enabled;
        media.spicetify = enabled;
        tools = {
          git = enabled;
          direnv = enabled;
        };
      };
    };

    theme.gtk = enabled;

    scenes = {
      daily = enabled;
      business = enabled;
      development = enabled;
    };
  };

  home.stateVersion = "23.11";
}
