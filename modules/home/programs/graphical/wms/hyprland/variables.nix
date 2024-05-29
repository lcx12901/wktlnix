{
  config,
  inputs,
  lib,
  pkgs,
  system,
  namespace,
  ...
}:
let
  inherit (lib) mkIf getExe;

  cfg = config.${namespace}.programs.graphical.wms.hyprland;
in {
  config = mkIf cfg.enable {
    wayland.windowManager.hyprland = {
      settings = {
        monitor= ",highrr,auto,1";
        env = "HYPRLAND_TRACE,1";
        animations = {
          enabled = "yes";

          # Some default animations, see https://wiki.hyprland.org/Configuring/Animations/ for more
          bezier = [
            "easein, 0.47, 0, 0.745, 0.715"
            "myBezier, 0.05, 0.9, 0.1, 1.05"
            "overshot, 0.13, 0.99, 0.29, 1.1"
            "scurve, 0.98, 0.01, 0.02, 0.98"
          ];

          animation = [
            "border, 1, 10, default"
            "fade, 1, 10, default"
            "windows, 1, 5, overshot, popin 10%"
            "windowsOut, 1, 7, default, popin 10%"
            "workspaces, 1, 6, overshot, slide"
          ];
        };

        debug = {
          disable_logs = false;
        };

        decoration = {
          active_opacity = 0.95;
          fullscreen_opacity = 1.0;
          inactive_opacity = 0.9;
          rounding = 10;

          blur = {
            enabled = "yes";
            passes = 4;
            size = 5;
          };

          drop_shadow = true;
          shadow_ignore_window = true;
          shadow_range = 20;
          shadow_render_power = 3;
          "col.shadow" = "0x55161925";
          "col.shadow_inactive" = "0x22161925";
        };

        dwindle = {
          # See https://wiki.hyprland.org/Configuring/Dwindle-Layout/ for more
          force_split = 0;
          preserve_split = true; # you probably want this
          pseudotile = true; # master switch for pseudotiling. Enabling is bound to mainMod + P in the keybinds section below
        };

        general = {
          allow_tearing = true;
          border_size = 2;
          "col.active_border" = "rgba(7793D1FF)";
          "col.inactive_border" = "rgb(5e6798)";
          gaps_in = 5;
          gaps_out = 20;
          layout = "dwindle";
        };

        gestures = {
          workspace_swipe = true;
          workspace_swipe_fingers = 3;
          workspace_swipe_invert = false;
        };

        input = {
          follow_mouse = 1;
          kb_layout = "us";
          numlock_by_default = true;

          touchpad = {
            disable_while_typing = true;
            natural_scroll = "no";
            tap-to-click = true;
          };

          sensitivity = 0; # -1.0 - 1.0, 0 means no modification.
          # repeat_delay = 500; # Mimic the responsiveness of mac setup
          # repeat_rate = 50; # Mimic the responsiveness of mac setup
        };

        master = {
          # See https://wiki.hyprland.org/Configuring/Master-Layout/ for more
          new_is_master = true;
        };

        misc = {
          allow_session_lock_restore = true;
          disable_hyprland_logo = true;
          key_press_enables_dpms = true;
          mouse_move_enables_dpms = true;
          vrr = 2;
        };

        # unscale XWayland
        xwayland = {
          force_zero_scaling = true;
        };

        "$mainMod" = "SUPER";
        "$HYPER" = "SUPER_SHIFT_CTRL";
        "$ALT-HYPER" = "SHIFT_ALT_CTRL";
        "$RHYPER" = "SUPER_ALT_R_CTRL_R";
        "$LHYPER" = "SUPER_ALT_L_CTRL_L";

        # default applications
        "$term" = "[float;tile] ${getExe pkgs.kitty}";
        "$browser" = "${getExe pkgs.firefox-beta}";
      };
    };
  };
}