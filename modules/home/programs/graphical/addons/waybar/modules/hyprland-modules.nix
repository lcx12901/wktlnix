{
  config,
  lib,
  ...
}:
let
  inherit (lib) getExe';
in
{
  "hyprland/workspaces" = {
    all-outputs = false;
    active-only = false;
    disable-scroll = false;
    on-scroll-up = "${getExe' config.wayland.windowManager.hyprland.package "hyprctl"} dispatch workspace e+1";
    on-scroll-down = "${getExe' config.wayland.windowManager.hyprland.package "hyprctl"} dispatch workspace e-1";
    format = " {icon} ";
    on-click = "activate";
    format-icons = {
      default = "";
    };
  };
}
