{
  inputs,
  osConfig,
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption;

  persist = osConfig.wktlnix.system.persist.enable;

  cfg = config.wktlnix.programs.graphical.bars.noctalia;
in
{
  options.wktlnix.programs.graphical.bars.noctalia = {
    enable = mkEnableOption "noctalia";
  };

  config = mkIf cfg.enable {
    # home = {
    #   file = {
    #     ".face" = {
    #       source = lib.file.get-file ".face";
    #     };
    #   };
    # persistence = lib.mkIf persist {
    #   "/persist" = {
    #     directories = [ ".config/noctalia" ];
    #   };
    # };
    # };

    programs.noctalia = {
      enable = true;
      systemd.enable = true;

      settings = {
        shell = {
          ui_scale = 1.0;
          font_family = "Maple Mono NF CN";
          telemetry_enabled = false;
          clipboard_enabled = true;
          clipboard_auto_paste = "auto";
          clipboard_placement = "centered";
          avatar_path = lib.file.get-file ".face";
        };

        shell.panel = {
          density = "comfortable";
        };

        theme = {
          mode = "dark";
          source = "wallpaper";
        };

        wallpaper = {
          enabled = true;
          fill_mode = "fill";
          transition = "pixelate";
          transition_duration = 1500;
          directory = "${inputs.wallpapers}";
        };

        wallpaper.automation = {
          enabled = true;
          interval_seconds = 1800;
          order = "random";
          recursive = true;
        };

        bar.main = {
          position = "top";
          thickness = 40;
          background_opacity = 0.85;
          radius = 0;
          margin = 0;
          padding = 0;
          widget_spacing = 16;
          scale = 1.0;

          start = [
            "clock"
            "cpu"
            "mem"
            "active_window"
            "media"
          ];
          center = [ "workspaces" ];
          end = [
            "tray"
            "volume"
            "notifications"
            "control-center"
          ];
        };

        widget = {
          cpu = {
            type = "sysmon";
            stat = "cpu_usage";
          };
          mem = {
            type = "sysmon";
            stat = "ram_used";
          };
          active_window = {
            max_length = 145;
          };
          media = {
            max_length = 200;
            album_art_only = true;
            hide_when_no_media = true;
          };
          workspaces = {
            show_labels = true;
            show_badge = true;
          };
          volume = {
            middle_click_command = "${lib.getExe pkgs.pavucontrol}";
          };
          notifications = {
            hide_when_no_unread = true;
          };
        };

        control_center = {
          sidebar = "compact";
          shortcuts = [
            { type = "wallpaper"; }
            { type = "notification"; }
            { type = "caffeine"; }
          ];
        };

        notification = {
          enable_daemon = true;
          background_opacity = 0.84;
        };

        audio = {
          enable_sounds = true;
          sound_volume = 0.5;
        };

        location = {
          address = "Shenzhen, China";
        };

        desktop_widgets = {
          enabled = true;
          widget_order = [
            {
              type = "media_player";
              output = "DP-1";
              cx = 1960;
              cy = 120;
              box_width = 400;
              box_height = 200;
            }
          ];
        };

        system.monitor = {
          enabled = true;
          cpu_poll_seconds = 2;
          memory_poll_seconds = 2;
          network_poll_seconds = 5;
        };

        nightlight = {
          enabled = false;
        };
      };
    };
  };
}
