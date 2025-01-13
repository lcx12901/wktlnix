{
  config,
  lib,
  inputs,
  namespace,
  ...
}:
let
  inherit (lib) mkIf;

  cfg = config.${namespace}.programs.graphical.wms.hyprland;
in
{
  config = mkIf cfg.enable {
    wayland.windowManager.hyprland = {
      settings = {
        exec-once = [
          "hyprctl setcursor 22 &"

          "fcitx5 -d --replace"
          "swww init && swww img ${inputs.wallpapers}/Hoshino-eye.jpg"
        ];
      };
    };
  };
}
