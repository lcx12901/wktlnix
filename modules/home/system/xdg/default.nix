{ config, lib, ... }:
let
  inherit (lib) mkIf mkEnableOption;

  cfg = config.wktlnix.system.xdg;

  terminal = [ "ghostty.desktop" ];
  video = [ "vlc.desktop" ];

  # XDG MIME types
  associations = {
    "application/x-extension-m4a" = video;
    "application/x-extension-mp4" = video;
    "application/x-flac" = video;
    "application/x-matroska" = video;
    "application/x-netshow-channel" = video;
    "application/x-quicktime-media-link" = video;
    "application/x-quicktimeplayer" = video;
    "application/x-smil" = video;
    "audio/*" = video;
    "video/*" = video;
    "x-scheme-handler/spotify" = [ "spotify.desktop" ];
    "x-scheme-handler/terminal" = terminal;
    "x-scheme-handler/tg" = [ "org.telegram.desktop" ];
  };
in
{
  options.wktlnix.system.xdg = {
    enable = mkEnableOption "xdg";
  };

  config = mkIf cfg.enable {
    xdg = {
      enable = true;
      cacheHome = config.home.homeDirectory + "/.local/cache";

      mimeApps = {
        enable = true;
        defaultApplications = associations;
        associations.added = associations;
      };

      userDirs = {
        enable = true;
        createDirectories = true;
        setSessionVariables = true;
        extraConfig = {
          SCREENSHOTS = "${config.xdg.userDirs.pictures}/screenshots";
        };
      };

      configFile =
        let
          mkPortalPreferences =
            conf:
            lib.mapAttrs (_: value: if lib.isList value then lib.concatStringsSep ";" value else value) conf;

          portalConfigs = {
            niri = lib.optionalAttrs config.wktlnix.programs.graphical.wms.niri.enable {
              default = [
                "gtk"
                "gnome"
              ];
              "org.freedesktop.impl.portal.Screencast" = "gtk";
              "org.freedesktop.impl.portal.Screenshot" = "gtk";
            };

            common = {
              default = [
                "gtk"
                "gnome"
              ];

              # GTK
              "org.freedesktop.impl.portal.Access" = "gtk";
              "org.freedesktop.impl.portal.Account" = "gtk";
              "org.freedesktop.impl.portal.AppChooser" = "gtk";
              "org.freedesktop.impl.portal.Device" = "gtk";
              "org.freedesktop.impl.portal.DynamicLauncher" = "gtk";
              "org.freedesktop.impl.portal.Email" = "gtk";
              "org.freedesktop.impl.portal.FileChooser" = "gtk";
              "org.freedesktop.impl.portal.Lockdown" = "gtk";
              "org.freedesktop.impl.portal.Notification" = "gtk";
              "org.freedesktop.impl.portal.Print" = "gtk";
              "org.freedesktop.impl.portal.Screencast" = "gtk";
              "org.freedesktop.impl.portal.Screenshot" = "gtk";

              # GNOME
              "org.freedesktop.impl.portal.Secret" = "gnome-keyring";
              "org.freedesktop.impl.portal.Background" = "gnome";
              "org.freedesktop.impl.portal.Clipboard" = "gnome";
              "org.freedesktop.impl.portal.InputCapture" = "gnome";
              "org.freedesktop.impl.portal.RemoteDesktop" = "gnome";
            };
          };
        in
        lib.concatMapAttrs (
          desktop: conf:
          lib.optionalAttrs (conf != { }) {
            "xdg-desktop-portal/${lib.optionalString (desktop != "common") "${desktop}-"}portals.conf".text =
              lib.generators.toINI { }
                { preferred = mkPortalPreferences conf; };
          }
        ) portalConfigs;
    };
  };
}
