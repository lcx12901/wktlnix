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
        wms.hyprland = enabled;
        browsers.firefox = {
          enable = true;
          gpuAcceleration = true;
          hardwareDecoding = true;
        };
        editors.vscode = enabled;
        apps.discord = enabled;
        video = enabled;
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
