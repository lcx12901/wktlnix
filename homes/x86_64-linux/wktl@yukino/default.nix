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
        screenlockers.hyprlock = enabled;
        # browsers.firefox = {
        #   gpuAcceleration = true;
        #   hardwareDecoding = true;
        # };
        editors.vscode = enabled;
        addons = {
          mako = enabled;
        };
        launchers.rofi = enabled;
        video = enabled;
      };
      terminal = {
        emulators.kitty = enabled;
        media.spicetify = enabled;
        tools = {
          git = {
            enable = true;
            userName = "linchengxu";
            userEmail = "linchengxu@z9yun.com";
          };
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

  home.stateVersion = "24.05";
}
