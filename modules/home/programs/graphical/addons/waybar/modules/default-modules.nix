{
  lib,
  pkgs,
  ...
}: let
  inherit (lib) getExe';
in {
  "custom/launcher" = {
    format = "";
    tooltip = false;
  };
  "cava#left" = {
    framerate = 120;
    autosens = 1;
    bars = 16;
    method = "pipewire";
    source = "auto";
    bar_delimiter = 0;
    input_delay = 2;
    sleep_timer = 2;
    hide_on_silence = true;
    format-icons = [
      "<span foreground='#f5bde6'>▁</span>"
      "<span foreground='#f5bde6'>▂</span>"
      "<span foreground='#f5bde6'>▃</span>"
      "<span foreground='#f5bde6'>▄</span>"
      "<span foreground='#b7bdf8'>▅</span>"
      "<span foreground='#b7bdf8'>▆</span>"
      "<span foreground='#b7bdf8'>▇</span>"
      "<span foreground='#b7bdf8'>█</span>"
    ];
  };

  "cava#right" = {
    framerate = 120;
    autosens = 1;
    bars = 16;
    method = "pipewire";
    source = "auto";
    bar_delimiter = 0;
    input_delay = 2;
    sleep_timer = 2;
    hide_on_silence = true;
    format-icons = [
      "<span foreground='#f5bde6'>▁</span>"
      "<span foreground='#f5bde6'>▂</span>"
      "<span foreground='#f5bde6'>▃</span>"
      "<span foreground='#f5bde6'>▄</span>"
      "<span foreground='#b7bdf8'>▅</span>"
      "<span foreground='#b7bdf8'>▆</span>"
      "<span foreground='#b7bdf8'>▇</span>"
      "<span foreground='#b7bdf8'>█</span>"
    ];
  };

  cpu = {
    format = " {usage}%";
    tooltip = true;
    interval = 5;
    states = {
      "50" = 50;
      "60" = 75;
      "70" = 90;
    };
  };

  memory = {
    format = " {}%";
    interval = 5;
  };

  disk = {
    format = "󰋊 {percentage_used}%";
  };

  mpris = {
    format = "{player_icon} {status_icon} {dynamic}";
    format-paused = "{player_icon} {status_icon} <i>{dynamic}</i>";
    max-length = 45;
    player-icons = {
      chromium = "";
      default = "";
      firefox = "";
      mopidy = "";
      mpv = "";
      spotify = "";
    };
    status-icons = {
      paused = "";
      playing = "";
      stopped = "";
    };
  };

  mpd = {
    format = "{stateIcon} {consumeIcon}{randomIcon}{repeatIcon}{singleIcon}{artist} - {album} - {title} ({elapsedTime:%M:%S}/{totalTime:%M:%S}) ⸨{songPosition}|{queueLength}⸩ {volume}% ";
    format-disconnected = "Disconnected ";
    format-stopped = "{consumeIcon}{randomIcon}{repeatIcon}{singleIcon}Stopped ";
    unknown-tag = "N/A";
    interval = 2;
    consume-icons = {
      on = " ";
    };
    random-icons = {
      off = "<span color=\"#f53c3c\"></span> ";
      on = " ";
    };
    repeat-icons = {
      on = " ";
    };
    single-icons = {
      on = "1 ";
    };
    state-icons = {
      paused = "";
      playing = "";
    };
    tooltip-format = "MPD (connected)";
    tooltip-format-disconnected = "MPD (disconnected)";
  };

  network = let
    nm-editor = "${getExe' pkgs.networkmanagerapplet "nm-connection-editor"}";
  in {
    interval = 1;
    format-wifi = "󰜷 {bandwidthUpBytes} 󰜮 {bandwidthDownBytes}";
    format-ethernet = "󰜷 {bandwidthUpBytes} 󰜮 {bandwidthDownBytes}";
    tooltip-format = "󰈀 {ifname} via {gwaddr}";
    format-linked = "󰈁 {ifname} (No IP)";
    format-disconnected = " Disconnected";
    format-alt = "󰈀 {ifname}: {ipaddr}/{cidr}";
    on-click-right = "${nm-editor}";
  };

  tray = {
    spacing = 10;
  };

  clock = {
    tooltip-format = "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>";
    format = "󰃭 {:%a %d %b  󰅐 %I:%M %p}";
    calendar = {
      mode = "year";
      mode-mon-col = 3;
      weeks-pos = "right";
      on-scroll = 1;
      format = {
        months = "<span color='#f4dbd6'><b>{}</b></span>";
        days = "<span color='#f0c6c6'><b>{}</b></span>";
        weeks = "<span color='#8bd5ca'><b>W{}</b></span>";
        weekdays = "<span color='#eed49f'><b>{}</b></span>";
        today = "<span color='#ed8796'><b><u>{}</u></b></span>";
      };
    };
    actions = {
      on-click-right = "mode";
      on-click-forward = "tz_up";
      on-click-backward = "tz_down";
      on-scroll-up = "shift_up";
      on-scroll-down = "shift_down";
    };
  };
}
