{
  pkgs,
  ...
}:
{
  "custom/launcher" = {
    format = "";
    tooltip = false;
  };
  "cava#left" = {
    framerate = 120;
    autosens = 1;
    bars = 14;
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
    bars = 14;
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

  pulseaudio = {
    format = "{icon} {volume}%";
    format-bluetooth = "{volume}% {icon}";
    format-muted = "󰝟";
    format-icons = {
      headphone = "";
      default = [
        ""
        ""
        ""
      ];
    };
    scroll-step = 2;
    on-click = "${pkgs.killall}/bin/killall pavucontrol || ${pkgs.pavucontrol}/bin/pavucontrol";
  };

  mpd = {
    interval = 1;
    format = "{stateIcon} {title} ({elapsedTime:%M:%S}/{totalTime:%M:%S}) ";
    format-stopped = "Stopped ";
    format-disconnected = " Disconnected";
    unknown-tag = "N/A";
    state-icons = {
      paused = "";
      playing = "";
    };
    on-click = "mpc toggle";
    on-click-middle = "mpc prev";
    on-click-right = "mpc next";
    on-update = "";
    on-scroll-up = "mpc seek +00:00:01";
    on-scroll-down = "mpc seek -00:00:01";
    smooth-scrolling-threshold = 1;
  };

  network = {
    interval = 1;
    format-wifi = "󰜷 {bandwidthUpBytes} 󰜮 {bandwidthDownBytes}";
    format-ethernet = "󰜷 {bandwidthUpBytes} 󰜮 {bandwidthDownBytes}";
    tooltip-format = "󰈀 {ifname} via {gwaddr}";
    format-linked = "󰈁 {ifname} (No IP)";
    format-disconnected = " Disconnected";
    format-alt = "󰈀 {ifname}: {ipaddr}/{cidr}";
  };

  tray = {
    spacing = 10;
  };

  clock = {
    tooltip-format = "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>";
    format = "󰃭 {:%a %d %b  󰅐 %I:%M:%S %p}";
    interval = 1;
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
