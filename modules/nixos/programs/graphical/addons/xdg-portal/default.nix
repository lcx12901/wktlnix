{
  config,
  lib,
  pkgs,
  namespace,
  ...
}:
let
  inherit (lib) mkIf;
  inherit (lib.${namespace}) mkBoolOpt;

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

        config = {
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
            xdg-desktop-portal-wlr
          ]
          ++ (lib.optional config.${namespace}.programs.graphical.wms.niri.enable xdg-desktop-portal-gnome);
      };
    };
  };
}
