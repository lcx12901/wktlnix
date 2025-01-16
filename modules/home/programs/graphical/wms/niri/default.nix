{
  inputs,
  config,
  lib,
  system,
  pkgs,
  namespace,
  ...
}:
let
  inherit (lib.${namespace}) mkBoolOpt enabled;
  inherit (lib) mkIf getExe getExe';
  inherit (inputs) nixpkgs-wayland;

  wl-copy = getExe' nixpkgs-wayland.packages.${system}.wl-clipboard "wl-copy";

  cfg = config.${namespace}.programs.graphical.wms.niri;
in
{
  options.${namespace}.programs.graphical.wms.niri = {
    enable = mkBoolOpt false "Whether or not to enable niri.";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      swww
      xwayland-satellite
    ];

    programs.niri.settings = {
      environment = {
        GDK_BACKEND = "wayland,x11";
        GSK_RENDERER = "gl";
        NIXOS_OZONE_WL = "1";
        QT_QPA_PLATFORM = "wayland";
        DISPLAY = ":0";
        MOZ_ENABLE_WAYLAND = "1";
        QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
        XDG_CURRENT_DESKTOP = "niri";
        XDG_SESSION_TYPE = "wayland";
      };

      outputs = {
        "DP-1" = {
          mode = {
            width = 2560;
            height = 1440;
            refresh = 164.998;
          };
          variable-refresh-rate = true;
        };
      };

      spawn-at-startup = [
        {
          command = [ "xwayland-satellite" ];
        }
        {
          command = [
            "fcitx5"
            "-dr"
          ];
        }
        {
          command = [ "${pkgs.swww}/bin/swww-daemon" ];
        }
        {
          command = [
            "swww"
            "img"
            "${inputs.wallpapers}/Hoshino-eye.jpg"
          ];
        }
      ];

      layout = {
        default-column-width.proportion = 2.0 / 3.0;
        preset-column-widths = [
          { proportion = 1.0 / 3.0; }
          { proportion = 2.0 / 3.0; }
          { proportion = 1.0 / 1.0; }
        ];
        gaps = 10;

        focus-ring = {
          enable = true;
          width = 4;
          active.color = "#ca9ee6";
          inactive.color = "#505050";
        };

        border = {
          enable = false;
          width = 4;
          active.color = "#ffc87f";
          inactive.color = "#505050";
        };
      };

      prefer-no-csd = true;
      hotkey-overlay.skip-at-startup = true;

      input = {
        focus-follows-mouse = {
          enable = true;
          max-scroll-amount = "0%";
        };
        warp-mouse-to-focus = true;
      };

      window-rules = [
        {
          geometry-corner-radius = {
            top-left = 10.0;
            top-right = 10.0;
            bottom-left = 10.0;
            bottom-right = 10.0;
          };
          clip-to-geometry = true;
        }
      ];

      animations = {
        enable = true;
        # all default
      };

      binds =
        with config.lib.niri.actions;
        let
          sh = spawn "sh" "-c";
        in
        {
          "Mod+Q".action = close-window;
          "Mod+Shift+E".action = quit;

          "Mod+Return".action.spawn = "kitty";
          "Mod+N".action.spawn = "neovide";
          "Mod+F".action.spawn = "firefox-devedition";
          "Mod+A".action.spawn = "ayugram-desktop";
          "Mod+T".action.spawn = "tsukimi";
          "Mod+W".action.spawn = [
            "${getExe config.programs.rofi.package}"
            "-show"
            "drun"
            "-n"
          ];
          "Mod+X".action =
            sh "${getExe pkgs.cliphist} list | ${getExe config.programs.rofi.package} -dmenu | ${getExe pkgs.cliphist} decode | ${wl-copy}";

          "Mod+Left".action = focus-column-left;
          "Mod+Down".action = focus-window-down;
          "Mod+Up".action = focus-window-up;
          "Mod+Right".action = focus-column-right;
          "Mod+H".action = focus-column-left;
          "Mod+L".action = focus-column-right;

          "Mod+Ctrl+left".action = move-column-left;
          "Mod+Ctrl+Down".action = move-window-down;
          "Mod+Ctrl+Up".action = move-window-up;
          "Mod+Ctrl+Right".action = move-column-right;
          "Mod+Ctrl+H".action = move-column-left;
          "Mod+Ctrl+L".action = move-column-right;

          "Mod+J".action = focus-window-or-workspace-down;
          "Mod+K".action = focus-window-or-workspace-up;
          "Mod+Ctrl+J".action = move-window-down-or-to-workspace-down;
          "Mod+Ctrl+K".action = move-window-up-or-to-workspace-up;

          "Mod+Home".action = focus-column-first;
          "Mod+End".action = focus-column-last;
          "Mod+Ctrl+Home".action = move-column-to-first;
          "Mod+Ctrl+End".action = move-column-to-last;

          "Mod+Page_Down".action = focus-workspace-down;
          "Mod+Page_Up".action = focus-workspace-up;

          "Mod+C".action = center-column;

          "Mod+Shift+1".action.move-window-to-workspace = 1;
          "Mod+Shift+2".action.move-window-to-workspace = 2;
          "Mod+Shift+3".action.move-window-to-workspace = 3;
          "Mod+Shift+4".action.move-window-to-workspace = 4;
          "Mod+Shift+5".action.move-window-to-workspace = 5;
          "Mod+Shift+6".action.move-window-to-workspace = 6;
          "Mod+Shift+7".action.move-window-to-workspace = 7;
          "Mod+Shift+8".action.move-window-to-workspace = 8;
          "Mod+Shift+9".action.move-window-to-workspace = 9;
          "Mod+Shift+0".action.move-window-to-workspace = 10;

          "Mod+1".action.focus-workspace = 1;
          "Mod+2".action.focus-workspace = 2;
          "Mod+3".action.focus-workspace = 3;
          "Mod+4".action.focus-workspace = 4;
          "Mod+5".action.focus-workspace = 5;
          "Mod+6".action.focus-workspace = 6;
          "Mod+7".action.focus-workspace = 7;
          "Mod+8".action.focus-workspace = 8;
          "Mod+9".action.focus-workspace = 9;
          "Mod+0".action.focus-workspace = 10;

          "Mod+Shift+H".action.set-column-width = "-5%";
          "Mod+Shift+L".action.set-column-width = "+5%";

          "Print".action = screenshot;
          "Ctrl+Print".action = screenshot-screen;
          "Alt+Print".action = screenshot-window;
        };
    };

    wktlnix = {
      programs = {
        terminal = {
          emulators.kitty = enabled;
          tools.cava = enabled;
        };
        graphical = {
          screenlockers.hyprlock = enabled;
          addons = {
            fcitx5 = enabled;
            mako = enabled;
            clipboard = enabled;
            waybar = enabled;
          };
          launchers.rofi = enabled;
        };
      };

      theme = {
        gtk = enabled;
        catppuccin = enabled;
      };
    };
  };
}
