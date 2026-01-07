{
  osConfig,
  config,
  lib,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption;

  cfg = config.wktlnix.programs.graphical.apps.vesktop;

  persist = osConfig.wktlnix.system.persist.enable;
in
{
  options.wktlnix.programs.graphical.apps.vesktop = {
    enable = mkEnableOption "Vesktop";
  };

  config = mkIf cfg.enable {
    programs.vesktop = {
      enable = true;

      settings = {
        discordBranch = "stable";
        # Easier to close and be done with it
        minimizeToTray = false;
        arRPC = true;
        customTitleBar = false;
      };

      vencord = {
        settings = {
          autoUpdate = false;
          autoUpdateNotification = false;

          useQuickCss = true;
          themeLinks = [ ];
          eagerPatches = false;
          enableReactDevtools = true;
          frameless = false;
          transparent = true;
          winCtrlQ = false;
          disableMinSize = true;
          winNativeTitleBar = false;
          plugins = {
            CommandsAPI = {
              enabled = true;
            };
            MessageAccessoriesAPI = {
              enabled = true;
            };
            UserSettingsAPI = {
              enabled = true;
            };
            AlwaysAnimate = {
              enabled = true;
            };
            AlwaysExpandRoles = {
              enabled = true;
            };
            AlwaysTrust = {
              enabled = true;
            };
            BetterSessions = {
              enabled = true;
            };
            CrashHandler = {
              enabled = true;
            };
            FixImagesQuality = {
              enabled = true;
            };
            PlatformIndicators = {
              enabled = true;
            };
            ReplyTimestamp = {
              enabled = true;
            };
            ShowHiddenChannels = {
              enabled = true;
            };
            ShowHiddenThings = {
              enabled = true;
            };
            VencordToolbox = {
              enabled = true;
            };
            WebKeybinds = {
              enabled = true;
            };
            WebScreenShareFixes = {
              enabled = true;
            };
            # Lag inducing on large servers
            # WhoReacted= {
            #     enabled= false
            # };
            YoutubeAdblock = {
              enabled = true;
            };
            BadgeAPI = {
              enabled = true;
            };
            NoTrack = {
              enabled = true;
              disableAnalytics = true;
            };
            Settings = {
              enabled = true;
              settingsLocation = "aboveNitro";
            };
            Translate = {
              enabled = true;
            };
          };
          notifications = {
            timeout = 5000;
            position = "bottom-right";
            useNative = "not-focused";
            logLimit = 50;
          };
        };
      };
    };

    home.persistence = lib.mkIf persist {
      "/persist" = {
        directories = [ ".config/vesktop" ];
      };
    };
  };
}
