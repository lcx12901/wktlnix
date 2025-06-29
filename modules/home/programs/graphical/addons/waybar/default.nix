{
  config,
  lib,
  namespace,
  pkgs,
  ...
}:
let
  cfg = config.${namespace}.programs.graphical.addons.waybar;

  colors = config.lib.stylix.colors;
in
{
  options.${namespace}.programs.graphical.addons.waybar = {
    enable = lib.mkEnableOption " waybar";
  };

  config = lib.mkIf cfg.enable {
    programs.waybar = with colors; {
      enable = true;

      settings = [
        {
          position = "top";
          layer = "top";

          modules-left = [
            "niri/window"
          ];
          modules-center = [
            "clock"
          ];
          modules-right = [
            "tray"
            "network"
            "memory"
            "pulseaudio"
          ];

          "niri/window" = {
            format = "{}";
            separate-outputs = true;
            icon = true;
            icon-size = 18;
          };
          memory = {
            interval = 30;
            format = "<span foreground='#${base0E}'>󰍛 </span> {used:0.1f}G/{total:0.1f}G";
            on-click = "kitty --class=htop,htop -e htop";
          };
          tray = {
            icon-size = 16;
            spacing = 10;
          };
          clock = {
            interval = 1;
            format = "<span foreground='#${base0E}'> </span> {:%a %d %H:%M:%S}";
            tooltip-format = "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>";
            on-click = "kitty --class=clock,clock --title=clock -o remember_window_size=no -o initial_window_width=600 -o initial_window_height=200 -e tty-clock -s -c -C 5";
          };
          network = {
            interval = 1;
            format-wifi = "󰜷 {bandwidthUpBytes} 󰜮 {bandwidthDownBytes}";
            format-ethernet = "󰜷 {bandwidthUpBytes} 󰜮 {bandwidthDownBytes}";
            tooltip-format = "󰈀 {ifname} via {gwaddr}";
            format-linked = "󰈁 {ifname} (No IP)";
            format-disconnected = " Disconnected";
            format-alt = "{ifname}: {ipaddr}/{cidr}";
          };
          pulseaudio =
            let
              wpctl = "${lib.getExe' pkgs.wireplumber "wpctl"}";
            in
            {
              on-click = "${wpctl} set-mute @DEFAULT_AUDIO_SINK@ toggle";
              on-scroll-up = "${wpctl} set-volume @DEFAULT_AUDIO_SINK@ 0.01+";
              on-scroll-down = "${wpctl} set-volume @DEFAULT_AUDIO_SINK@ 0.01-";
              format = "<span size='13000' foreground='#${base0A}'>{icon} </span>{volume}%";
              format-muted = "<span size='13000' foreground='#${base0A}'>  </span>Muted";
              format-icons = {
                headphone = "󱡏";
                hands-free = "";
                headset = "󱡏";
                phone = "";
                portable = "";
                car = "";
                default = [
                  "󰕿"
                  "󰖀"
                  "󰕾"
                  "󰕾"
                ];
              };
            };
        }
      ];

      style = with withHashtag; ''
        @define-color base00 ${base00};
        @define-color base01 ${base01};
        @define-color base04 ${base04};
        @define-color base05 ${base05};
        @define-color base06 ${base06};
        @define-color base07 ${base07};
        @define-color base08 ${base08};
        @define-color base0A ${base0A};
        @define-color base0B ${base0B};
        @define-color base0D ${base0D};
        @define-color base0E ${base0E};
        @define-color base0F ${base0F};

        * {
          /* all: unset; */
          font-size: 14px;
          font-family: "${config.stylix.fonts.monospace.name}";
          min-height: 0;
        }

        window#waybar {
          background: transparent;
        }

        tooltip {
          background: @base01;
          border-radius: 5px;
          border-width: 2px;
          border-style: solid;
          border-color: @base07;
        }

        #network,
        #clock,
        #pulseaudio,
        #memory,
        #tray,
        #window {
          padding: 4px 10px;
          background: shade(alpha(@base00, 0.9), 1);
          text-shadow: 1px 1px 2px rgba(0, 0, 0, 0.377);
          color: @base05;
          margin-top: 10px;
          margin-bottom: 5px;
          margin-left: 5px;
          margin-right: 5px;
          box-shadow: 1px 2px 2px #101010;
          border-radius: 10px;
        }

        #tray > .passive {
          -gtk-icon-effect: dim;
        }

        #tray > .needs-attention {
          -gtk-icon-effect: highlight;
        }

        #window {
          color: @base00;
          background: radial-gradient(circle, @base05 0%, @base07 100%);
          background-size: 400% 400%;
          animation: gradient_f 40s ease-in-out infinite;
          transition: all 0.3s cubic-bezier(0.55, -0.68, 0.48, 1.682);
        }

        window#waybar.empty #window {
          background: none;
          background-color: transparent;
          box-shadow: none;
        }

        @keyframes gradient {
          0% {
            background-position: 0% 50%;
          }
          50% {
            background-position: 100% 30%;
          }
          100% {
            background-position: 0% 50%;
          }
        }

        @keyframes gradient_f {
          0% {
            background-position: 0% 200%;
          }
          50% {
            background-position: 200% 0%;
          }
          100% {
            background-position: 400% 200%;
          }
        }

        @keyframes gradient_f_nh {
          0% {
            background-position: 0% 200%;
          }
          100% {
            background-position: 200% 200%;
          }
        }

        @keyframes gradient_rv {
          0% {
            background-position: 200% 200%;
          }
          100% {
            background-position: 0% 200%;
          }
        }
      '';
    };
  };
}
