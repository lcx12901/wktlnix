{
  config,
  lib,
  namespace,
  ...
}: let
  inherit (lib) mkIf;
  cfg = config.${namespace}.programs.graphical.wms.hyprland;
in {
  config = mkIf cfg.enable {
    wayland.windowManager.hyprland = {
      settings = {
        windowrulev2 = [
          # make Firefox PiP window floating and sticky
          "float, title:^(Picture-in-Picture)$"
          "pin, title:^(Picture-in-Picture)$"

          "float,title:图片"
          "float,title:微信"
          "float,class:^(org.gnome.Nautilus|nautilus)$"
          "float,class:discord"
        ];
      };
    };
  };
}
