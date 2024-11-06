{
  inputs,
  config,
  lib,
  pkgs,
  system,
  namespace,
  ...
}: let
  inherit (lib) mkIf getExe getExe';
  inherit (inputs) nixpkgs-wayland hyprland-contrib;

  wl-copy = getExe' nixpkgs-wayland.packages.${system}.wl-clipboard "wl-copy";
  grimblast = getExe hyprland-contrib.packages.${system}.grimblast;

  cfg = config.${namespace}.programs.graphical.wms.hyprland;
in {
  # follow this dotfiles: https://github.com/end-4/dots-hyprland
  config = mkIf cfg.enable {
    wayland.windowManager.hyprland = {
      settings = {
        inherit (cfg) monitor;

        env = "HYPRLAND_TRACE,1";

        input = {
          numlock_by_default = true;
          follow_mouse = 1;
          kb_layout = "us";
          repeat_delay = 250;
          repeat_rate = 35;

          touchpad = {
            natural_scroll = "yes";
            disable_while_typing = true;
            clickfinger_behavior = true;
            scroll_factor = 0.5;
          };

          special_fallthrough = true;
        };

        gestures = {
          workspace_swipe = true;
          workspace_swipe_distance = 700;
          workspace_swipe_fingers = 4;
          workspace_swipe_cancel_ratio = 0.2;
          workspace_swipe_min_speed_to_force = 5;
          workspace_swipe_direction_lock = true;
          workspace_swipe_direction_lock_threshold = 10;
          workspace_swipe_create_new = true;
        };

        general = {
          gaps_in = 4;
          gaps_out = 6;
          gaps_workspaces = 50;
          border_size = 3;

          "col.active_border" = "rgba(F7DCDE39)";
          "col.inactive_border" = "rgba(A58A8D30)";

          resize_on_border = true;
          no_focus_fallback = true;
          layout = "dwindle";

          allow_tearing = true; # This just allows the `immediate` window rule to work
        };

        dwindle = {
          preserve_split = true;
          smart_split = false;
          smart_resizing = false;
        };

        decoration = {
          rounding = 10;
          active_opacity = 0.9;
          inactive_opacity = 0.9;

          blur = {
            enabled = true;
            xray = true;
            special = false;
            new_optimizations = true;
            size = 14;
            passes = 4;
            brightness = 1;
            noise = 0.01;
            contrast = 1;
            popups = true;
            popups_ignorealpha = 0.6;
          };

          shadow = {
            enabled = true;
            range = 20;
            offset = "0 2";
            render_power = 4;
            color = "rgba(0000002A)";
            ignore_window = true;
          };

          # Dim
          dim_inactive = false;
          dim_strength = 0.1;
          dim_special = 0;
        };

        animations = {
          enabled = true;

          bezier = [
            "linear, 0, 0, 1, 1"
            "md3_standard, 0.2, 0, 0, 1"
            "md3_decel, 0.05, 0.7, 0.1, 1"
            "md3_accel, 0.3, 0, 0.8, 0.15"
            "overshot, 0.05, 0.9, 0.1, 1.1"
            "crazyshot, 0.1, 1.5, 0.76, 0.92"
            "hyprnostretch, 0.05, 0.9, 0.1, 1.0"
            "menu_decel, 0.1, 1, 0, 1"
            "menu_accel, 0.38, 0.04, 1, 0.07"
            "easeInOutCirc, 0.85, 0, 0.15, 1"
            "easeOutCirc, 0, 0.55, 0.45, 1"
            "easeOutExpo, 0.16, 1, 0.3, 1"
            "softAcDecel, 0.26, 0.26, 0.15, 1"
            "md2, 0.4, 0, 0.2, 1" # use with .2s duration
          ];

          animation = [
            "windows, 1, 3, md3_decel, popin 60%"
            "windowsIn, 1, 3, md3_decel, popin 60%"
            "windowsOut, 1, 3, md3_accel, popin 60%"
            "border, 1, 10, default"
            "fade, 1, 3, md3_decel"
            "layersIn, 1, 3, menu_decel, slide"
            "layersOut, 1, 1.6, menu_accel"
            "fadeLayersIn, 1, 2, menu_decel"
            "fadeLayersOut, 1, 4.5, menu_accel"
            "workspaces, 1, 7, menu_decel, slide"
            "specialWorkspace, 1, 3, md3_decel, slidevert"
          ];
        };

        misc = {
          vfr = 1;
          vrr = 1;
          focus_on_activate = true;
          animate_manual_resizes = false;
          animate_mouse_windowdragging = false;
          enable_swallow = false;
          swallow_regex = "(foot|kitty|allacritty|Alacritty)";

          disable_hyprland_logo = true;
          force_default_wallpaper = 0;
          new_window_takes_over_fullscreen = 2;
          allow_session_lock_restore = true;
          initial_workspace_tracking = false;

          background_color = "rgba(1D1011FF)";
        };

        master = {
          # See https://wiki.hyprland.org/Configuring/Master-Layout/ for more
          new_status = "master";
        };

        # # unscale XWayland
        xwayland = {
          force_zero_scaling = true;
        };

        # default applications
        "$term" = "${getExe pkgs.kitty}";
        "$browser" = "${getExe pkgs.firefox-devedition}";
        "$launcher" = "${getExe config.programs.rofi.package} -show drun -n";
        "$launcher_alt" = "${getExe config.programs.rofi.package} -show calc";
        "$launchpad" = "${getExe config.programs.rofi.package} -show drun -config '~/.config/rofi/appmenu/rofi.rasi'";
        "$cliphist" = "${getExe pkgs.cliphist} list | ${getExe config.programs.rofi.package} -dmenu | ${getExe pkgs.cliphist} decode | ${wl-copy}";
        "$grimblast_area_clipboard" = "${grimblast} --freeze --notify copy area";
        "$grimblast_active_clipboard" = "${grimblast} --notify copy active";
        "$grimblast_screen_clipboard" = "${grimblast} --notify copy screen";
      };
    };
  };
}
