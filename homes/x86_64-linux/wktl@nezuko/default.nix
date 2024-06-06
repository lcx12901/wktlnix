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
          gpuAcceleration = true;
          hardwareDecoding = true;
        };
        editors.vscode = enabled;
        addons.electron-support = enabled;
        launchers.rofi = enabled;
      };
      terminal = {
        emulators.kitty = enabled;
        tools.git = enabled;
        media.spicetify = enabled;
      };
    };

    theme.gtk = enabled;
  };

  home.stateVersion = "23.11";
}
