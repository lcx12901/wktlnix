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
    home.packages = [ pkgs.evtest ];

    programs.noctalia = {
      enable = true;

      settings = {
        shell = {
          ui_scale = 1.0;
          font_family = "Maple Mono NF CN";
          telemetry_enabled = false;
          clipboard_enabled = true;
          clipboard_auto_paste = "auto";
          avatar_path = lib.file.get-file ".face";

          panel = {
            clipboard_placement = "floating";
          };
        };

        theme = {
          mode = "dark";
          source = "wallpaper";
        };

        wallpaper = {
          enabled = true;
          fill_mode = "crop";
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
          radius = 100;
          margin_edge = 10;
          margin_ends = 180;
          padding = 16;
          widget_spacing = 16;
          scale = 1.0;

          start = [
            "clock"
            "cpu"
            "mem"
            "active_window"
            "media"
          ];
          center = [
            "workspaces"
            "cat"
          ];
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
          notifications = {
            hide_when_no_unread = true;
          };
          cat = {
            type = "noctalia/bongocat:cat";
            input_devices = [ "/dev/input/event4" ];
            scale = 1.25;
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

        plugins = {
          enabled = [ "noctalia/bongocat" ];
          source = [
            {
              enabled = true;
              name = "official";
              kind = "git";
              location = "https://github.com/noctalia-dev/official-plugins";
              auto_update = true;
            }
          ];
        };
      };
    };

    home.persistence = lib.mkIf persist {
      "/persist" = {
        directories = [
          ".local/state/noctalia"
          ".local/cache/noctalia"
        ];
      };
    };
  };
}
