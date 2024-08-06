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
        launchers.rofi = enabled;
        video = enabled;
      };
      terminal = {
        emulators.kitty = enabled;
        media.spicetify = enabled;
        # editors.neovim = enabled;
        tools = {
          git = enabled;
          direnv = enabled;
          cava = enabled;
        };
      };
    };

    theme = {
      gtk = enabled;
      catppuccin = enabled;
    };

    scenes = {
      daily = enabled;
      development = enabled;
    };
  };

  home.stateVersion = "24.05";
}
