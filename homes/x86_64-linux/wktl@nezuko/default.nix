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
      graphical.wms.hyprland = {
        enable = true;
      };
      terminal.emulators.kitty = enabled;
    };
  };

  home.stateVersion = "23.11";
}
