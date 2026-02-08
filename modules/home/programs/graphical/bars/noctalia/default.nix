{
  inputs,
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption;

  cfg = config.wktlnix.programs.graphical.bars.noctalia;
in
{
  options.wktlnix.programs.graphical.bars.noctalia = {
    enable = mkEnableOption "noctalia";
  };

  config = mkIf cfg.enable {
    home.file = {
      "Pictures/Wallpapers" = {
        source = "${inputs.wallpapers}";
      };
      ".face" = {
        source = lib.file.get-file ".face";
      };
      ".cache/noctalia/wallpapers.json" = {
        text = builtins.toJSON {
          defaultWallpaper = "${config.wktlnix.user.home}/Pictures/Wallpapers/wallhaven-jewvzy.jpg";
        };
      };
    };

    programs.noctalia-shell = {
      enable = true;

      systemd.enable = true;

      settings = {
        settingsVersion = 0;

        colorSchemes = {
          darkMode = true;
          generationMethod = "rainbow";
          useWallpaperColors = true;
        };

        wallpaper = {
          enabled = true;
          overviewEnabled = false;
          enableMultiMonitorDirectories = false;
          setWallpaperOnAllMonitors = true;
          panelPosition = "center";
          automationEnabled = true;
          randomIntervalSec = 1800;
          showHiddenFiles = false;
          transitionDuration = 1500;
          transitionEdgeSmoothness = 0.05;
          transitionType = "pixelate";
          viewMode = "recursive";
          wallpaperChangeMode = "random";
        };

        dock.enabled = false;
        network.enabled = false;

        bar = {
          density = "comfortable";
          widgets = {
            left = [
              {
                id = "Launcher";
              }
              {
                id = "Clock";
              }
              {
                id = "SystemMonitor";
                compactMode = true;
                diskPath = "/persist";
                showCpuFreq = false;
                showCpuTemp = false;
                showCpuUsage = true;
                showDiskAsFree = false;
                showDiskUsage = false;
                showGpuTemp = false;
                showLoadAverage = false;
                showMemoryAsPercent = false;
                showMemoryUsage = true;
                showNetworkStats = true;
                showSwapUsage = false;
                useMonospaceFont = true;
                usePrimaryColor = true;
              }
              {
                id = "ActiveWindow";
                maxWidth = 145;
                scrollingMode = "hover";
              }
              {
                id = "MediaMini";
                maxWidth = 200;
                panelShowAlbumArt = true;
                panelShowVisualizer = true;
                scrollingMode = "always";
                showAlbumArt = true;
                showArtistFirst = true;
                showProgressRing = true;
                showVisualizer = true;
                useFixedWidth = false;
                visualizerType = "mirrored";
              }
            ];
            center = [
              {
                id = "Workspace";
                emptyColor = "secondary";
                focusedColor = "tertiary";
                occupiedColor = "primary";
                enableScrollWheel = true;
                followFocusedScreen = true;
                labelMode = "index";
                showBadge = true;
                showLabelsOnlyWhenOccupied = true;
              }
            ];
            right = [
              {
                id = "Tray";
              }
              {
                id = "Volume";
                displayMode = "onhover";
                middleClickCommand = "${lib.getExe pkgs.pavucontrol}";
              }
              {
                id = "NotificationHistory";
                hideWhenZero = true;
                hideWhenZeroUnread = false;
                showUnreadBadge = true;
                unreadBadgeColor = "primary";
              }
              {
                id = "ControlCenter";
              }
            ];
          };
        };

        controlCenter = {
          position = "close_to_bar_button";
          diskPath = "/persist";
          shortcuts = {
            left = [
              { id = "Bluetooth"; }
              { id = "WallpaperSelector"; }
            ];
            right = [
              { id = "Notifications"; }
              { id = "KeepAwake"; }
            ];
          };
          cards = [
            {
              enabled = true;
              id = "profile-card";
            }
            {
              enabled = true;
              id = "shortcuts-card";
            }
            {
              enabled = true;
              id = "audio-card";
            }
            {
              enabled = false;
              id = "brightness-card";
            }
            {
              enabled = true;
              id = "weather-card";
            }
            {
              enabled = true;
              id = "media-sysmon-card";
            }
          ];
        };

        notifications = {
          enabled = true;
          backgroundOpacity = 0.84;
          sounds = {
            enabled = true;
            volume = 0.5;
          };
        };

        audio = {
          cavaFrameRate = 60;
          visualizerType = "mirrored";
        };

        location.name = "Shenzhen";

        desktopWidgets = {
          enabled = true;
          gridSnap = false;
          monitorWidgets = [
            {
              name = "DP-1";
              widgets = [
                {
                  id = "MediaPlayer";
                  hideMode = "hidden";
                  roundedCorners = true;
                  scale = 1.4394558159639832;
                  showAlbumArt = true;
                  showBackground = true;
                  showButtons = true;
                  showVisualizer = true;
                  visualizerType = "mirrored";
                  x = 1960;
                  y = 120;
                }
              ];
            }
          ];
        };
      };
    };
  };
}
