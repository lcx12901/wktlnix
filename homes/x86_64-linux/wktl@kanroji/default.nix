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
        # apps.discord = enabled;
        editors.zed = enabled;
        video = enabled;
        browsers.zen = enabled;
      };
    };

    scenes = {
      daily = enabled;
      business = enabled;
      development = {
        enable = true;
        nodejsEnable = true;
      };
      music = enabled;
    };
  };

  home.stateVersion = "24.05";
}
