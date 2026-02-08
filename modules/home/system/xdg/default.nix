{ config, lib, ... }:
let
  inherit (lib) mkIf mkEnableOption;

  cfg = config.wktlnix.system.xdg;

  terminal = [ "kitty.desktop" ];
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
        extraConfig = {
          SCREENSHOTS = "${config.xdg.userDirs.pictures}/screenshots";
        };
      };
    };
  };
}
