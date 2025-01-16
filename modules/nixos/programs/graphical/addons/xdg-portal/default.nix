{
  config,
  inputs,
  lib,
  pkgs,
  system,
  namespace,
  ...
}:
let
  inherit (lib) mkIf;
  inherit (lib.${namespace}) mkBoolOpt;
  inherit (inputs) hyprland;

  cfg = config.${namespace}.programs.graphical.addons.xdg-portal;
in
{
  options.${namespace}.programs.graphical.addons.xdg-portal = {
    enable = mkBoolOpt false "Whether or not to add support for xdg portal.";
  };

  config = mkIf cfg.enable {
    xdg = {
      portal = {
        enable = true;

        configPackages = lib.optionals config.${namespace}.programs.graphical.wms.hyprland.enable [
          hyprland.packages.${system}.hyprland
        ];

        config = {
          hyprland = mkIf config.${namespace}.programs.graphical.wms.hyprland.enable {
            default = [
              "hyprland"
              "gtk"
            ];
            "org.freedesktop.impl.portal.Screencast" = "hyprland";
            "org.freedesktop.impl.portal.Screenshot" = "hyprland";
          };

          niri = mkIf config.${namespace}.programs.graphical.wms.niri.enable {
            default = [
              "gtk"
              "gnome"
            ];

            "org.freedesktop.impl.portal.Access" = "gtk";
            "org.freedesktop.impl.portal.Notification" = "gtk";
            "org.freedesktop.impl.portal.Screencast" = "gtk";
            "org.freedesktop.impl.portal.Screenshot" = "gtk";
            "org.freedesktop.impl.portal.Secret" = [ "gnome-keyring" ];
          };

          common = {
            default = [ "gtk" ];

            "org.freedesktop.impl.portal.Screencast" = "gtk";
            "org.freedesktop.impl.portal.Screenshot" = "gtk";
            "org.freedesktop.impl.portal.Secret" = [ "gnome-keyring" ];
          };
        };
        extraPortals =
          with pkgs;
          [
            xdg-desktop-portal-gtk
          ]
          ++ (lib.optional config.${namespace}.programs.graphical.wms.niri.enable xdg-desktop-portal-gnome)
          ++ (lib.optional config.${namespace}.programs.graphical.wms.hyprland.enable (
            hyprland.packages.${system}.xdg-desktop-portal-hyprland.override {
              # debug = true;
              # TODO: use same package as home-manager
              inherit (hyprland.packages.${system}) hyprland;
            }
          ));
      };
    };
  };
}
