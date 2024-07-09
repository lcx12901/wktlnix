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
        browsers.firefox = enabled;
        editors.vscode = enabled;
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
      business = enabled;
      development = enabled;
    };
  };

  home.stateVersion = "24.05";
}
