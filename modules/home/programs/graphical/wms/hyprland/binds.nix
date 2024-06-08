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
in {
  config = mkIf cfg.enable {
    wayland.windowManager.hyprland = {
      settings = {
        bind = [
          # █░░░█▀█░█░█░█▀█░█▀▀░█░█░█▀▀░█▀▄░█▀▀
          # █░░░█▀█░█░█░█░█░█░░░█▀█░█▀▀░█▀▄░▀▀█
          # ▀▀▀░▀░▀░▀▀▀░▀░▀░▀▀▀░▀░▀░▀▀▀░▀░▀░▀▀▀
          "$mainMod, R, exec, $launcher"

          # ░█▀█░█▀█░█▀█░█▀▀
          # ░█▀█░█▀▀░█▀▀░▀▀█
          # ░▀░▀░▀░░░▀░░░▀▀▀
          "$mainMod, C, killactive"
          "$mainMod, RETURN, exec, $term"
          "$mainMod, B, exec, $browser"
          "$mainMod, V, exec, code"

          # ░█░░░█▀█░█░█░█▀█░█░█░▀█▀
          # ░█░░░█▀█░░█░░█░█░█░█░░█░
          # ░▀▀▀░▀░▀░░▀░░▀▀▀░▀▀▀░░▀░
          "SUPER_ALT, V, togglefloating,"
          "$mainMod, P, pseudo, # dwindle"
          "$mainMod, J, togglesplit, # dwindle"
          "$mainMod, F, fullscreen"

          # ░█░█░▀█▀░█▀█░█▀▄░█▀█░█░█
          # ░█▄█░░█░░█░█░█░█░█░█░█▄█
          # ░▀░▀░▀▀▀░▀░▀░▀▀░░▀▀▀░▀░▀
          # WINDOWS FOCUS
          "$mainMod,left,movefocus,l"
          "$mainMod,right,movefocus,r"
          "$mainMod,up,movefocus,u"
          "$mainMod,down,movefocus,d"

          # Move window
          "ALT,left,movewindow,l"
          "ALT,right,movewindow,r"
          "ALT,up,movewindow,u"
          "ALT,down,movewindow,d"

          "CTRL_SHIFT,h,resizeactive,-10% 0"
          "CTRL_SHIFT,l,resizeactive,10% 0"

          # ░█░█░█▀█░█▀▄░█░█░█▀▀░█▀█░█▀█░█▀▀░█▀▀
          # ░█▄█░█░█░█▀▄░█▀▄░▀▀█░█▀▀░█▀█░█░░░█▀▀
          # ░▀░▀░▀▀▀░▀░▀░▀░▀░▀▀▀░▀░░░▀░▀░▀▀▀░▀▀▀
          # Swipe through existing workspaces with CTRL_ALT + left / right
          "CTRL_ALT, right, workspace, +1"
          "CTRL_ALT, l, workspace, +1"
          "CTRL_ALT, left, workspace, -1"
          "CTRL_ALT, h, workspace, -1"
          # Scroll through existing workspaces with CTRL_ALT + scroll
          "CTRL_ALT, mouse_down, workspace, e+1"
          "CTRL_ALT, mouse_up, workspace, e-1"

          # Move to workspace left/right
          "$ALT-HYPER, right, movetoworkspace, +1"
          "$ALT-HYPER, l, movetoworkspace, +1"
          "$ALT-HYPER, left, movetoworkspace, -1"
          "$ALT-HYPER, h, movetoworkspace, -1"

          # MOVING silently LEFT/RIGHT
          "SUPER_SHIFT, right, movetoworkspacesilent, +1"
          "SUPER_SHIFT, l, movetoworkspacesilent, +1"
          "SUPER_SHIFT, left, movetoworkspacesilent, -1"
          "SUPER_SHIFT, h, movetoworkspacesilent, -1"

          # Scratchpad
          "SUPER_SHIFT,grave,movetoworkspace,special:scratchpad"
          "SUPER,grave,togglespecialworkspace,scratchpad"

          # Inactive
          "ALT_SHIFT,grave,movetoworkspace,special:inactive"
          "ALT,grave,togglespecialworkspace,inactive"

          # ░█▄█░█▀█░█▀█░▀█▀░▀█▀░█▀█░█▀▄
          # ░█░█░█░█░█░█░░█░░░█░░█░█░█▀▄
          # ░▀░▀░▀▀▀░▀░▀░▀▀▀░░▀░░▀▀▀░▀░▀
          # simple movement between monitors
          "SUPER_ALT, up, focusmonitor, u"
          "SUPER_ALT, k, focusmonitor, u"
          "SUPER_ALT, down, focusmonitor, d"
          "SUPER_ALT, j, focusmonitor, d"
          "SUPER_ALT, left, focusmonitor, l"
          "SUPER_ALT, h, focusmonitor, l"
          "SUPER_ALT, right, focusmonitor, r"
          "SUPER_ALT, l, focusmonitor, r"

          # moving current workspace to monitor
          "$HYPER,down,movecurrentworkspacetomonitor,d"
          "$HYPER,j,movecurrentworkspacetomonitor,d"
          "$HYPER,up,movecurrentworkspacetomonitor,u"
          "$HYPER,k,movecurrentworkspacetomonitor,u"
          "$HYPER,left,movecurrentworkspacetomonitor,l"
          "$HYPER,h,movecurrentworkspacetomonitor,l"
          "$HYPER,right,movecurrentworkspacetomonitor,r"
          "$HYPER,l,movecurrentworkspacetomonitor,r"
        ]
        # ░█░█░█▀█░█▀▄░█░█░█▀▀░█▀█░█▀█░█▀▀░█▀▀
        # ░█▄█░█░█░█▀▄░█▀▄░▀▀█░█▀▀░█▀█░█░░░█▀▀
        # ░▀░▀░▀▀▀░▀░▀░▀░▀░▀▀▀░▀░░░▀░▀░▀▀▀░▀▀▀
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
              "$mainMod, ${ws}, workspace, ${toString (x + 1)}"
              "$mainMod SHIFT, ${ws}, movetoworkspace, ${toString (x + 1)}"
            ]
          ) 10
        ));
        bindl = [
          # ░█▀▀░█░█░█▀▀░▀█▀░█▀▀░█▄█
          # ░▀▀█░░█░░▀▀█░░█░░█▀▀░█░█
          # ░▀▀▀░░▀░░▀▀▀░░▀░░▀▀▀░▀░▀


          # ░█▄█░█▀▀░█▀▄░▀█▀░█▀█
          # ░█░█░█▀▀░█░█░░█░░█▀█
          # ░▀░▀░▀▀▀░▀▀░░▀▀▀░▀░▀
          ",XF86AudioRaiseVolume,exec,wpctl set-volume @DEFAULT_AUDIO_SINK@ 2.5%+"
          ",XF86AudioLowerVolume,exec,wpctl set-volume @DEFAULT_AUDIO_SINK@ 2.5%-"
          ",XF86AudioMute,exec,wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
          ",XF86MonBrightnessUp,exec,light -A 5"
          ",XF86MonBrightnessDown,exec,light -U 5"
          ",XF86AudioMedia,exec,${getExe pkgs.playerctl} play-pause"
          ",XF86AudioPlay,exec,${getExe pkgs.playerctl} play-pause"
          ",XF86AudioStop,exec,${getExe pkgs.playerctl} stop"
          ",XF86AudioPrev,exec,${getExe pkgs.playerctl} previous"
          ",XF86AudioNext,exec,${getExe pkgs.playerctl} next"
        ];
        bindm = [
          # Move/resize windows with mainMod + LMB/RMB and dragging
          "$mainMod, mouse:272, movewindow #left click"
          "CTRL_SHIFT, mouse:272, movewindow #left click"
          "$mainMod, mouse:273, resizewindow #right click"
          "CTRL_SHIFT, mouse:273, resizewindow #right click"
        ];
      };
    };
  };
}
