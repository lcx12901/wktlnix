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
        browsers.firefox = enabled;
        editors.vscode = enabled;
        addons.electron-support = enabled;
      };
      terminal = {
        emulators.kitty = enabled;
        tools.git = enabled;
      };
    };

    theme.gtk = enabled;
  };

  home.stateVersion = "23.11";
}
