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
        apps.discord = enabled;
        video = enabled;
        addons = {
          waybar.basicFontSize = "12";
        };
      };
      terminal = {
        media = {
          spicetify = enabled;
          go-musicfox = enabled;
        };
        tools = {
          git = {
            userName = "linchengxu";
            userEmail = "linchengxu@z9yun.com";
          };
        };
      };
    };

    scenes = {
      daily = enabled;
      business = enabled;
      development = enabled;
    };
  };

  home.stateVersion = "24.05";
}
