{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) mkIf getExe getExe';
  inherit (lib.kdl)
    node
    leaf
    flag
    plain
    ;

  node' =
    name: arg: children:
    node name [ arg ] children;

  leaf' = name: arg: leaf name [ arg ];

  spawn = leaf "spawn";

  sh = getExe' config.programs.bash.package "sh";
  flameshot = getExe config.services.flameshot.package;
  vlc = getExe pkgs.vlc;
  telegram = getExe pkgs.telegram-desktop;
  rofi = getExe config.programs.rofi.package;
  hyprlock = getExe config.programs.hyprlock.package;
  wpctl = getExe' pkgs.wireplumber "wpctl";
  kitty = getExe config.programs.kitty.package;
  wl-copy = getExe' pkgs.wl-clipboard "wl-copy";
  cliphist = getExe' pkgs.cliphist "cliphist";
in
{
  config = mkIf config.wktlnix.programs.graphical.wms.niri.enable {
    programs.niri = {
      config = [
        (plain "binds" [
          (plain "Mod+X" [
            (spawn [
              sh
              "-c"
              "${cliphist} list | ${rofi} -dmenu | ${cliphist} decode | ${wl-copy}"
            ])
          ])
          (plain "Mod+W" [
            (spawn [
              rofi
              "-show"
              "drun"
              "-n"
            ])
          ])
          (plain "Mod+Shift+P" [
            (spawn [ hyprlock ])
          ])
          (plain "Mod+Shift+Slash" [
            (flag "show-hotkey-overlay")
          ])
          (plain "Mod+Return" [
            (spawn [ kitty ])
          ])
          (plain "Mod+T" [
            (spawn [ telegram ])
          ])
          (plain "Mod+V" [
            (spawn [ vlc ])
          ])
          (plain "Mod+B" [
            (spawn [ "firefox" ])
          ])
          (plain "Mod+Space" [
            (flag "toggle-column-tabbed-display")
          ])
          (node' "XF86AudioRaiseVolume" { allow-when-locked = true; } [
            (spawn [
              wpctl
              "set-volume"
              "@DEFAULT_AUDIO_SINK@"
              "0.1+"
            ])
          ])
          (node' "XF86AudioLowerVolume" { allow-when-locked = true; } [
            (spawn [
              wpctl
              "set-volume"
              "@DEFAULT_AUDIO_SINK@"
              "0.1-"
            ])
          ])
          (node' "XF86AudioMute" { allow-when-locked = true; } [
            (spawn [
              wpctl
              "set-volume"
              "@DEFAULT_AUDIO_SINK@"
              "toggle"
            ])
          ])
          (node' "XF86AudioMicMute" { allow-when-locked = true; } [
            (spawn [
              wpctl
              "set-volume"
              "@DEFAULT_AUDIO_SOURCE@"
              "toggle"
            ])
          ])
          (plain "Mod+Q" [
            (flag "close-window")
          ])
          (node' "Mod+O" { repeat = false; } [
            (flag "toggle-overview")
          ])
          (plain "Mod+Left" [
            (flag "focus-column-left")
          ])
          (plain "Mod+Down" [
            (flag "focus-window-down")
          ])
          (plain "Mod+Up" [
            (flag "focus-window-up")
          ])
          (plain "Mod+Right" [
            (flag "focus-column-right")
          ])
          (plain "Mod+H" [
            (flag "focus-column-or-monitor-left")
          ])
          (plain "Mod+J" [
            (flag "focus-window-or-workspace-down")
          ])
          (plain "Mod+K" [
            (flag "focus-window-or-workspace-up")
          ])
          (plain "Mod+L" [
            (flag "focus-column-or-monitor-right")
          ])
          (plain "Mod+Shift+Left" [
            (flag "move-column-left")
          ])
          (plain "Mod+Shift+Down" [
            (flag "move-window-down")
          ])
          (plain "Mod+Shift+Up" [
            (flag "move-window-up")
          ])
          (plain "Mod+Shift+Right" [
            (flag "move-column-right")
          ])
          (plain "Mod+Shift+H" [
            (flag "move-column-left-or-to-monitor-left")
          ])
          (plain "Mod+Shift+J" [
            (flag "move-window-down-or-to-workspace-down")
          ])
          (plain "Mod+Shift+K" [
            (flag "move-window-up-or-to-workspace-up")
          ])
          (plain "Mod+Shift+L" [
            (flag "move-column-right-or-to-monitor-right")
          ])
          (plain "Mod+Home" [
            (flag "focus-column-first")
          ])
          (plain "Mod+End" [
            (flag "focus-column-last")
          ])
          (plain "Mod+Ctrl+Home" [
            (flag "move-column-to-first")
          ])
          (plain "Mod+Ctrl+End" [
            (flag "move-column-to-last")
          ])
          (plain "Mod+Ctrl+Left" [
            (flag "focus-monitor-left")
          ])
          (plain "Mod+Ctrl+Down" [
            (flag "focus-monitor-down")
          ])
          (plain "Mod+Ctrl+Up" [
            (flag "focus-monitor-up")
          ])
          (plain "Mod+Ctrl+Right" [
            (flag "focus-monitor-right")
          ])
          (plain "Mod+Ctrl+H" [
            (flag "focus-monitor-left")
          ])
          (plain "Mod+Ctrl+J" [
            (flag "focus-monitor-down")
          ])
          (plain "Mod+Ctrl+K" [
            (flag "focus-monitor-up")
          ])
          (plain "Mod+Ctrl+L" [
            (flag "focus-monitor-right")
          ])
          (plain "Mod+Shift+Ctrl+Left" [
            (flag "move-column-to-monitor-left")
          ])
          (plain "Mod+Shift+Ctrl+Down" [
            (flag "move-column-to-monitor-down")
          ])
          (plain "Mod+Shift+Ctrl+Up" [
            (flag "move-column-to-monitor-up")
          ])
          (plain "Mod+Shift+Ctrl+Right" [
            (flag "move-column-to-monitor-right")
          ])
          (plain "Mod+Shift+Ctrl+H" [
            (flag "move-column-to-monitor-left")
          ])
          (plain "Mod+Shift+Ctrl+J" [
            (flag "move-column-to-monitor-down")
          ])
          (plain "Mod+Shift+Ctrl+K" [
            (flag "move-column-to-monitor-up")
          ])
          (plain "Mod+Shift+Ctrl+L" [
            (flag "move-column-to-monitor-right")
          ])
          (plain "Mod+Page_Down" [
            (flag "focus-workspace-down")
          ])
          (plain "Mod+Page_Up" [
            (flag "focus-workspace-up")
          ])
          (plain "Mod+U" [
            (flag "focus-workspace-down")
          ])
          (plain "Mod+I" [
            (flag "focus-workspace-up")
          ])
          (plain "Mod+Shift+Page_Down" [
            (flag "move-column-to-workspace-down")
          ])
          (plain "Mod+Shift+Page_Up" [
            (flag "move-column-to-workspace-up")
          ])
          (plain "Mod+Shift+U" [
            (flag "move-column-to-workspace-down")
          ])
          (plain "Mod+Shift+I" [
            (flag "move-column-to-workspace-up")
          ])
          (plain "Mod+Ctrl+Page_Down" [
            (flag "move-workspace-down")
          ])
          (plain "Mod+Ctrl+Page_Up" [
            (flag "move-workspace-up")
          ])
          (plain "Mod+Ctrl+U" [
            (flag "move-workspace-down")
          ])
          (plain "Mod+Ctrl+I" [
            (flag "move-workspace-up")
          ])
          (node' "Mod+Shift+WheelScrollDown" { cooldown-ms = 150; } [
            (flag "focus-workspace-down")
          ])
          (node' "Mod+Shift+WheelScrollUp" { cooldown-ms = 150; } [
            (flag "focus-workspace-up")
          ])
          (plain "Mod+WheelScrollDown" [
            (flag "focus-column-right")
          ])
          (plain "Mod+WheelScrollUp" [
            (flag "focus-column-left")
          ])
          (plain "Mod+1" [
            (leaf' "focus-workspace" 1)
          ])
          (plain "Mod+2" [
            (leaf' "focus-workspace" 2)
          ])
          (plain "Mod+3" [
            (leaf' "focus-workspace" 3)
          ])
          (plain "Mod+4" [
            (leaf' "focus-workspace" 4)
          ])
          (plain "Mod+5" [
            (leaf' "focus-workspace" 5)
          ])
          (plain "Mod+6" [
            (leaf' "focus-workspace" 6)
          ])
          (plain "Mod+7" [
            (leaf' "focus-workspace" 7)
          ])
          (plain "Mod+8" [
            (leaf' "focus-workspace" 8)
          ])
          (plain "Mod+9" [
            (leaf' "focus-workspace" 9)
          ])
          (plain "Mod+Shift+1" [
            (leaf' "move-column-to-workspace" 1)
          ])
          (plain "Mod+Shift+2" [
            (leaf' "move-column-to-workspace" 2)
          ])
          (plain "Mod+Shift+3" [
            (leaf' "move-column-to-workspace" 3)
          ])
          (plain "Mod+Shift+4" [
            (leaf' "move-column-to-workspace" 4)
          ])
          (plain "Mod+Shift+5" [
            (leaf' "move-column-to-workspace" 5)
          ])
          (plain "Mod+Shift+6" [
            (leaf' "move-column-to-workspace" 6)
          ])
          (plain "Mod+Shift+7" [
            (leaf' "move-column-to-workspace" 7)
          ])
          (plain "Mod+Shift+8" [
            (leaf' "move-column-to-workspace" 8)
          ])
          (plain "Mod+Shift+9" [
            (leaf' "move-column-to-workspace" 9)
          ])
          (plain "Mod+F" [
            (flag "toggle-window-floating")
          ])
          (plain "Mod+Shift+F" [
            (flag "toggle-windowed-fullscreen")
          ])
          (plain "Mod+Tab" [
            (flag "focus-window-previous")
          ])
          (plain "Mod+Shift+Tab" [
            (flag "switch-focus-between-floating-and-tiling")
          ])
          (plain "Mod+BracketLeft" [
            (flag "consume-or-expel-window-left")
          ])
          (plain "Mod+BracketRight" [
            (flag "consume-or-expel-window-right")
          ])
          (plain "Mod+Comma" [
            (flag "consume-window-into-column")
          ])
          (plain "Mod+Period" [
            (flag "expel-window-from-column")
          ])
          (node' "Mod+R" { repeat = false; } [
            (flag "switch-preset-column-width")
          ])
          (node' "Mod+Shift+R" { repeat = false; } [
            (flag "switch-preset-window-height")
          ])
          (plain "Mod+Ctrl+R" [
            (flag "reset-window-height")
          ])
          (node' "Mod+M" { repeat = false; } [
            (flag "maximize-column")
          ])
          (node' "Mod+Shift+M" { repeat = false; } [
            (flag "fullscreen-window")
          ])
          (plain "Mod+Z" [
            (flag "center-column")
          ])
          (node' "Mod+Minus" { repeat = false; } [
            (leaf' "set-column-width" "-10%")
          ])
          (node' "Mod+Equal" { repeat = false; } [
            (leaf' "set-column-width" "+10%")
          ])
          (node' "Mod+Shift+Minus" { repeat = false; } [
            (leaf' "set-window-height" "-10%")
          ])
          (node' "Mod+Shift+Equal" { repeat = false; } [
            (leaf' "set-window-height" "+10%")
          ])
          (plain "Print" [
            (spawn [
              sh
              "-c"
              "${flameshot} gui"
            ])
          ])
          (plain "Shift+Print" [
            (leaf' "screenshot" { show-pointer = false; })
          ])
          (plain "Ctrl+Print" [
            (leaf' "screenshot-screen" { write-to-disk = false; })
          ])
          (plain "Alt+Print" [
            (leaf' "screenshot-window" { write-to-disk = false; })
          ])
          (plain "Mod+Shift+Q" [
            (flag "quit")
          ])
          (plain "Mod+E" [
            (flag "expand-column-to-available-width")
          ])
          (plain "Mod+Shift+S" [
            (flag "toggle-keyboard-shortcuts-inhibit")
          ])
          (plain "Mod+Shift+C" [
            (flag "set-dynamic-cast-window")
          ])
          (plain "Mod+Shift+Ctrl+C" [
            (flag "clear-dynamic-cast-target")
          ])
        ])
      ];
    };
  };
}
