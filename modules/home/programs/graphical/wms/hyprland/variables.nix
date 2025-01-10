{
  inputs,
  config,
  lib,
  pkgs,
  system,
  namespace,
  ...
}:
let
  inherit (lib) mkIf getExe getExe';
  inherit (inputs) nixpkgs-wayland hyprland-contrib;

  wl-copy = getExe' nixpkgs-wayland.packages.${system}.wl-clipboard "wl-copy";
  grimblast = getExe hyprland-contrib.packages.${system}.grimblast;

  cfg = config.${namespace}.programs.graphical.wms.hyprland;
in
{
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
          pseudotile = 1;
          force_split = 0;
          preserve_split = true;
          smart_split = false;
          smart_resizing = false;
        };

        decoration = {
          rounding = 10;
          rounding_power = 4.0;
          active_opacity = 0.9;
          inactive_opacity = 0.9;

          blur = {
            enabled = true;
            xray = true;
            special = false;
            new_optimizations = true;
            size = 3;
            passes = 3;
            brightness = 1;
            ignore_opacity = true;
            noise = 1.0e-2;
            contrast = 1;
            popups = true;
            # popups_ignorealpha = 0.6;
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
            "overshot,0.13,0.99,0.29,1.1"
          ];

          animation = [
            "windows,1,4,overshot,slide"
            "border,1,10,default"
            "fade,1,10,default"
            "workspaces,1,6,overshot,slidevert"
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
          #
          disable_hyprland_logo = true;
          force_default_wallpaper = 0;
          new_window_takes_over_fullscreen = 2;
          allow_session_lock_restore = true;
          initial_workspace_tracking = false;
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
        "$launchpad" =
          "${getExe config.programs.rofi.package} -show drun -config '~/.config/rofi/appmenu/rofi.rasi'";
        "$cliphist" =
          "${getExe pkgs.cliphist} list | ${getExe config.programs.rofi.package} -dmenu | ${getExe pkgs.cliphist} decode | ${wl-copy}";
        "$grimblast_area_clipboard" = "${grimblast} --freeze --notify copy area";
        "$grimblast_active_clipboard" = "${grimblast} --notify copy active";
        "$grimblast_screen_clipboard" = "${grimblast} --notify copy screen";
      };
    };
  };
}
