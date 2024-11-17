{
  config,
  lib,
  pkgs,
  namespace,
  ...
}:
let
  inherit (lib) mkIf;
  inherit (lib.${namespace}) mkBoolOpt enabled;

  cfg = config.${namespace}.programs.terminal.media.mpd;
in
{
  options.${namespace}.programs.terminal.media.mpd = {
    enable = mkBoolOpt false "Whether or not to enable support for mpd.";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      playerctl # CLI interface for playerctld
      mpc_cli # CLI interface for mpd
    ];

    services = {
      playerctld = enabled;
      mpris-proxy = enabled;
      mpd-mpris = enabled;

      mpd = {
        enable = true;
        musicDirectory = "${config.${namespace}.user.home}/Music";
        network = {
          startWhenNeeded = true;
          listenAddress = "127.0.0.1";
          port = 6600;
        };

        extraConfig = ''
          auto_update           "yes"
          volume_normalization  "yes"
          restore_paused        "yes"
          filesystem_charset    "UTF-8"

          audio_output {
            type                "pipewire"
            name                "PipeWire"
          }

          audio_output {
            type                "fifo"
            name                "Visualiser"
            path                "/tmp/mpd.fifo"
            format              "44100:16:2"
          }

          audio_output {
            type		              "httpd"
            name		              "lossless"
            encoder		          "flac"
            port		              "8000"
            max_clients	        "8"
            mixer_type	          "software"
            format		            "44100:16:2"
          }
        '';
      };

      # MPRIS 2 support to mpd
      mpdris2 = {
        enable = true;
        notifications = true;
        multimediaKeys = true;
        mpd = {
          inherit (config.services.mpd) musicDirectory;
        };
      };
    };

    xdg.configFile."mpd/mpd.conf".text = ''
      # Required files
      db_file            "~/.config/mpd/database"
      log_file           "~/.config/mpd/log"

      # Optional
      music_directory    "~/Music"
      playlist_directory "~/.config/mpd/playlists"
      pid_file           "~/.config/mpd/pid"
      state_file         "~/.config/mpd/state"
      sticker_file       "~/.config/mpd/sticker.sql"
    '';
  };
}
