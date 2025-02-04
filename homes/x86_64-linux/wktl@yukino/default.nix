{
  config,
  lib,
  namespace,
  ...
}:
let
  inherit (lib.${namespace}) enabled;
in
{
  wktlnix = {
    user = {
      enable = true;
      inherit (config.snowfallorg.user) name;
    };

    system.xdg = enabled;

    programs = {
      graphical = {
        wms.niri = enabled;
        browsers.firefox = {
          enable = true;
          gpuAcceleration = true;
          hardwareDecoding = true;
        };
        editors.vscode = enabled;
        apps.discord = enabled;
        video = enabled;
        addons = {
          waybar.basicFontSize = "12";
        };
      };
      terminal = {
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
      music = enabled;
    };
  };

  home.stateVersion = "24.05";
}
