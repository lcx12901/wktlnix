{
  config,
  lib,
  pkgs,
  namespace,
  ...
}:
let
  inherit (lib) mkIf getExe;

  cfg = config.${namespace}.programs.graphical.wms.hyprland;
in
{
  config = mkIf cfg.enable {
    wayland.windowManager.hyprland = {
      settings = {
        bind =
          [
            # ---------------
            # launcher
            # ---------------
            "SUPER, W, exec, $launcher"

            # ---------------
            # apps
            # ---------------
            "SUPER, RETURN, exec, $term"
            "SUPER, B, exec, $browser"
            "SUPER, V, exec, code"
            "SUPER, R, exec, bytedance-feishu"
            "SUPER, P, exec, NIXOS_OZONE_WL='' spotify"
            "ALT, E, exec, pkill fcitx5 -9;sleep 1;fcitx5 -d --replace; sleep 1;fcitx5-remote -r"

            # --------------
            # Clipboard
            # --------------
            "SUPER, X, exec, $cliphist"
            "SUPER, bracketleft, exec, $grimblast_active_clipboard"
            "SUPER, bracketright, exec, $grimblast_area_clipboard"
            "SUPER, Print, exec, $grimblast_screen_clipboard"
            # --------------
            # Hyprland
            # --------------
            "SUPER, C, killactive"
            "SUPER, F, fullscreen"
            "SUPER, Space, togglefloating"
            "SUPER, S, pseudo"
            "CTRLALT, Delete, exit"
            "SUPER, L, exec, hyprlock"

            # --------------
            # Focus
            # --------------
            "SUPER, left, movefocus, l"
            "SUPER, right, movefocus, r"
            "SUPER, up, movefocus, u"
            "SUPER, down, movefocus, d"

            # --------------
            # Move
            # --------------
            "SUPERSHIFT, left, movewindow, l"
            "SUPERSHIFT, right, movewindow, r"
            "SUPERSHIFT, up, movewindow, u"
            "SUPERSHIFT, down, movewindow, d"

            # --------------
            # Resize
            # --------------
            "SUPERCTRL, left, resizeactive, -20 0"
            "SUPERCTRL, right, resizeactive, 20 0"
            "SUPERCTRL, up, resizeactive, 0 -20"
            "SUPERCTRL, down, resizeactive, 0 20"

            # -------------
            # special workspace
            # -------------
            "SUPER, A, togglespecialworkspace, magic"
            "CTRLSHIFT, S, movetoworkspace, special:magic"
          ]
          # ----------------
          # workspace
          # ----------------
          # Switch workspaces with CTRL_ALT + [0-9]
          ++ (builtins.concatLists (
            builtins.genList (
              x:
              let
                ws =
                  let
                    c = (x + 1) / 10;
                  in
                  builtins.toString (x + 1 - (c * 10));
              in
              [
                "SUPER, ${ws}, workspace, ${toString (x + 1)}"
                "SUPERSHIFT, ${ws}, movetoworkspace, ${toString (x + 1)}"
              ]
            ) 10
          ));
        bindl = [
          ",XF86AudioMedia,exec,${getExe pkgs.playerctl} play-pause"
          ",XF86AudioPlay,exec,${getExe pkgs.playerctl} play-pause"
          ",XF86AudioStop,exec,${getExe pkgs.playerctl} stop"
          ",XF86AudioPrev,exec,${getExe pkgs.playerctl} previous"
          ",XF86AudioNext,exec,${getExe pkgs.playerctl} next"
        ];
        bindm = [
          "SUPER, mouse:272, movewindow"
          "SUPER, mouse:273, resizewindow"
        ];
      };
    };
  };
}
